//
//  Wrapped.swift
//
//  Created by Miguel de Icaza on 3/28/23.
//
// This is the base class for all types that Godot calls "Classes", as
// opposed to their "Built-ins".   The built-ins are a mix of structs and
// classes that have all of their payload inlined - and just differ on
// their moving semantics.
//
// The generated Godot classes can be subclassed by the user, and their
// state is preserved if the object is passed to Godot, and later it is
// resurfaced to the Swift universe.
//
// We ensure that all Godot objects that are surfaced to Swift retain their
// identity through an instance binding owned by each native Godot object.
//
#if canImport(AppKit) || canImport(UIKit)
import Foundation
#endif
import Foundation
import GDExtension

func pd (_ str: String) {
    #if false
    print("anothr")
    print ("SwiftGodot: \(str)")
    #endif
}


/// Describes the role of a Swift wrapper.
///
/// This enum is about construction context, not pointer ownership.
/// It answers where the initialization request came from.
///
/// Use this to decide wrapper/binding setup behavior for a new instance.
/// Do not use it to infer whether the surfaced object pointer is borrowed,
/// comes from an owned `Ref<>`, or already carries a return-slot lifetime.
/// That is handled separately by ``ReturnedObjectOwnership``.
enum InitOrigin {
    /// Directly from Swift
    /// For example: `let object = Object()`
    ///
    /// Swift constructs the native object first and then wraps it.
    case swift
    
    /// The object surfaced from Godot and Swift is wrapping an existing native instance.
    ///
    /// This includes paths such as:
    /// - unwrapping a ``Variant``
    /// - receiving a method return value
    /// - adopting another engine-originated object pointer
    ///
    /// This case does not imply a single ownership policy; surfaced objects may
    /// still be borrowed, come from an owned `Ref<>`, or arrive through a normal
    /// Godot API return slot.
    case godot

    /// Constructed by Godot (from GDScript) in `createFunc`
    ///
    /// Godot is creating one of our registered Swift user types and calls back
    /// into Swift to materialize the wrapper and user instance.
    case gdscript

    /// Swift is adopting a raw pointer to an object that this runtime did not create,
    /// through `init(nativeHandle:)`.
    ///
    /// This is `.swift` as far as reference counting goes - that API has always taken the
    /// initial reference on a `RefCounted` adopted this way - but not as far as instance
    /// bindings go, which is why it is a case of its own.  See ``constructedHere``.
    case adoptedHandle
}

extension InitOrigin {
    /// Whether a `RefCounted` wrapper built with this origin takes the initial reference.
    var takesInitialReference: Bool {
        switch self {
        case .swift, .gdscript, .adoptedHandle:
            return true
        case .godot:
            return false
        }
    }
}

/// Opaque pointer representing Godot `Object *`
public typealias GodotNativeObjectPointer = UnsafeMutableRawPointer

/// Just pass it to `super.init`.
public struct InitContext {
    let handle: GodotNativeObjectPointer
    let origin: InitOrigin

    /// Creates a new object of the specified className and returns an InitContext that you can
    /// use to call your constructor
    public static func createObject(className: StringName) -> InitContext? {
        var copy = className
        guard let nativeHandle = gi.classdb_construct_object(&copy.content) else {
            return nil
        }
        return InitContext(handle: nativeHandle, origin: .swift)
    }
}

///
/// The base class for all class bindings in Godot, you should not have
/// to instantiate or subclass this class directly - there are better options
/// in the hierarchy.
///
/// Wrapped implements Equatable based on an identity based on the
/// pointer to the Godot native object and also implements the Identifiable
/// protocol using this pointer.
///
/// Wrapped manages the lifecycle of these objects, and in the event that an
/// object in the Godot world has been disposed, the handle in the Wrapped
/// object will be cleared - you can detect this condition by calling `isValid`
/// on the object.
///
/// # State Management
///
/// Wrapped manages the lifecycle of these objects, and in the event that an
/// object in the Godot world has been disposed, the handle in the Wrapped
/// object will be cleared - you can detect this condition by calling `isValid`
/// on the object.
///
/// Wrapped subclasses come in two forms: straight bindings to the Godot
/// API which are used to expose capabilities to developers.   These objects, referred
/// to as Framework types do not have any additional state associated in
/// Swift.
///
/// When user subclass Wrapped, they might have state associated with them,
/// so those objects are preserved and are not thrown away until they are
/// explicitly relinquished by both Godot and any references you might hold to
/// them.   These are known as User types.   Objects can be subclassed either
/// to attach additional runtime information, or to override methods (we follow
/// the Godot conventions and the methods are prefixed with an underscore).
///
/// # LifeCycle
///
/// Some special handling is done for different objects in the Godot hierarchy.
/// The way we now handle the lifecycle of Godot objects in Swift is the following:
/// If an object is not a RefCounted, we keep a strong reference to it, so that only
/// a call to the appropriate free method can delete the object.
///
/// If an object is a RefCounted, we keep track of the reference()/unreference() calls
/// to it, and we keep a weak reference to it if there are no references to it in Godot,
/// otherwise we keep a strong reference to it. This guarantees that the object can
/// still be deleted when no reference to it exists anymore, while making sure that
/// subtyped objects keep their state on the Swift side throughout the Godot object's
/// lifetime. As the Swift wrapper also increases the reference count of the
/// RefCounted, this means that once a RefCounted is passed to the Swift side, that
/// Godot object will always be destroyed by the Swift wrapper eventually.
///
/// # Type Registration
///
/// Any subclass ends up calling the Wrapped(StringName) constructor which
/// provides the name of the most-derived framework type, and this constructor
/// determines whether this is a Framework type or a user type.
///
/// To register User types with the framework make sure you call the
/// `register<T: Object> (type: T.Type)` method like this:
///
/// `register (type: MySpinningCube.self)`
///
/// If you do not call this method, many of the overloads that Godot would
/// call you back on will not be invoked.
open class Wrapped: Equatable, Identifiable, Hashable {
    /// Points to the underlying object
    public var handle: GodotNativeObjectPointer?
    
    // The native binding owns the cell. bindingFree clears this checked link
    // before releasing that ownership, including when the Swift wrapper survives.
    unowned var wrapper: WrappedReference?
    
    public static var fcallbacks = OpaquePointer(UnsafeRawPointer(&Wrapped.bindingCallback))
    public static var ucallbacks = OpaquePointer(UnsafeRawPointer(&Wrapped.bindingCallback))
    public static var deferred: Callable? = nil

    // These exist to hold references to property list objects that are passed back to Godot,
    // but we retain ownership until `propertyListFreeFunc` is invoked, or the class is deinit'ed.
    public var propertyListStorageCache: [PropertyInfoStorage]? = nil
    public var propertyListPropInfoCache: [GDExtensionPropertyInfo]? = nil
    
    /// Conformance to Identifiable by using the native handle to the object
    public var id: Int { Int (bitPattern: handle) }
    
    public static func == (lhs: Wrapped, rhs: Wrapped) -> Bool {
        return lhs.handle == rhs.handle
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(handle)
    }
    
