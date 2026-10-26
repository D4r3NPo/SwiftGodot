class MathHelper: Node {
    func multiply(_ a: Int, by b: Int) -> Int { a * b}

    static func _mproxy_multiply(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `multiply`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Int.self, at: 0)
            let arg1 = try arguments.argument(ofType: Int.self, at: 1)
            return SwiftGodotRuntime._wrapCallableResult(object.multiply(arg0, by: arg1))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `multiply`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_multiply(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `multiply`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Int = try rargs.fetchArgument(at: 0)
        let arg1: Int = try rargs.fetchArgument(at: 1)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.multiply(arg0, by: arg1)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `multiply`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_multiply(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 2, maximum: 2, error: callError, returnValue: returnValue) else { return }
        let arguments = SwiftGodotRuntime.Arguments(pargs: variantArgs, argc: argc)
    do {
                guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `multiply`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Int.self, at: 0)
            let arg1 = try arguments.argument(ofType: Int.self, at: 1)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.multiply(arg0, by: arg1)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }
    func divide(_ a: Float, by b: Float) -> Float { a / b }

    static func _mproxy_divide(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `divide`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Float.self, at: 0)
            let arg1 = try arguments.argument(ofType: Float.self, at: 1)
            return SwiftGodotRuntime._wrapCallableResult(object.divide(arg0, by: arg1))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `divide`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_divide(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `divide`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Float = try rargs.fetchArgument(at: 0)
        let arg1: Float = try rargs.fetchArgument(at: 1)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.divide(arg0, by: arg1)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `divide`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_divide(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 2, maximum: 2, error: callError, returnValue: returnValue) else { return }
        let arguments = SwiftGodotRuntime.Arguments(pargs: variantArgs, argc: argc)
    do {
                guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `divide`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Float.self, at: 0)
            let arg1 = try arguments.argument(ofType: Float.self, at: 1)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.divide(arg0, by: arg1)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }
    func areBothTrue(_ a: Bool, and b: Bool) -> Bool { a == b }

    static func _mproxy_areBothTrue(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `areBothTrue`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Bool.self, at: 0)
            let arg1 = try arguments.argument(ofType: Bool.self, at: 1)
            return SwiftGodotRuntime._wrapCallableResult(object.areBothTrue(arg0, and: arg1))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `areBothTrue`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_areBothTrue(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `areBothTrue`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Bool = try rargs.fetchArgument(at: 0)
        let arg1: Bool = try rargs.fetchArgument(at: 1)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.areBothTrue(arg0, and: arg1)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `areBothTrue`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_areBothTrue(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 2, maximum: 2, error: callError, returnValue: returnValue) else { return }
        let arguments = SwiftGodotRuntime.Arguments(pargs: variantArgs, argc: argc)
    do {
                guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `areBothTrue`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Bool.self, at: 0)
            let arg1 = try arguments.argument(ofType: Bool.self, at: 1)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.areBothTrue(arg0, and: arg1)), into: returnValue)

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
        guard swiftGodotShouldInitializeClass(type: MathHelper.self) else {
            return
        }
        let className = StringName("MathHelper")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "multiply",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Int.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Int.self, name: "a"),
                SwiftGodotRuntime._argumentPropInfo(Int.self, name: "b")
            ],
            callFunction: { _, instance, args, count, result, error in
                MathHelper._vproxy_multiply(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                MathHelper._pproxy_multiply(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "divide",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Float.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Float.self, name: "a"),
                SwiftGodotRuntime._argumentPropInfo(Float.self, name: "b")
            ],
            callFunction: { _, instance, args, count, result, error in
                MathHelper._vproxy_divide(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                MathHelper._pproxy_divide(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "areBothTrue",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Bool.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Bool.self, name: "a"),
                SwiftGodotRuntime._argumentPropInfo(Bool.self, name: "b")
            ],
            callFunction: { _, instance, args, count, result, error in
                MathHelper._vproxy_areBothTrue(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                MathHelper._pproxy_areBothTrue(instance, RawArguments(args: args), result)
            }
        )
    }
}
