class MyThing: SwiftGodot.RefCounted {

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass()
    }

    private static func _initializeClass() {
        guard swiftGodotShouldInitializeClass(type: MyThing.self) else {
            return
        }
        let className = StringName("MyThing")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
    }

}

class OtherThing: SwiftGodot.Node {
    func do_string(value: String?) { }

    static func _mproxy_do_string(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `do_string`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: String?.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.do_string(value: arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `do_string`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_do_string(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `do_string`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: String? = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.do_string(value: arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `do_string`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_do_string(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 1, maximum: 1, error: callError, returnValue: returnValue) else { return }
        let arguments = SwiftGodotRuntime.Arguments(pargs: variantArgs, argc: argc)
    do {
                guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `do_string`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: String?.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.do_string(value: arg0)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }

    func do_int(value: Int?) {  }

    static func _mproxy_do_int(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `do_int`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Int?.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.do_int(value: arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `do_int`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_do_int(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `do_int`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Int? = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.do_int(value: arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `do_int`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_do_int(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 1, maximum: 1, error: callError, returnValue: returnValue) else { return }
        let arguments = SwiftGodotRuntime.Arguments(pargs: variantArgs, argc: argc)
    do {
                guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `do_int`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Int?.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.do_int(value: arg0)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }

    func get_thing() -> MyThing? {
        return nil
    }

    static func _mproxy_get_thing(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_thing`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.get_thing())

    }
    @inline(always)
    static func _pproxy_get_thing(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_thing`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.get_thing()) 

    }
    @inline(always)
    static func _vproxy_get_thing(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_thing`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.get_thing()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass()
    }

    private static func _initializeClass() {
        guard swiftGodotShouldInitializeClass(type: OtherThing.self) else {
            return
        }
        let className = StringName("OtherThing")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "do_string",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(String?.self, name: "value")
            ],
            callFunction: { _, instance, args, count, result, error in
                OtherThing._vproxy_do_string(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                OtherThing._pproxy_do_string(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "do_int",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Int?.self, name: "value")
            ],
            callFunction: { _, instance, args, count, result, error in
                OtherThing._vproxy_do_int(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                OtherThing._pproxy_do_int(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "get_thing",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(MyThing?.self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                OtherThing._vproxy_get_thing(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                OtherThing._pproxy_get_thing(instance, RawArguments(args: args), result)
            }
        )
    }
}