    /// This method returns the list of StringNames for methods that the class overwrites, and
    /// is necessary to ensure that Godot knows which methods have been overwritten, and which
    /// ones Godot will provide a default behavior for.
    ///
    /// This is necessary because the Godot overwrite method does not surface a "base" behavior
    /// that can be called into.  Instead Godot relies on the "Is the method implemented or not"
    /// to make this determination.
    ///
    /// If you are not using the `@Godot` macro, you should overwrite this function and return
    /// the StringNames for the functions you override, like in this example, where we indicate
    /// that we override the Godot `_has_point` method:
    ///
    /// ```
    /// open override func implementedOverrides() -> [StringName] {
    ///     return super.implementedOverrides + [StringName ("_has_point")]
    /// }
    /// ```
    open class func implementedOverrides() -> [StringName] {
        []
    }

    @inline(never)
    public static func attemptToUseObjectFreedByGodot() {
        fatalError ("Wrapped.handle was nil, which indicates the object was cleared by Godot")
    }
    @_spi(SwiftGodotRuntimePrivate) open class func getVirtualDispatcher(name: StringName) ->  GDExtensionClassCallVirtual? {
        pd ("SWARN: getVirtualDispatcher (\"\(name)\") reached Wrapped on class \(self)")
        return nil
    }

    // Override this to add some custom logic to the class initialization of @Godot annotated classes.
    // This function will only be called if the class in question is annotated with @Godot
    public class func initClass() {
    }

    deinit {
        // Use the following to catch the deinit happening and then the free framework
        // code running - we have no way of notifying that code that we are dead.
        #if DEBUG_DEINIT
        let opaque: UnsafeMutableRawPointer = Unmanaged.passUnretained(self).toOpaque()
        print ("Wrapped.deinit \(String(describing: opaque)) handle=\(handle)")
        if let so = self as? Object {
            if so.isValid {
                print ("   -> \(so)")
            } else {
                print("    -> \(type(of:self)) [DIED BEFORE DEINIT]")
            }
        }
        #endif
        if let handle {
            guard extensionInterface.objectShouldDeinit(object: self) else { return }
#if DEBUG_INSTANCES
            let type = String(describing: Swift.type(of: self))
            let txt = "DEINIT for object=\(type) handle=\(handle)"
#endif

            if self is RefCounted {
                // Godot may already have consumed the final native reference before
                // the Swift wrapper is torn down, especially for editor-managed resources.
                if let refCounted = self as? RefCounted, refCounted.getReferenceCount() <= 0 {
		    print("RefCounted: it was already zero, flagging as deinited.");
                    extensionInterface.objectDeinited(object: self)
                    return
                }
                guard let reference = wrapper else { return }
                let pending = PendingRelease(id: gi.object_get_instance_id(handle), reference: reference)
                var queue = false
                freeLock.withLockVoid {
                    if Wrapped.deferred == nil {
                        Wrapped.deferred = Callable ({ (args: borrowing Arguments) in
                            releasePendingObjects()
                            return nil
                        })
                    }
                    #if SWIFTGODOT_WITH_MULTI_PROCESS
                    let id = extensionInterface.getCurrenDomain()
                    pendingReleaseHandles[id, default: []].append(pending)
                    if pendingReleaseHandles[id]?.count == 1 {
                        queue = true
                    }
                    #else
                    pendingReleaseHandles.append(pending)
                    if pendingReleaseHandles.count == 1 {
                        queue = true
                    }
                    #endif
                }
                if queue {
                    Wrapped.deferred?.callDeferred()
                }
            }
        }
        propertyListStorageCache = nil
        propertyListPropInfoCache = nil
        extensionInterface.objectDeinited(object: self)
    }
    static var bindingCallback = GDExtensionInstanceBindingCallbacks(
        create_callback: bindingCreate,
        free_callback: bindingFree,
        reference_callback: bindingReference)

    /// Returns the Godot's class name as a `StringName`, returns the empty string on error
    public var godotClassName: StringName {
        var sc: StringName.ContentType = StringName.zero
        
        if gi.object_get_class_name (handle, extensionInterface.getLibrary(), &sc) != 0 {
            let sn = StringName(takingOver: sc)
            return sn
        }
        return ""
    }

    /// This method is posted by Godot, you can override this method and
    /// be notified of interesting events, the values for this notification are declared on various
    /// different types, like the constants in Object or Node.
    ///
    /// For example `Node.notificationProcess`
    open func _notification(code: Int, reversed: Bool) {
    }

    ///  Called whenever Godot retrieves value of property. Allows to customize existing properties.
    /// Return true if you made changes to the PropInfo value you got
    open func _validateProperty(_ property: inout PropInfo) -> Bool {
        return false
    }
    
    /// Override this if you want to have a property with special handling, perhaps the actual value gets stored elsewhere.
    /// - Parameters:
    ///     - property: The name of the property to set
    ///     - value: A Variant representing the value to be stored.
    /// - Returns:
    /// Return `true` if you've handled the property and stored the value supplied - or discarded it but don't wish for the standard property storage to apply.
    /// Return `false` if you don't have any special handling for the named property. Godot will store it in the usual way.
    open func _set(property: StringName, value: consuming Variant?) -> Bool {
        return false
    }

    /// Override this if you want to have a property with special handling, perhaps the actual value gets stored elsewhere. For properties stored in the
    /// standard way (such as `@Export` properties) there is no need to override default behavior and you should treat those as unhandled.
    /// - Parameters:
    ///     - property: The name of the property to get
    /// - Returns:
    /// Returns the value retieved, or `GetPropertyResult.unhandledProperty` if there is no special handling for this property. Returning
    /// `.unhandledProperty` does not neccesarily mean that the property doesn't exist, and Godot will apply its standard behavior for get() if you return this.
    open func _get(property: StringName) -> GetPropertyResult {
        return .unhandledProperty
    }

    /// Override this method if your object has non-standard properties, such as any that are dynamically created at runtime. The list of properties
    /// returned here is treats as *additional* to any standard properties (including `@Export` properties), and you cannot hide existing properties with this method.
    /// If you return any properties here, you almost certainly need to also override `_get()`, `_set()` to handle your special properties, and should consider overriding
    /// `_propertyGetRevert()` and `_propertyCanRevert()`
    ///  - Returns:
    ///    An array of PropInfos representing all the extra properties your object supports. If any of these properties clash with standard properties, the result is undefined.
    open func _getPropertyList() -> [PropInfo]? {
        return nil
    }
    
    /// Override if you want to allow reverting for the named property. You should also override `_propertyGetRevert()` Note that you do NOT have to return
    /// `true` for any properties that you are not applying special handling to. Standard properties and any `@Export` properties will be handled appropriately even
    /// if you return `false` here.
    ///  - Returns:
	/// `.unhandledProperty` if the method does not recognize the named property or chooses not to act on it. This doesn't imply the property doesn't exist,
    ///                 and it's still possible the revert can happen if another implementation in the chain responds to allow it.
    ///  `.handledProperty` if the method recognizes and handles the named property. The value will be:
    ///   `true` if the named property supports reverting - this will almost always result in a subsequent call to `_propertyGetRevert()`
    ///  `false` if the property does not support reverting.
    open func _propertyCanRevert(property: StringName) -> PropertyCanRevertResult {
		return .unhandledProperty
    }

