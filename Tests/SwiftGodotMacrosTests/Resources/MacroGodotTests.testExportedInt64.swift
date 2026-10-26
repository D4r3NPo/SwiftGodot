class Thing: SwiftGodot.Object {
    var value: Int64 = 0

    static func _mproxy_set_value(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling setter for value: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        SwiftGodotRuntime._invokeSetter(arguments, "value", object.value) {
            object.value = $0
        }
        return nil
    }

    static func _mproxy_get_value(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = _unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling getter for value: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }

        return SwiftGodotRuntime._invokeGetter(object.value)
    }

    func get_some() -> Int64 { 10 }

    static func _mproxy_get_some(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_some`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.get_some())

    }
    @inline(always)
    static func _pproxy_get_some(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_some`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.get_some()) 

    }
    @inline(always)
    static func _vproxy_get_some(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_some`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.get_some()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass()
    }

    private static func _initializeClass() {
        guard swiftGodotShouldInitializeClass(type: Thing.self) else {
            return
        }
        let className = StringName("Thing")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SwiftGodotRuntime._registerPropertyWithGetterSetter(
            className: className,
            info: SwiftGodotRuntime._propInfo(
                at: \Thing.value,
                name: "value",
                userHint: nil,
                userHintStr: nil,
                userUsage: nil
            ),
            getterName: "get_value",
            setterName: "set_value",
            getterFunction: Thing._mproxy_get_value,
            setterFunction: Thing._mproxy_set_value
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "get_some",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Int64.self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                Thing._vproxy_get_some(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                Thing._pproxy_get_some(instance, RawArguments(args: args), result)
            }
        )
    }
}
