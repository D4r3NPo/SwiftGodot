//
//  FastCall.swift
//  SwiftGodot
//
//  Specialized ("thunk") method bridging.
//
//  The generic bridge in `FastFunctionBridging.swift` routes every Godot -> Swift call
//  through an escaping Swift closure stored in `method_userdata`, a `withArguments`
//  scope, an `Arguments` wrapper and the generic `VariantConvertible` machinery.  None
//  of that is inlinable across the module boundary, so it costs the same fixed price on
//  every call no matter how trivial the signature: measured at roughly 180ns per call on
//  top of the engine's own dispatch, for a method taking and returning a single `Int64`.
//
//  godot-cpp and godot-rust do not pay this, because both generate one monomorphized
//  entry point per method signature - C++ templates and proc-macros respectively - so
//  argument marshaling is straight-line code with no indirection.
//
//  This file is the runtime half of that approach for Swift: `_registerFastMethod`
//  registers a method whose Godot entry points are plain `@convention(c)` thunks, and
//  the `_fast*` primitives are the `@inline(__always)` marshaling steps such a thunk is
//  built from.  Written by hand today; intended to be what `@Callable` emits.
//

import GDExtension

// MARK: - Thunk signatures

/// The entry point Godot invokes for a variant call (`Object.call()`, untyped GDScript,
/// signal dispatch...).
///
/// Mirrors `GDExtensionClassMethodCall`.  The C types are spelled as raw pointers so
/// that client modules - which cannot import the `GDExtension` target - can still write
/// thunks.  `instance` is the opaque `WrappedReference` installed by `object_set_instance`;
/// resolve it with ``_fastInstance(_:as:)``.  `error` points at a `GDExtensionCallError`;
/// report success with ``_fastCallSucceeded(_:)``.
public typealias FastMethodCall = @convention(c) (
    _ userData: UnsafeMutableRawPointer?,
    _ instance: UnsafeMutableRawPointer?,
    _ arguments: UnsafePointer<UnsafeRawPointer?>?,
    _ argumentCount: Int64,
    _ returnSlot: UnsafeMutableRawPointer?,
    _ error: UnsafeMutableRawPointer?
) -> Void

/// The entry point Godot invokes for a pointer call: typed GDScript, engine-internal
/// callers and other extensions, where arguments arrive already decoded rather than
/// boxed in variants.
///
/// Mirrors `GDExtensionClassMethodPtrCall`.  SwiftGodot's generic bridge registers
/// `ptrcall_func` as `nil`, which forces those callers onto the slower variant path;
/// supplying a thunk here is what lets them take the fast one.
public typealias FastMethodPtrCall = @convention(c) (
    _ userData: UnsafeMutableRawPointer?,
    _ instance: UnsafeMutableRawPointer?,
    _ arguments: UnsafePointer<UnsafeRawPointer?>?,
    _ returnSlot: UnsafeMutableRawPointer?
) -> Void

// MARK: - Registration

