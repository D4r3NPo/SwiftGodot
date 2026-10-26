class Greeter: Node {
    func greet(_ name: String, greeting: String = "Hello", times: Int = 1) -> String {
        Array(repeating: "\(greeting), \(name)", count: times).joined(separator: " ")
    }

    static func _mproxy_greet(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `greet`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: String.self, at: 0)
            let arg1 = arguments.count > 1 ? try arguments.argument(ofType: String.self, at: 1) : ("Hello" as String)
            let arg2 = arguments.count > 2 ? try arguments.argument(ofType: Int.self, at: 2) : (1 as Int)
            return SwiftGodotRuntime._wrapCallableResult(object.greet(arg0, greeting: arg1, times: arg2))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `greet`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_greet(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `greet`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: String = try rargs.fetchArgument(at: 0)
        let arg1: String = try rargs.fetchArgument(at: 1)
        let arg2: Int = try rargs.fetchArgument(at: 2)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.greet(arg0, greeting: arg1, times: arg2)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `greet`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_greet(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 1, maximum: 3, error: callError, returnValue: returnValue) else { return }
        let arguments = SwiftGodotRuntime.Arguments(pargs: variantArgs, argc: argc)
    do {
                guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `greet`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: String.self, at: 0)
            let arg1 = arguments.count > 1 ? try arguments.argument(ofType: String.self, at: 1) : ("Hello" as String)
            let arg2 = arguments.count > 2 ? try arguments.argument(ofType: Int.self, at: 2) : (1 as Int)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.greet(arg0, greeting: arg1, times: arg2)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }
    func attach(to node: Node? = nil) {}

    static func _mproxy_attach(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `attach`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = arguments.count > 0 ? try arguments.argument(ofType: Node?.self, at: 0) : (nil as Node?)
            return SwiftGodotRuntime._wrapCallableResult(object.attach(to: arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `attach`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_attach(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `attach`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Node? = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.attach(to: arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `attach`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_attach(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 1, error: callError, returnValue: returnValue) else { return }
        let arguments = SwiftGodotRuntime.Arguments(pargs: variantArgs, argc: argc)
    do {
                guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `attach`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = arguments.count > 0 ? try arguments.argument(ofType: Node?.self, at: 0) : (nil as Node?)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.attach(to: arg0)), into: returnValue)

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
        guard swiftGodotShouldInitializeClass(type: Greeter.self) else {
            return
        }
        let className = StringName("Greeter")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "greet",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(String.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(String.self, name: "name"),
                SwiftGodotRuntime._argumentPropInfo(String.self, name: "greeting"),
                SwiftGodotRuntime._argumentPropInfo(Int.self, name: "times")
            ],
            defaultArguments: [
                SwiftGodotRuntime._wrapDefaultArgument(SwiftGodotRuntime._wrapCallableResult("Hello" as String)),
                SwiftGodotRuntime._wrapDefaultArgument(SwiftGodotRuntime._wrapCallableResult(1 as Int))
            ],
            callFunction: { _, instance, args, count, result, error in
                Greeter._vproxy_greet(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                Greeter._pproxy_greet(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "attach",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Node?.self, name: "node")
            ],
            defaultArguments: [
                SwiftGodotRuntime._wrapDefaultArgument(SwiftGodotRuntime._wrapCallableResult(nil as Node?))
            ],
            callFunction: { _, instance, args, count, result, error in
                Greeter._vproxy_attach(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                Greeter._pproxy_attach(instance, RawArguments(args: args), result)
            }
        )
    }
}
