class MultiplierNode: Node {
    func multiply(_ integers: Array<Int>) -> Int {
        integers.reduce(into: 1) { $0 *= $1 }
    }

    static func _mproxy_multiply(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `multiply`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Array<Int>.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.multiply(arg0))

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
        let arg0: Array<Int> = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.multiply(arg0)) 

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
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 1, maximum: 1, error: callError, returnValue: returnValue) else { return }
        let arguments = SwiftGodotRuntime.Arguments(pargs: variantArgs, argc: argc)
    do {
                guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `multiply`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Array<Int>.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.multiply(arg0)), into: returnValue)

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
        guard swiftGodotShouldInitializeClass(type: MultiplierNode.self) else {
            return
        }
        let className = StringName("MultiplierNode")
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
                SwiftGodotRuntime._argumentPropInfo(Array<Int>.self, name: "integers")
            ],
            callFunction: { _, instance, args, count, result, error in
                MultiplierNode._vproxy_multiply(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                MultiplierNode._pproxy_multiply(instance, RawArguments(args: args), result)
            }
        )
    }
}