/// Registers a method implemented by specialized thunks rather than by the generic
/// closure bridge.
///
/// Unlike ``_registerMethod(className:name:flags:returnValue:arguments:defaultArguments:function:)``
/// this allocates no per-method userdata, performs no return-type check at call time,
/// and never materializes an `Arguments` value: the thunk receives Godot's own pointers
/// and is responsible for the whole marshaling step.
///
/// - Parameters:
///   - call: variant-call entry point, required.
///   - ptrCall: pointer-call entry point.  Optional, but supplying it is what makes
///     typed callers fast; when `nil` Godot falls back to `call`.
public func _registerFastMethod(
    className: StringName,
    name: StringName,
    flags: MethodFlags = .default,
    returnValue: PropInfo?,
    arguments: [PropInfo],
    call: FastMethodCall,
    ptrCall: FastMethodPtrCall? = nil
) {
    let argPtr = UnsafeMutablePointer<GDExtensionPropertyInfo>.allocate(capacity: arguments.count)
    defer { argPtr.deallocate() }
    let argMeta = UnsafeMutablePointer<GDExtensionClassMethodArgumentMetadata>.allocate(capacity: arguments.count)
    defer { argMeta.deallocate() }

    var i = 0
    for arg in arguments {
        argPtr[i] = arg.makeNativeStruct()
        argMeta[i] = GDExtensionClassMethodArgumentMetadata(GDEXTENSION_METHOD_ARGUMENT_METADATA_NONE.rawValue)
        i += 1
    }

    let returnMeta = GDExtensionClassMethodArgumentMetadata(GDEXTENSION_METHOD_ARGUMENT_METADATA_NONE.rawValue)
    var retInfo = GDExtensionPropertyInfo()
    if let returnValue {
        retInfo = returnValue.makeNativeStruct()
    }

    // The thunk typealiases spell Godot's `GDExtensionCallError *` as a raw pointer to
    // keep the C types out of the public API, so the function values need a cast to the
    // imported signatures.  Both differ only in the spelling of pointer parameters, so
    // the calling convention is identical.
    let callFunc = unsafeBitCast(call, to: GDExtensionClassMethodCall.self)
    let ptrCallFunc = ptrCall.map { unsafeBitCast($0, to: GDExtensionClassMethodPtrCall.self) }

    withUnsafeMutablePointer(to: &name.content) { namePtr in
        withUnsafeMutablePointer(to: &retInfo) { retInfoPtr in
            var info = GDExtensionClassMethodInfo(
                name: namePtr,
                method_userdata: nil,
                call_func: callFunc,
                ptrcall_func: ptrCallFunc,
                method_flags: UInt32(flags.rawValue),
                has_return_value: GDExtensionBool(returnValue != nil ? 1 : 0),
                return_value_info: retInfoPtr,
                return_value_metadata: returnMeta,
                argument_count: UInt32(arguments.count),
                arguments_info: argPtr,
                arguments_metadata: argMeta,
                default_argument_count: 0,
                default_arguments: nil)
            withUnsafePointer(to: &className.content) { classNamePtr in
                gi.classdb_register_extension_class_method(
                    extensionInterface.getLibrary(), classNamePtr, &info)
            }
        }
    }
}

// MARK: - Instance resolution

/// Resolves the Swift instance a thunk was invoked on, checking the dynamic type.
@inline(__always)
public func _fastInstance<T: Wrapped>(_ instance: UnsafeMutableRawPointer?, as type: T.Type = T.self) -> T? {
    guard let instance else { return nil }
    return Unmanaged<WrappedReference>.fromOpaque(instance).takeUnretainedValue().value as? T
}

/// Resolves the Swift instance a thunk was invoked on without a dynamic type check.
///
/// Godot only dispatches a method to instances of the class it was registered on, so
/// the type is already guaranteed by construction - the same assumption godot-cpp makes
/// when it `reinterpret_cast`s the instance pointer.  Skipping the check avoids a
/// `swift_dynamicCast` call, which walks class metadata and is one of the costs that
/// makes the generic bridge slow.
@inline(__always)
public func _fastInstanceUnchecked<T: Wrapped>(_ instance: UnsafeMutableRawPointer, as type: T.Type = T.self) -> T {
    let wrapper = Unmanaged<WrappedReference>.fromOpaque(instance).takeUnretainedValue()
    guard let wrapped = wrapper.value else {
        preconditionFailure("Wrapped.handle was nil, which indicates the object was cleared by Godot")
    }
    return unsafeDowncast(wrapped, to: T.self)
}

// MARK: - Call errors

/// Marks a variant call as having completed successfully.
@inline(__always)
public func _fastCallSucceeded(_ error: UnsafeMutableRawPointer?) {
    error?.assumingMemoryBound(to: GDExtensionCallError.self).pointee.error = GDEXTENSION_CALL_OK
}

// MARK: - Variant marshaling

/// The variant pointer for one argument of a variant call.
@inline(__always)
public func _fastArgument(_ arguments: UnsafePointer<UnsafeRawPointer?>?, _ index: Int) -> UnsafeMutableRawPointer? {
    guard let arguments, let argument = arguments[index] else { return nil }
    return UnsafeMutableRawPointer(mutating: argument)
}