    /// Override to return the revert value for any special properties in your class. Note that if you do not also override `_propertyCanRevert()`for the same property,
    /// this method will never be called.
    /// - Returns:
    /// If you do not handle the named property, return .unhandledProperty. If it's a standard or `@Export` property, Godot will still revert it so you don't need to worry
    /// about any of those. Otherwise return the revert value as a Variant.
    open func _propertyGetRevert(property: StringName) -> GetPropertyResult {
        return .unhandledProperty
    }

    /// Checks if this object has a script with the given method.
    /// - Parameter method: StringName identifying the method.
    /// - Returns: `true` if the object has a script and that script has a method with the given name.
    /// `false` if the object has no script.
    public func hasScript (method: StringName) -> Bool {
        guard let objectHasScriptMethod = gi.object_has_script_method else {
            fatalError("Godot interface method 'object_has_script_method' was not available at runtime.")
        }
        return objectHasScriptMethod(handle, &method.content) != 0
    }
    
    /// Invokes the specified method on the object
    /// - Parameters:
    ///  - method: the method to invoke on the target
    ///  - arguments: variable list of arguments
    /// - Returns: if there is an error, this function raises an error, otherwise, a Variant with the result is returned
    public func callScript (method: StringName, _ arguments: Variant?...) throws -> Variant? {
        var args: [UnsafeRawPointer?] = []
        let cptr = UnsafeMutableBufferPointer<Variant.ContentType>.allocate(capacity: arguments.count)
        defer { cptr.deallocate () }
        
        for idx in 0..<arguments.count {
            cptr [idx] = arguments[idx].content
            args.append (cptr.baseAddress! + idx)
        }
        var result = Variant.zero
        var error = GDExtensionCallError()
        guard let objectCallScriptMethod = gi.object_call_script_method else {
            fatalError("Godot interface method 'object_call_script_method' was not available at runtime.")
        }
        objectCallScriptMethod(handle, &method.content, &args, Int64(args.count), &result, &error)
        if error.error != GDEXTENSION_CALL_OK {
            throw toCallErrorType(error.error)
        }
        
        return Variant(takingOver: result)
    }
    
    /// For use by the framework, you should not need to call this.
    public required init(_ context: InitContext) {
        handle = context.handle
        extensionInterface.objectInited(object: self)
        bindSwiftObject(self, context)
    }
    
    /// This property indicates if the instance is valid or not.
    ///
    /// In Godot, some objects can be freed manually, and in particular
    /// when you call the ``Node/queueFree()`` which might queue the object
    /// for disposal
    public var isValid: Bool {
        return handle != nil
    }

    /// Use this to release objects that are neither Nodes or RefCounted subclasses.
    ///
    /// To release a ``Node`` or a Node subclass, call ``Node.queueFree()``,
    /// ``RefCounted`` objects are destroyed automatically when the last reference
    /// is gone, so it is not necessary to call ``free`` on those.
    public func free() {
        if let object = self as? Object, object.isClass("Node") {
            print ("SwiftGodot: Cannot call free() on Nodes; queueFree() should be used instead.")
            return
        }
        guard !(self is RefCounted) else  {
            print ("SwiftGodot: Cannot call free() on RefCounted; release all references to it instead.")
            return
        }
        guard isValid else {
            print ("SwiftGodot: free() called on an invalid object.")
            return
        }
        guard extensionInterface.objectShouldDeinit(object: self) else {
            print ("SwiftGodot: free() called with an invalid instance.")
            return
        }

        gi.object_destroy(handle)
    }
    
    open class var godotClassName: StringName {
        fatalError("Subclasses of Wrapped must override godotClassName")
    }
    
    open class var classInitializer: Void { () }
    
    /// Indicates during which engine initialization stage this class is registered. `.scene` is default. This value is taken into consideration when using `#initSwiftExtension(cdecl:types:)`  or `EntryPointGeneratorPlugin`.
    open class var classInitializationLevel: ExtensionInitializationLevel { .scene }
}

/// We can't simply extend `Wrapped`, because `convenience init` do not keep polymorphic `Self`.
public extension _GodotBridgeable where Self: Wrapped {
    /// Initialize a new object.
    init() {
        guard let nativeHandle = gi.classdb_construct_object(&Self.godotClassName.content) else {
            fatalError("SWIFT: It was not possible to construct a \(Self.godotClassName.description)")
        }
       
        self.init(InitContext(handle: nativeHandle, origin: .swift))
    }
    
    /// Delicate API.
    /// Initialize a new object from a raw handle.
    init(nativeHandle: GodotNativeObjectPointer) {
        self.init(InitContext(handle: nativeHandle, origin: .adoptedHandle))
    }
}

// The engine owns one retained reference to the binding cell. Creating the cell
// must not call back into Godot: get_instance_binding holds the native object's lock.
func bindingCreate(_ token: UnsafeMutableRawPointer?, _ instance: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    guard instance != nil else { return nil }
    return Unmanaged.passRetained(WrappedReference(nativeHandle: instance)).toOpaque()
}

@inline(always)
func liveWrappedReference(for handle: GodotNativeObjectPointer) -> WrappedReference? {
    guard let binding = gi.object_get_instance_binding(handle, extensionInterface.getLibrary(), nil) else { return nil }
    return Unmanaged<WrappedReference>.fromOpaque(binding).takeUnretainedValue()
}

@inline(always)
func instanceReference(for handle: GodotNativeObjectPointer) -> WrappedReference {
    guard let binding = gi.object_get_instance_binding(handle, extensionInterface.getLibrary(), &Wrapped.bindingCallback) else {
        preconditionFailure("Unable to install Swift instance binding")
    }
    return Unmanaged<WrappedReference>.fromOpaque(binding).takeUnretainedValue()
}

func bindSwiftObject(_ object: some Wrapped, _ context: InitContext) {
    let reference: WrappedReference
    switch context.origin {
    case .swift, .gdscript:
        // The creating extension owns slot zero. In particular, recreate_instance
        // must reuse that slot after Godot clears it during hot reload.
        reference = WrappedReference(nativeHandle: context.handle)
        gi.object_set_instance_binding(context.handle, extensionInterface.getLibrary(),
            Unmanaged.passRetained(reference).toOpaque(), &Wrapped.bindingCallback)
    case .godot, .adoptedHandle:
        reference = instanceReference(for: context.handle)
    }
    precondition(reference.value == nil, "A Swift wrapper already exists for this Godot object")
    reference.ref = object
    object.wrapper = reference

    let type = Swift.type(of: object)
    let typeName = StringName(String(describing: type))
    if typeName != type.godotClassName {
        withUnsafePointer(to: &typeName.content) { name in
            gi.object_set_instance(context.handle, name, Unmanaged.passRetained(reference).toOpaque())
        }
    }
    if let refCounted = object as? RefCounted {
        if refCounted.getReferenceCount() > 1 { reference.strongify() }
    } else {
        reference.strongify()
    }
}

var userTypes: [String: Object.Type] = [:]

