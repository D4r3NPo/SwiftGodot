class OtherThing: SwiftGodot.Node {            
    var foo: Int = 0

    static func _mproxy_set_foo(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for foo: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "foo", object.foo) {
            object.foo = $0
        }
        return nil
    }

    static func _mproxy_get_foo(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for foo: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.foo)
    }

    func get_foo() -> MyThing? {
        return nil
    }

    static func _mproxy_get_foo(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_foo`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.get_foo())

    }
    @inline(always)
    static func _pproxy_get_foo(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_foo`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.get_foo()) 

    }
    @inline(always)
    static func _vproxy_get_foo(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_foo`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.get_foo()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }
}
