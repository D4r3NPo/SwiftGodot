class DebugThing: SwiftGodot.Object {
    var livesChanged: SignalWithArguments<Swift.Int> {
        get {
            SignalWithArguments<Swift.Int>(target: self, signalName: "lives_changed")
        }
    }
    func do_thing(value: SwiftGodot.Variant?) -> SwiftGodot.Variant? {
        return nil
    }

    static func _mproxy_do_thing(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `do_thing`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: SwiftGodot.Variant?.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.do_thing(value: arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `do_thing`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_do_thing(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `do_thing`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: SwiftGodot.Variant? = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.do_thing(value: arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `do_thing`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_do_thing(
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
                SwiftGodotRuntime.GD.printErr("Error calling `do_thing`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: SwiftGodot.Variant?.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.do_thing(value: arg0)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass()
    }

    private static func _initializeClass() {
        guard swiftGodotShouldInitializeClass(type: DebugThing.self) else {
            return
        }
        let className = StringName("DebugThing")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SignalWithArguments<Swift.Int>.register(as: "lives_changed", in: className, names: [])
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "do_thing",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(SwiftGodot.Variant?.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(SwiftGodot.Variant?.self, name: "value")
            ],
            callFunction: { _, instance, args, count, result, error in
                DebugThing._vproxy_do_thing(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                DebugThing._pproxy_do_thing(instance, RawArguments(args: args), result)
            }
        )
    }
}