@_spi(SwiftGodotRuntimePrivate) public
var duplicateClassNameDetected: (_ name: StringName, _ type: Object.Type) -> Void = { name, type in
    GD.print(
        "Godot already has a class named \(name); registering \(type) using that name may cause unexpected behavior."
    )
}

func register<T: Object>(type name: StringName, parent: StringName, type: T.Type) {
    var nameContent = name.content

    // The classdb_get_class_tag function is documented to return “a pointer uniquely identifying the given built-in class”. As of Godot 4.2.2, it also returns non-nil for types registered by extensions. If Godot is changed in the future to return nil for extension types, this will simply stop detecting duplicate class names. It won't break valid code.

    let existingClassTag = gi.classdb_get_class_tag(&nameContent)
    if existingClassTag != nil {
        duplicateClassNameDetected(name, type)
    }

    func getVirtual(_ userData: UnsafeMutableRawPointer?, _ name: GDExtensionConstStringNamePtr?) ->  GDExtensionClassCallVirtual? {
        let typeAny = Unmanaged<AnyObject>.fromOpaque(userData!).takeUnretainedValue()
        guard let type  = typeAny as? Object.Type else {
            pd ("The wrapped value did not contain a type: \(typeAny)")
            return nil
        }
        return type.getVirtualDispatcher(name: StringName (fromPtr: name))
    }
    
    var info = GDExtensionClassCreationInfo2 ()
    info.create_instance_func = createFunc(_:)
    info.free_instance_func = freeFunc(_:_:)
    info.get_virtual_func = getVirtual
    info.notification_func = notificationFunc
    info.recreate_instance_func = recreateFunc
    info.validate_property_func = validatePropertyFunc
    info.get_property_list_func = propertyListFunc
    info.free_property_list_func = propertyListFreeFunc
    info.set_func = setFunc
    info.get_func = getFunc
    info.property_can_revert_func = canRevertFunc
    info.property_get_revert_func = getRevertFunc
    info.is_exposed = 1
    
    // `type`, not `T.self`: when registration is driven from an array of metatypes - as
    // `#initSwiftExtension(types:)` and the entry-point generator do - `T` binds to the array's
    // static element type, so `T.self` would record every class as `Object`.
    userTypes[name.description] = type

    
    let retained = Unmanaged<AnyObject>.passRetained(type as AnyObject)
    info.class_userdata = retained.toOpaque()
    
    gi.classdb_register_extension_class(extensionInterface.getLibrary(), &nameContent, &parent.content, &info)
    if var extensionInterface {
        if extensionInterface.classDBReady {
            _ = type.classInitializer
        } else {
            extensionInterface.pendingInitializers.append({ _ = type.classInitializer })
        }
    }
}

@_spi(SwiftGodotRuntimePrivate) public final class WrappedReference {
    let initializationLock = NIOLock()

    var nativeHandle: GodotNativeObjectPointer?

    init(nativeHandle: GodotNativeObjectPointer?) { self.nativeHandle = nativeHandle }

    public init(_ val: Wrapped, strong: Bool = true) {
        self.ref = val
        self.nativeHandle = val.handle
        if strong {
            _ = strongify()
        }
    }
    
    deinit {
        _ = weakify()
    }

    @discardableResult
    public final func strongify() -> Self {
        if strongReference == nil, let object = ref {
            strongReference = .passRetained(object)
        }
        return self
    }

    @discardableResult
    public final func weakify() -> Self {
        let retained = strongReference
        strongReference = nil
        retained?.release()
        return self
    }

    public final func isStrong() -> Bool { strongReference != nil }

    public var value: Wrapped? {
        @inline(__always) get {
            // Loading the weak reference safely acquires a Swift reference even if
            // a native reference callback releases our strong ownership concurrently.
            return ref
        }
    }

    fileprivate weak var ref: Wrapped?
    private var strongReference: Unmanaged<Wrapped>?

}

/// Registers the user-type specified with the Godot system, and allows it to
/// receive any of the calls from Godot virtual methods (those that are prefixed
/// with an underscore)
public func register<T: Object>(type: T.Type) {
    guard let superType = Swift._getSuperclass (type) else {
        print ("You can not register the root class")
        return
    }
    let typeStr = String (describing: type)
    let superStr = String(describing: superType)
    register (type: StringName (typeStr), parent: StringName (superStr), type: type)
}

/// Register the enumeration, the enumeration must be nested into a type
public func registerEnum<T>(_ type: T.Type)
where T: RawRepresentable & CaseIterable, T.RawValue == Int64 {
    let fullname = String(reflecting: type)
    let split = fullname.split(separator: ".")
    if split.count != 3 {
        GD.print("Could not register enum \(fullname) it needs 3 components")
        return
    }

    var className = StringName(split[1])
    var enumName  = StringName(split[2])

    withUnsafePointer(to: &className.content) { classPtr in
        withUnsafePointer(to: &enumName.content) { enumPtr in
            for v in type.allCases {
                let keyString = String(describing: v)          // e.g. "foo", "bar"
                var key   = StringName(keyString)
                let value = v.rawValue                         // Int64

                withUnsafePointer(to: &key.content) { keyPtr in
                    gi.classdb_register_extension_class_integer_constant(
                        extensionInterface.getLibrary(),
                        classPtr,
                        enumPtr,
                        keyPtr,
                        value,
                        0)
                }
            }
        }
    }
}

/// Register the enumeration, the enumeration must be nested into a type
public func registerEnum<T>(_ type: T.Type)
where T: RawRepresentable & CaseIterable, T.RawValue == Int {
    let fullname = String(reflecting: type)
    let split = fullname.split(separator: ".")
    if split.count != 3 {
        GD.print("Could not register enum \(fullname) it needs 3 components")
        return
    }

    var className = StringName(split[1])
    var enumName  = StringName(split[2])

    withUnsafePointer(to: &className.content) { classPtr in
        withUnsafePointer(to: &enumName.content) { enumPtr in
            for v in type.allCases {
                let keyString = String(describing: v)          // e.g. "foo", "bar"
                var key   = StringName(keyString)
                let value = v.rawValue                         // Int64

                withUnsafePointer(to: &key.content) { keyPtr in
                    gi.classdb_register_extension_class_integer_constant(
                        extensionInterface.getLibrary(),
                        classPtr,
                        enumPtr,
                        keyPtr,
                        Int64(value),
                        0)
                }
            }
        }
    }
}

/// Internal API. Emitted by the `@Godot` macro for every nested enum declaration.
///
/// When the enum is `CaseIterable` and `RawRepresentable` with a `BinaryInteger`
/// raw value, its cases are registered with Godot as integer constants grouped
/// under the enum's name. The disfavored overload below makes this a no-op for
/// any enum that does not satisfy those constraints, so the macro can emit an
/// unconditional call without inspecting the enum's conformances.
public func _registerEnumIfPossible<T>(_ type: T.Type)
where T: RawRepresentable & CaseIterable, T.RawValue: BinaryInteger {
    let fullname = String(reflecting: type)
    let split = fullname.split(separator: ".")
    if split.count != 3 {
        GD.print("Could not register enum \(fullname) it needs 3 components")
        return
    }

    var className = StringName(split[1])
    var enumName  = StringName(split[2])

    withUnsafePointer(to: &className.content) { classPtr in
        withUnsafePointer(to: &enumName.content) { enumPtr in
            for v in type.allCases {
                let keyString = String(describing: v)          // e.g. "foo", "bar"
                var key   = StringName(keyString)
                let value = Int64(v.rawValue)

                withUnsafePointer(to: &key.content) { keyPtr in
                    gi.classdb_register_extension_class_integer_constant(
                        extensionInterface.getLibrary(),
                        classPtr,
                        enumPtr,
                        keyPtr,
                        value,
                        0)
                }
            }
        }
    }
}

