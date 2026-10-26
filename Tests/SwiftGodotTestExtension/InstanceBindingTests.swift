@testable import SwiftGodot
import GDExtension
@_spi(SwiftGodotRuntimePrivate) @testable import SwiftGodotRuntime

@Godot
final class BindingTestNode: Node {
    var state: Int = 42

    @Callable func readState() -> Int { state }
    @Callable func identity(_ node: Node?) -> Node? { node }
    @Callable static func constant() -> Int { 73 }

    @Callable func destroyAndReadState() -> Int {
        gi.object_destroy(handle)
        return state
    }

    @Callable func destroyArgumentAndReadState(_ node: BindingTestNode) -> Int {
        gi.object_destroy(node.handle)
        return node.state
    }
}

@SwiftGodotTestSuite
final class InstanceBindingTests {
    public static var registeredTypes: [Object.Type] { [BindingTestNode.self] }

    public func testWrapperIdentityAndUserState() {
        let node = BindingTestNode()
        node.state = 91
        let resolved: Node? = getOrInitSwiftObject(nativeHandle: node.handle!, ownership: .borrowed)
        assertTrue(resolved === node)
        assertEqual((resolved as? BindingTestNode)?.state, 91)
        gi.object_destroy(node.handle)
        assertFalse(node.isValid)
    }

    public func testFirstEngineWrapperAndRepeatedResolution() {
        let name = StringName("Node")
        let handle = gi.classdb_construct_object(&name.content)!
        let first: Node? = getOrInitSwiftObject(nativeHandle: handle, ownership: .borrowed)
        let second: Object? = getOrInitSwiftObject(nativeHandle: handle, ownership: .borrowed)
        assertTrue(first != nil)
        assertTrue(first === second)
        gi.object_destroy(handle)
        assertFalse(first!.isValid)
    }

    public func testClearingBindingInvalidatesAndAllowsNewWrapper() {
        let original = Node()
        let handle = original.handle!
        gi.object_free_instance_binding(handle, extensionInterface.getLibrary())
        assertFalse(original.isValid)
        assertNil(original.wrapper)
        let replacement: Node? = getOrInitSwiftObject(nativeHandle: handle, ownership: .borrowed)
        assertTrue(replacement != nil)
        assertFalse(replacement === original)
        gi.object_destroy(handle)
        assertFalse(replacement!.isValid)
        assertNil(replacement!.wrapper)
    }

    public func testBindingOwnsNodeUntilNativeDestruction() {
        weak var weakNode: Node?
        var handle: GodotNativeObjectPointer!
        do {
            let node = Node()
            weakNode = node
            handle = node.handle
        }
        assertTrue(weakNode != nil)
        gi.object_destroy(handle)
        assertTrue(weakNode == nil)
    }

    public func testBindingDoesNotKeepRefCountedAlive() {
        weak var weakResource: Resource?
        var id: UInt64 = 0
        do {
            let resource = Resource()
            weakResource = resource
            id = UInt64(resource.getInstanceId())
            let resolved: Object? = getOrInitSwiftObject(nativeHandle: resource.handle!, ownership: .borrowed)
            assertTrue(resolved === resource)
            assertEqual(resource.getReferenceCount(), 1)
        }
        assertTrue(weakResource == nil)
        releasePendingObjects()
        assertTrue(gi.object_get_instance_from_id(id) == nil)
    }

    public func testNativeReferenceKeepsWrapperAndStateAlive() {
        var resource: Resource? = Resource()
        weak var weakResource = resource
        let handle = resource!.handle!
        let id = resource!.getInstanceId()
        resource!.reference()
        resource = nil
        assertTrue(weakResource != nil)
        do {
            let resurfaced: Resource? = getOrInitSwiftObject(nativeHandle: handle, ownership: .borrowed)
            assertTrue(resurfaced === weakResource)
            assertEqual(resurfaced?.getReferenceCount(), 2)
            resurfaced?.unreference()
        }
        assertTrue(weakResource == nil)
        releasePendingObjects()
        assertTrue(gi.object_get_instance_from_id(UInt64(id)) == nil)
    }

