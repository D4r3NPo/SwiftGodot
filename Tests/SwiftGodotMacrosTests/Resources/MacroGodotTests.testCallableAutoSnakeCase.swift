class TestClass: Node {
    func noNeedToSnakeCaseFunctionsNow() {}

    static func _mproxy_noNeedToSnakeCaseFunctionsNow(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `noNeedToSnakeCaseFunctionsNow`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.noNeedToSnakeCaseFunctionsNow())

    }
    @inline(always)
    static func _pproxy_noNeedToSnakeCaseFunctionsNow(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `noNeedToSnakeCaseFunctionsNow`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.noNeedToSnakeCaseFunctionsNow()) 

    }
    @inline(always)
    static func _vproxy_noNeedToSnakeCaseFunctionsNow(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `noNeedToSnakeCaseFunctionsNow`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.noNeedToSnakeCaseFunctionsNow()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }
    func or_is_there() {}

    static func _mproxy_or_is_there(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `or_is_there`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.or_is_there())

    }
    @inline(always)
    static func _pproxy_or_is_there(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `or_is_there`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.or_is_there()) 

    }
    @inline(always)
    static func _vproxy_or_is_there(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `or_is_there`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.or_is_there()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }
    func thatIsHideous() {}

    static func _mproxy_thatIsHideous(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `thatIsHideous`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.thatIsHideous())

    }
    @inline(always)
    static func _pproxy_thatIsHideous(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `thatIsHideous`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.thatIsHideous()) 

    }
    @inline(always)
    static func _vproxy_thatIsHideous(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `thatIsHideous`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.thatIsHideous()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }
    func defaultIsLegacyCompatible() {}

    static func _mproxy_defaultIsLegacyCompatible(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `defaultIsLegacyCompatible`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.defaultIsLegacyCompatible())

    }
    @inline(always)
    static func _pproxy_defaultIsLegacyCompatible(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `defaultIsLegacyCompatible`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.defaultIsLegacyCompatible()) 

    }
    @inline(always)
    static func _vproxy_defaultIsLegacyCompatible(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `defaultIsLegacyCompatible`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.defaultIsLegacyCompatible()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass()
    }

    private static func _initializeClass() {
        guard swiftGodotShouldInitializeClass(type: TestClass.self) else {
            return
        }
        let className = StringName("TestClass")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "no_need_to_snake_case_functions_now",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                TestClass._vproxy_noNeedToSnakeCaseFunctionsNow(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                TestClass._pproxy_noNeedToSnakeCaseFunctionsNow(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "or_is_there",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                TestClass._vproxy_or_is_there(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                TestClass._pproxy_or_is_there(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "thatIsHideous",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                TestClass._vproxy_thatIsHideous(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                TestClass._pproxy_thatIsHideous(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "defaultIsLegacyCompatible",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                TestClass._vproxy_defaultIsLegacyCompatible(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                TestClass._pproxy_defaultIsLegacyCompatible(instance, RawArguments(args: args), result)
            }
        )
    }
}