/// Internal API. No-op fallback for enums that are not `CaseIterable` &
/// `RawRepresentable` with a `BinaryInteger` raw value. See the constrained
/// overload above.
@_disfavoredOverload
public func _registerEnumIfPossible<T>(_ type: T.Type) {
    // Nothing to register: the enum cannot be mapped to Godot integer constants.
}

public func unregister<T: Object>(type: T.Type) {
    let typeStr = String (describing: type)
    let name = StringName (typeStr)
    pd ("Unregistering \(typeStr)")
    withUnsafePointer (to: &name.content) { namePtr in
        gi.classdb_unregister_extension_class(extensionInterface.getLibrary(), namePtr)
    }
}

public func printSwiftGodotStats() {
    print("User types: \(userTypes.count); wrappers are owned by Godot instance bindings")
}

struct PendingRelease {
    let id: UInt64
    let reference: WrappedReference
}

// Lock for the pending free list
var freeLock = NIOLock()
#if SWIFTGODOT_WITH_MULTI_PROCESS
var pendingReleaseHandles: [UInt8: [PendingRelease]] = [:]
#else
var pendingReleaseHandles: [PendingRelease] = []
#endif

private func objectClassName(_ handle: GodotNativeObjectPointer) -> String {
    var sc: StringName.ContentType = StringName.zero
    if gi.object_get_class_name(handle, extensionInterface.getLibrary(), &sc) != 0 {
        return String(StringName(content: sc))
    }
    var result = GString()
    gi.object_method_bind_ptrcall(Object.method_get_class, handle, nil, &result.content)
    return result.description
}

private func currentRefCount(_ handle: GodotNativeObjectPointer) -> Int32? {
    let objectClass = objectClassName(handle)
    var className = FastStringName(objectClass)
    var methodName = FastStringName("get_reference_count")
    guard let bind = withUnsafePointer(to: &className.content, { classPtr in
        withUnsafePointer(to: &methodName.content) { methodPtr in
            gi.classdb_get_method_bind(classPtr, methodPtr, 3905245786)
        }
    }) else {
        return nil
    }
    var result: Int32 = 0
    gi.object_method_bind_ptrcall(bind, handle, nil, &result)
    return result
}

/// Use this function to force the disposing of any objects that were queued for destruction
/// this is called automatically by Godot's main loop iteration, but it is expose for the sake
/// of the test suite that wants to release objects without waiting for Godot to run the queue
public func releasePendingObjects() {
    var copy: [PendingRelease] = []

    freeLock.withLock {
        #if SWIFTGODOT_WITH_MULTI_PROCESS
        let id = extensionInterface.getCurrenDomain()
        copy = pendingReleaseHandles[id] ?? []
        pendingReleaseHandles.removeValue(forKey: id)
        #else
        copy = pendingReleaseHandles
        pendingReleaseHandles = []
        #endif
    }
    for pending in copy {
        // A native destructor can invalidate its binding before ObjectDB removes
        // the ID. Check the retained cell before making any call into Godot.
        guard pending.reference.nativeHandle != nil,
              let handle = gi.object_get_instance_from_id(pending.id) else { continue }

#if DEBUG
	// Expensive, calls currentRefCount.
	// Editor-managed RefCounted objects can reach zero before the deferred flush runs.
        if let refCount = currentRefCount(handle), refCount <= 0 {
	    fatalError("We had a zero refCount handle here, this should not happen")
        }
#endif

        var result: Bool = false
        gi.object_method_bind_ptrcall(RefCounted.method_unreference, handle, nil, &result)
        if result {
            gi.object_destroy(handle)
        }
    }
}

@inline(always)
func lookupLiveObject(handleAddress: GodotNativeObjectPointer) -> Wrapped? {
    liveWrappedReference(for: handleAddress)?.value
}

/// Return value for methods which may or may not return a value for a named property
public enum GetPropertyResult: ~Copyable {
	/// The method doesn't recognize or chooses not to operate on the named property. This does not neccesarily mean the property doesn't exist.
	case unhandledProperty
	/// The method handled the named property and has returned a value corresponding to it.
	case variant(FastVariant?)
	
	/// Convenience function for constructing a `GetPropertyResult` from any VariantConvertible value
	static public func from(_ value: some VariantConvertible) -> Self {
		.variant(value.toFastVariant())
	}
}

/// Return value for methods which may or may not return a value for a named property
public enum PropertyCanRevertResult: ~Copyable {
	/// The method doesn't recognize or chooses not to operate on the named property. This does not neccesarily mean the property doesn't exist.
	case unhandledProperty
	/// The method recognizes the property in question and is providing an answer as to whether revert is allowed.
	case handledProperty(canRevert: Bool)
}


/// Describes the lifetime contract of an object pointer surfaced to Swift.
///
/// This enum is about refcount behavior, not construction context.
/// It determines what is the native ownership for the pointer.
///
/// Use this when reconciling Swift wrapper identity with Godot native lifetime.
/// Do not use it to distinguish whether the wrapper was initialized from Swift,
/// from Godot, or from a GDScript-created user type. That is handled by
/// ``InitOrigin``.
@frozen
public enum ReturnedObjectOwnership {
    /// The object pointer is borrowed, so a new Swift wrapper must retain its own native ref.
    case borrowed

    /// Godot returned an owned `Ref<T>` wrapper that SwiftGodot should consume.
    case refWrapper

    /// Godot returned an object pointer directly from the API return slot.
    ///
    /// Swift should adopt this lifetime as-is. In particular, this path should
    /// neither add a fresh native reference nor consume an extra owned `Ref<>`.
    case godotApiReturn
}

// The following function makes the reference count of RefCounted objects consistent
// with the semantics of the source that surfaced them to Swift:
// - borrowed: Swift must acquire a native reference when creating the first wrapper.
// - refWrapper: Godot returned an owned Ref<> wrapper that Swift must consume.
// - godotApiReturn: Godot returned the object through a standard API return slot, so
//   Swift should adopt that lifetime without adding or consuming another reference.
@inlinable
@inline(always)
func handleReturnedObject<T: Wrapped>(
    staticType: T.Type,
    object: Wrapped?,
    ownership: ReturnedObjectOwnership,
    isExistingWrapper: Bool
) {
    switch ownership {
    case .godotApiReturn:
        return

    case .borrowed:
        if !isExistingWrapper, let refCounted = object as? RefCounted {
            refCounted.reference()
        }

    case .refWrapper:
        guard let refCounted = object as? RefCounted else { return }

        if staticType is RefCounted.Type {
            refCounted.unreference()
        } else if !isExistingWrapper {
            refCounted.reference()
        }
    }
}