    public func testWrapperCanResurfaceBeforeDeferredUnreference() {
        var handle: GodotNativeObjectPointer!
        do { handle = Resource().handle }
        do {
            let resurfaced: Resource? = getOrInitSwiftObject(nativeHandle: handle, ownership: .borrowed)
            assertTrue(resurfaced != nil)
            assertEqual(resurfaced?.getReferenceCount(), 2)
            releasePendingObjects()
            assertEqual(resurfaced?.getReferenceCount(), 1)
        }
        releasePendingObjects()
    }

    public func testDeferredReleaseSkipsDestroyedNativeObject() {
        var handle: GodotNativeObjectPointer!
        do { handle = Resource().handle }
        gi.object_destroy(handle)
        releasePendingObjects()
    }

    public func testZeroArgumentInstanceAndStaticPtrcalls() {
        let node = BindingTestNode()
        var result: Int = 0
        let instance = Unmanaged.passUnretained(node.wrapper!).toOpaque()
        BindingTestNode._pproxy_readState(instance, RawArguments(args: nil), &result)
        assertEqual(result, 42)
        BindingTestNode._pproxy_constant(nil, RawArguments(args: nil), &result)
        assertEqual(result, 73)
        assertEqual(node.call(method: "readState"), Variant(42))
        gi.object_destroy(node.handle)
    }

    public func testSpecializedCallbackRejectsInvalidArgumentCounts() {
        var error = GDExtensionCallError()
        BindingTestNode._vproxy_constant(nil, nil, 1, nil, &error)
        assertTrue(error.error == GDEXTENSION_CALL_ERROR_TOO_MANY_ARGUMENTS)
        assertEqual(error.expected, 0)
        BindingTestNode._vproxy_identity(nil, nil, 0, nil, &error)
        assertTrue(error.error == GDEXTENSION_CALL_ERROR_TOO_FEW_ARGUMENTS)
        assertEqual(error.expected, 1)
    }

    public func testObjectPtrcallSurfacesEngineNodeAndNil() {
        let receiver = BindingTestNode()
        let name = StringName("Node")
        var handle = gi.classdb_construct_object(&name.content)
        let nativeHandle = handle!
        let instance = Unmanaged.passUnretained(receiver.wrapper!).toOpaque()
        var result: GodotNativeObjectPointer?
        withUnsafePointer(to: &handle) { slot in
            var argument: UnsafeRawPointer? = UnsafeRawPointer(slot)
            withUnsafePointer(to: &argument) { args in
                BindingTestNode._pproxy_identity(instance, RawArguments(args: args), &result)
                assertTrue(result == nativeHandle)
            }
        }
        handle = nil
        withUnsafePointer(to: &handle) { slot in
            var argument: UnsafeRawPointer? = UnsafeRawPointer(slot)
            withUnsafePointer(to: &argument) { args in
                BindingTestNode._pproxy_identity(instance, RawArguments(args: args), &result)
                assertTrue(result == nil)
            }
        }
        gi.object_destroy(nativeHandle)
        gi.object_destroy(receiver.handle)
    }
    public func testReceiverSurvivesNativeDestructionDuringCallback() {
        var node: BindingTestNode? = BindingTestNode()
        weak var weakNode = node
        let instance = Unmanaged.passUnretained(node!.wrapper!).toOpaque()
        node = nil
        var result = 0
        BindingTestNode._pproxy_destroyAndReadState(instance, RawArguments(args: nil), &result)
        assertEqual(result, 42)
        assertNil(weakNode)
    }

    public func testArgumentSurvivesNativeDestructionDuringCallback() {
        let receiver = BindingTestNode()
        var argument: BindingTestNode? = BindingTestNode()
        argument!.state = 93
        weak var weakArgument = argument
        var handle = argument!.handle
        argument = nil
        var result = 0
        let instance = Unmanaged.passUnretained(receiver.wrapper!).toOpaque()
        withUnsafePointer(to: &handle) { slot in
            var pointer: UnsafeRawPointer? = UnsafeRawPointer(slot)
            withUnsafePointer(to: &pointer) { (args: UnsafePointer<UnsafeRawPointer?>) in
                BindingTestNode._pproxy_destroyArgumentAndReadState(instance, RawArguments(args: args), &result)
            }
        }
        assertEqual(result, 93)
        assertNil(weakArgument)
        gi.object_destroy(receiver.handle)
    }

}