/// Decodes an `Int64` from a variant, using Godot's cached type constructor.
@inline(__always)
public func _fastIntFromVariant(_ variant: UnsafeMutableRawPointer?) -> Int64 {
    var value: Int64 = 0
    VariantGodotInterface.intFromVariant(&value, variant)
    return value
}

/// Initializes a variant return slot with an `Int64`.
@inline(__always)
public func _fastVariantFromInt(_ value: Int64, into returnSlot: UnsafeMutableRawPointer?) {
    var value = value
    VariantGodotInterface.variantFromInt(returnSlot, &value)
}

/// Decodes a `Double` from a variant.
@inline(__always)
public func _fastDoubleFromVariant(_ variant: UnsafeMutableRawPointer?) -> Double {
    var value: Double = 0
    VariantGodotInterface.doubleFromVariant(&value, variant)
    return value
}

/// Initializes a variant return slot with a `Double`.
@inline(__always)
public func _fastVariantFromDouble(_ value: Double, into returnSlot: UnsafeMutableRawPointer?) {
    var value = value
    VariantGodotInterface.variantFromDouble(returnSlot, &value)
}

/// Extracts the native object pointer a variant holds, without building a Swift wrapper.
@inline(__always)
public func _fastObjectHandleFromVariant(_ variant: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    var handle: UnsafeMutableRawPointer? = nil
    Object.selfFromVariant(&handle, variant)
    return handle
}

/// Initializes a variant return slot from a native object pointer.
@inline(__always)
public func _fastVariantFromObjectHandle(
    _ handle: UnsafeMutableRawPointer?, into returnSlot: UnsafeMutableRawPointer?
) {
    var handle = handle
    Object.variantFromSelf(returnSlot, &handle)
}

/// The Swift wrapper this runtime recorded as its instance binding on a native object,
/// or `nil` if there is none yet.
///
/// This is how godot-cpp resolves wrappers: the binding lives in a slot on the object
/// itself, keyed by the extension's token, so the engine-side lookup is a short scan of
/// a one-entry table rather than a globally locked hash map.  Passing `nil` callbacks
/// makes the call a pure lookup - the engine will not materialize a missing binding -
/// so callers must fall back to ``getOrInitSwiftObject(nativeHandle:ownership:)`` on a
/// miss, which builds the wrapper and records the binding for next time.
///
/// Dereferencing the binding without retaining it is safe because the live-object
/// tables hold the `WrappedReference` strongly for as long as Godot has not destroyed
/// the object, and the binding free callbacks run before that happens.
@inline(__always)
public func _fastBoundWrapper(_ handle: UnsafeMutableRawPointer) -> Wrapped? {
    guard let binding = gi.object_get_instance_binding(handle, extensionInterface.getLibrary(), nil) else {
        return nil
    }
    return Unmanaged<WrappedReference>.fromOpaque(binding).takeUnretainedValue().value
}

/// Copies a variant into a return slot, whatever it holds.
@inline(__always)
public func _fastVariantCopy(from source: UnsafeMutableRawPointer?, into returnSlot: UnsafeMutableRawPointer?) {
    gi.variant_new_copy(returnSlot, source.map { UnsafeRawPointer($0) })
}

// MARK: - Pointer-call marshaling

/// Decodes an `Int64` argument of a pointer call.
@inline(__always)
public func _fastPtrInt(_ arguments: UnsafePointer<UnsafeRawPointer?>?, _ index: Int) -> Int64 {
    guard let arguments, let argument = arguments[index] else { return 0 }
    return Int64(argument.assumingMemoryBound(to: Int.self).pointee)
}

/// Decodes a native object pointer argument of a pointer call.
@inline(__always)
public func _fastPtrObjectHandle(
    _ arguments: UnsafePointer<UnsafeRawPointer?>?, _ index: Int
) -> UnsafeMutableRawPointer? {
    guard let arguments, let argument = arguments[index] else { return nil }
    return argument.assumingMemoryBound(to: UnsafeMutableRawPointer?.self).pointee
}

/// Writes a trivially-copyable value into a pointer call's return slot.
@inline(__always)
public func _fastPtrReturn<T>(_ value: T, into returnSlot: UnsafeMutableRawPointer?) {
    returnSlot?.storeBytes(of: value, as: T.self)
}