@usableFromInline
func existingSwiftObject(nativeHandle: GodotNativeObjectPointer) -> Wrapped? {
    // Keep the cell local to the weak load; only the resulting wrapper escapes.
    let reference = instanceReference(for: nativeHandle)
    return reference.value
}

/// Resolves the per-object binding without a global table or thread-local lookup stack.
@inlinable
@inline(always)
public func getOrInitSwiftObject<T: Object>(nativeHandle: GodotNativeObjectPointer, ownership: ReturnedObjectOwnership) -> T? {
    if let object = existingSwiftObject(nativeHandle: nativeHandle) {
        handleReturnedObject(staticType: T.self, object: object, ownership: ownership, isExistingWrapper: true)
        return object as? T
    }
    return initializeSwiftObject(nativeHandle: nativeHandle, ownership: ownership)
}

@usableFromInline
func initializeSwiftObject<T: Object>(nativeHandle: GodotNativeObjectPointer, ownership: ReturnedObjectOwnership) -> T? {
    let reference = instanceReference(for: nativeHandle)
    return reference.initializationLock.withLock {
        if let object = reference.value {
            handleReturnedObject(staticType: T.self, object: object, ownership: ownership, isExistingWrapper: true)
            return object as? T
        }
        let type = typeOfClassOrNearestKnownParent(named: objectClassName(nativeHandle)) ?? T.self
        let object = type.init(InitContext(handle: nativeHandle, origin: .godot))
        handleReturnedObject(staticType: T.self, object: object, ownership: ownership, isExistingWrapper: false)
        if let refCounted = object as? RefCounted, refCounted.getReferenceCount() <= 1 {
            reference.weakify()
        }
        return object as? T
    }
}

func referenceFunc(_ userData: UnsafeMutableRawPointer) {
    fatalError()
}

func unreferenceFunc(_ userData: UnsafeMutableRawPointer) {
    fatalError()
}

///
/// This one is invoked by Godot when an instance of one of our types is created, and we need
/// to instantiate it.   Notice that this is different that direct instantiation from our API
func createFunc(_ userData: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    //print ("SWIFT: Creating object userData:\(String(describing: userData))")
    guard let userData else {
        print ("SwiftGodot.createFunc: Got a nil userData")
        return nil
    }
    
    let typeAny = Unmanaged<AnyObject>.fromOpaque(userData).takeUnretainedValue()
    guard let type  = typeAny as? Wrapped.Type else {
        print ("SwiftGodot.createFunc: The wrapped value did not contain a type: \(typeAny)")
        return nil
    }
    
    guard let handle = gi.classdb_construct_object(&type.godotClassName.content) else {
        fatalError("SWIFT: It was not possible to construct a \(type.godotClassName.description)")
    }

    #if SWIFTGODOT_WITH_MULTI_PROCESS
    let object = type.init(InitContext(handle: handle, origin: .gdscript))
    object.wrapper?.strongify()
    #else
    let object = type.init(InitContext(handle: handle, origin: .gdscript))
    
    // We are the createFunc, and we have no other owner to this object but ourselves
    // we need to make this a strong reference, or it dies before we return
    guard let wrapper = object.wrapper else {
        fatalError("SwiftGodot.createFunc: wrapper should have been created during binding")
    }
    
    wrapper.strongify()
    #endif
    
    return handle
}

func recreateFunc(_ userData: UnsafeMutableRawPointer?, godotObjectHandle: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    //print ("SWIFT: Recreate object userData:\(String(describing: userData))")
    guard let userData else {
        print ("Got a nil userData")
        return nil
    }
    
    guard let godotObjectHandle else {
        return nil
    }
    
    let typeAny = Unmanaged<AnyObject>.fromOpaque(userData).takeUnretainedValue()
    guard let type  = typeAny as? Wrapped.Type else {
        print ("SwiftGodot.recreateFunc: The wrapped value did not contain a type: \(typeAny)")
        return nil
    }
    #if SWIFTGODOT_WITH_MULTI_PROCESS
    let object = type.init(InitContext(handle: godotObjectHandle, origin: .gdscript))
    guard let wrapper = object.wrapper else { return nil }
    wrapper.strongify()
    #else
    let object = type.init(InitContext(handle: godotObjectHandle, origin: .gdscript))

    // Just like in createFunc
    // we need to make this a strong reference, or it dies before we return
    guard let wrapper = object.wrapper else {
        fatalError("SwiftGodot.recreateFunc: wrapper should have been created during binding")
    }

    wrapper.strongify()
    #endif

    // `create_instance_func` and `recreate_instance_func` do NOT return the same thing:
    //
    //   GDExtensionObjectPtr        (*GDExtensionClassCreateInstance)(void *userdata);
    //   GDExtensionClassInstancePtr (*GDExtensionClassRecreateInstance)(void *userdata, GDExtensionObjectPtr);
    //
    // Create returns the Godot object.  Recreate returns the *instance data*, which Godot assigns
    // straight to `_extension_instance` (`Object::reset_internal_extension`).  Every callback in
    // this file - `notificationFunc`, `validatePropertyFunc`, `freeFunc`, the virtual dispatchers -
    // reads that pointer back as an `Unmanaged<WrappedReference>`.
    //
    // Returning `godotObjectHandle` here therefore left `_extension_instance` holding an
    // `Object *`, and the first notification after a hot reload - `NOTIFICATION_EXTENSION_RELOADED`,
    // sent by `GDExtension::finish_reload` - read it as a `WrappedReference` and jumped through a
    // garbage vtable.  That crash was the whole reason GDExtension hot reload did not work for
    // SwiftGodot.
    //
    // `bindSwiftObject` has already installed exactly this pointer via `object_set_instance`, with
    // the retain that `freeFunc` balances, so returning it unretained leaves ownership identical to
    // the create path: Godot writes back the value that is already there.
    return Unmanaged.passUnretained(wrapper).toOpaque()
}

//
// This is invoked to release any Subtyped objects we created
//
func freeFunc (_ userData: UnsafeMutableRawPointer?, _ objectHandle: UnsafeMutableRawPointer?) {
//    #if true
//    // Just needed for debugging
//    let typeAny = Unmanaged<AnyObject>.fromOpaque(userData!).takeUnretainedValue()
//    guard let type  = typeAny as? Wrapped.Type else {
//        print ("SWIFT: FreeFunc wrapped value did not contain a type: \(typeAny)")
//        return
//    }
//    print ("SWIFT: Destroying object, userData: \(typeAny) objectHandle: \(objectHandle)")
//    #endif

    guard let objectHandle else { return }
    // Release the unmanaged reference that was retained in bindGodotInstance()
    Unmanaged<WrappedReference>.fromOpaque(objectHandle).release()
}

func notificationFunc (ptr: UnsafeMutableRawPointer?, code: Int32, reversed: UInt8) {
    guard let ptr else { return } 
    let original = Unmanaged<WrappedReference>.fromOpaque(ptr).takeUnretainedValue()
    guard let instance = original.value else { return }
    instance._notification(code: Int(code), reversed: reversed != 0)
}

func validatePropertyFunc(ptr: UnsafeMutableRawPointer?, _info: UnsafeMutablePointer<GDExtensionPropertyInfo>?) -> UInt8 {
    guard let ptr else { return 0 }
    let original = Unmanaged<WrappedReference>.fromOpaque(ptr).takeUnretainedValue()
    guard let instance = original.value else { return 0 }
    guard let info = _info?.pointee else { return 0 }
    guard let namePtr = info.name,
          let classNamePtr = info.class_name,
          let infoHintPtr = info.hint_string else {
        return 0
    }
    guard let ptype = Variant.GType(rawValue: Int64(info.type.rawValue)) else { return 0 }
    let pname = StringName(fromPtr: namePtr)
    let className = StringName(fromPtr: classNamePtr)
    let hint = PropertyHint(rawValue: Int64(info.hint)) ?? .none
    let hintStr = GString(content: infoHintPtr.load(as: Int64.self))
    let usage = PropertyUsageFlags(rawValue: Int(info.usage))

    var pinfo = PropInfo(propertyType: ptype, propertyName: pname, className: className, hint: hint, hintStr: hintStr, usage: usage)
    if instance._validateProperty(&pinfo) {
        // The problem with the code below is that it does not make a copy of the StringName and String,
        // and passes a reference that we will destroy right away when `pinfo` goes out of scope.
        //
        // For now, we just update the usage, type and hint but we need to find a solution for those other fields
        //let native = pinfo.makeNativeStruct()
        _info?.pointee.usage = UInt32(pinfo.usage.rawValue)
        _info?.pointee.hint = UInt32(pinfo.hint.rawValue)
        _info?.pointee.type = GDExtensionVariantType(GDExtensionVariantType.RawValue (pinfo.propertyType.rawValue))

        return 1
    }
    return 0
}

/// Allows subclasses to override the behavior of `set()` via our own `_set()` function.
/// - Returns:
/// Returns 0 if there is no special handling of the named property. This allows the normal behavior of get() to work, so classes which subclass `_set()` don't have to (and indeed,
/// should NOT) respond with 1 for standard properties.  When 1 is returned, you are indicating that the value passed in valuePtr was stored/retained.
func setFunc(ptr: UnsafeMutableRawPointer?, namePtr: UnsafeRawPointer?, valuePtr: UnsafeRawPointer? ) -> UInt8
{
    guard let ptr,
        let valuePtr else { return 0 }
    let original = Unmanaged<WrappedReference>.fromOpaque(ptr).takeUnretainedValue()
    guard let instance = original.value else { return 0 }
    let pname = StringName(fromPtr: namePtr)
    
    if let variant = Variant(copying: valuePtr.bindMemory(to: VariantContent.self, capacity: 1).pointee),
       instance._set(property: pname, value: variant) {
        return 1
    }
    
    return 0
}

/// Allows subclasses to override the behavior of `get()` via our own `_get()` function.
/// - Returns:
/// Returns 0 if there is no special handling of the named property. This allows the normal behavior of get() to work, so classes which subclass `_get()` don't have to (and indeed,
/// should NOT) respond with 1 for standard properties.  When 1 is returned, retValuePtr will point to a Variant representing the value of the property.
func getFunc(ptr: UnsafeMutableRawPointer?, namePtr: UnsafeRawPointer?, retValuePtr: UnsafeMutableRawPointer?) -> UInt8 {
    guard let ptr else { return 0 }
    let original = Unmanaged<WrappedReference>.fromOpaque(ptr).takeUnretainedValue()
    guard let instance = original.value else { return 0 }
    let pname = StringName(fromPtr: namePtr)

    let result = instance._get(property: pname)
    switch consume result {
        case .unhandledProperty:
            return 0
        case let .variant(fastVariant):
            if let fastVariant {
                retValuePtr?.storeBytes(of: fastVariant.content, as: VariantContent.self)
                fastVariant.unsafelyForget() // Godot assumed ownership over `fastVariant.content`
                return 1
            }
    }
    return 0
}

/// If our instance overrides `_getPropertyList(), we return those properties to Godot. Godot treats these
/// as additive to any existing properties the object has, and thus doesn't allow us to directly override getPropertyList()
func propertyListFunc(ptr: UnsafeMutableRawPointer?, countPtr: UnsafeMutablePointer<UInt32>?) -> UnsafePointer<GDExtensionPropertyInfo>? {
    guard let ptr else { return nil }
    let original = Unmanaged<WrappedReference>.fromOpaque(ptr).takeUnretainedValue()
    guard let instance = original.value else { return nil }

    if let propertyList = instance._getPropertyList() {
        let propertyListData = propertyList.map { $0.makeOwnedNativeStruct() }
        // Save the PropertyInfoStorage objects so that Swift doesn't free them - these
        // hold the backing reference for StringNames and other items we're about to return.
        // Note: Godot is not expected to call this function multiple times without first calling the propertyListFreeFunc
        // in between, so we can just overwrite whatever's already stored. We could assert that it's currently `nil` for
        // extra safety?
        instance.propertyListStorageCache = propertyListData.map { $0.0 }
        
        var gdPropInfo: [GDExtensionPropertyInfo] = .init()
        // Ensure the elements have contiguous storage
        gdPropInfo.reserveCapacity(propertyListData.count)
        gdPropInfo.append(contentsOf: propertyListData.map{  $0.1 })
        instance.propertyListPropInfoCache = gdPropInfo

        countPtr?.pointee = UInt32(propertyListData.count)
        return UnsafePointer<GDExtensionPropertyInfo>(gdPropInfo)
    }
    
    countPtr?.pointee = 0
    return nil
}

/// Frees previously cached propertly list information because Godot is finished with it.
func propertyListFreeFunc(ptr: UnsafeMutableRawPointer?, list: UnsafePointer<GDExtensionPropertyInfo>?)
{
    guard let ptr else { return }
    let original = Unmanaged<WrappedReference>.fromOpaque(ptr).takeUnretainedValue()
    guard let instance = original.value else { return }
    instance.propertyListStorageCache = nil
    instance.propertyListPropInfoCache = nil
}

/// Allows subclasses to override the behavior of `propertyCanRevert()` via our own `_propertyCanRevert()` function.
/// - Returns:
/// Returns 0 if the property doesn't support reverting, or 1 if it does. Note that Godot doesn't treat this response as definitive, instead if it finds any 1 response
/// in its known hierarchy then it treats the overall response as a 1/true.
func canRevertFunc(ptr: UnsafeMutableRawPointer?, namePtr: UnsafeRawPointer?) -> UInt8 {
    guard let ptr else { return 0 }
    let original = Unmanaged<WrappedReference>.fromOpaque(ptr).takeUnretainedValue()
    guard let instance = original.value else { return 0 }
    let pname = StringName(fromPtr: namePtr)
    
    var canRevert: Bool = false
    switch instance._propertyCanRevert(property: pname)
    {
        case .unhandledProperty:
            return 0
        case .handledProperty(let result):
            return result ? 1 : 0
    }

    return 0
}

/// Allows subclasses to override the behavior of `propertyGetRevert()` via our own `_propertyGetRevert()` function.
/// - Returns:
/// Returns 0 if no there is no revert available for the named property. If there is, returns 1 and supplies a Variant in the retValuePtr parameter, representing the
/// reverted value for the named property.
func getRevertFunc(ptr: UnsafeMutableRawPointer?, namePtr: UnsafeRawPointer?, retValuePtr: UnsafeMutableRawPointer?) -> UInt8 {
    guard let ptr else { return 0 }
    let original = Unmanaged<WrappedReference>.fromOpaque(ptr).takeUnretainedValue()
    guard let instance = original.value else { return 0 }
    let pname = StringName(fromPtr: namePtr)

    let result = instance._propertyGetRevert(property: pname)
    switch consume result {
        case .unhandledProperty:
            return 0
        case let .variant(fastVariant):
            if let fastVariant {
                retValuePtr?.storeBytes(of: fastVariant.content, as: VariantContent.self)
                fastVariant.unsafelyForget() // Godot assumed ownership over `fastVariant.content`
                return 1
            }
    }
    
    return 0
}

func bindingReference(_ token: UnsafeMutableRawPointer?, _ binding: UnsafeMutableRawPointer?, _ reference: UInt8) -> UInt8 {
    guard let binding else { return 0 }
    let ref = Unmanaged<WrappedReference>.fromOpaque(binding).takeUnretainedValue()
    weak var refCounted = ref.value as? RefCounted

    guard let rc = refCounted?.getReferenceCount() else {
        // unreference() was called by Wrapped.deinit, so we allow the object to be destroyed.
        return 1
    }
    
    if reference != 0 {
        // In addition to a reference by SwiftGodot, Godot also retained a reference.
        if rc == 2 {
            if let refCounted, refCounted.handle != nil {
                ref.strongify()
            }
        }
    } else {
        // Only SwiftGodot holds a reference, so we make the Wrapped's deinit available.
        if rc == 1 {
            if let refCounted, refCounted.handle != nil {
                ref.weakify()
            }
        }
    }
    
    // As long as the Wrapped's deinit is not called, we do not allow the object to be destroyed.
    return 0
}

func bindingFree(_ token: UnsafeMutableRawPointer?, _ instance: UnsafeMutableRawPointer?, _ binding: UnsafeMutableRawPointer?) {
    guard let binding else { return }
    let reference = Unmanaged<WrappedReference>.fromOpaque(binding).takeRetainedValue()
    // Invalidate before releasing the strong Swift reference: deinit must not enqueue
    // an unreference against the object currently being destroyed.
    reference.nativeHandle = nil
    if let object = reference.value {
        object.handle = nil
        object.wrapper = nil
    }
    reference.weakify()
}

/// This function is called by Godot to invoke our callable, and contains our context in `userData`,
/// pointer to Variants, an argument count, and a way of returing an error.
/// We extract the arguments and call  the CallableWrapper.invoke.
func invokeWrappedCallable(wrapperPtr: UnsafeMutableRawPointer?, pargs: UnsafePointer<UnsafeRawPointer?>?, argc: Int64, retPtr: UnsafeMutableRawPointer?, err: UnsafeMutablePointer<GDExtensionCallError>?) {
    guard let wrapperPtr else { return }
    
    withArguments(pargs: pargs, argc: argc) { arguments in
        wrapperPtr
            .assumingMemoryBound(to: CallableWrapper.self)
            .pointee
            .invoke(arguments: arguments, retPtr: retPtr, err: err)
    }
}

func freeCallableWrapper(wrapperPtr: UnsafeMutableRawPointer?) {
    guard let wrapperPtr = wrapperPtr?.assumingMemoryBound(to: CallableWrapper.self) else { return }
    wrapperPtr.deinitialize(count: 1)
    wrapperPtr.deallocate()
}

struct CallableWrapper {
    let function: (borrowing Arguments) -> Variant?
        
    func invoke(arguments: borrowing Arguments, retPtr: UnsafeMutableRawPointer?, err: UnsafeMutablePointer<GDExtensionCallError>?) {
        if let methodRet = function(arguments) {
            gi.variant_new_copy(retPtr, &methodRet.content)            
        }
        err?.pointee.error = GDEXTENSION_CALL_OK
    }
    
    @available(*, deprecated, message: "Use version taking `@escaping (borrowing Arguments) -> Variant?` instead.")    
    static func callableVariantContent(wrapping function: @escaping ([Variant?]) -> Variant?) -> Callable.ContentType {
        callableVariantContent { (arguments: borrowing Arguments) in
            let array = Array(arguments)
            let result = function(array)
            return result
        }
    }
    
    static func callableVariantContent(wrapping function: @escaping (borrowing Arguments) -> Variant?) -> Callable.ContentType {
        let wrapperPtr = UnsafeMutablePointer<Self>.allocate(capacity: 1)
        wrapperPtr.initialize(to: Self(function: function))
        
        var cci = GDExtensionCallableCustomInfo(
            callable_userdata: wrapperPtr,
            token: extensionInterface.getLibrary(),
            object_id: 0,
            call_func: invokeWrappedCallable,
            is_valid_func: nil,
            free_func: freeCallableWrapper,
            hash_func: nil,
            equal_func: nil,
            less_than_func: nil,
            to_string_func: nil)
        var content: Callable.ContentType = Callable.zero
        gi.callable_custom_create(&content, &cci);
        return content
    }
}

@available(*, unavailable, message: "Wrappers are owned by per-object instance bindings and cannot be globally enumerated.")
public func getActiveHandles() -> [GodotNativeObjectPointer] { [] }

@available(*, unavailable, message: "Free the native objects or their instance bindings before unloading the runtime.")
public func clearHandles(_ handles: [GodotNativeObjectPointer]) {}

/// Looks up the class at runtime
fileprivate func lookupGodotType(named className: String) -> AnyClass? {
    // The format is:
    // MODULE: LENGHT + String
    // Type: LENGHT + String
    // C
    //
    // So "SwiftGodot.Node" becomes "10SwiftGodot4NodeC":
    //
    let candidates: [String] = [
        "10SwiftGodot\(className.count)\(className)C",
        "17SwiftGodotRuntime\(className.count)\(className)C",
    ]
    for typeCode in candidates {
#if canImport(UIKit) || canImport(AppKit)
        if let ctor = NSClassFromString(typeCode) {
            return ctor
        }
#else
        if let ctor = _typeByName(typeCode) {
            return ctor as? AnyClass
        }
#endif
    }
    return nil
}
/// Find existing Godot or User `Wrapped.Type` having a `className`
func typeOfClass(named className: String) -> Object.Type? {
    if let userType = userTypes[className] {
        return userType
    }
    if let type = lookupGodotType(named: className) as? Object.Type {
        return type
    }
    return nil
}

func typeOfClassOrNearestKnownParent(named className: String) -> Object.Type? {
    var current = StringName(className)

    while current != "" {
        if let type = typeOfClass(named: current.description) {
            return type
        }

        current = ClassDB.getParentClass(current)
    }

    return nil
}
