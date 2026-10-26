private class TestNode: Node {
    func foo(variant: Variant?) -> Variant? {
        return variant
    }

    static func _mproxy_foo(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `foo`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Variant?.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.foo(variant: arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `foo`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_foo(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `foo`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Variant? = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.foo(variant: arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `foo`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_foo(
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
                SwiftGodotRuntime.GD.printErr("Error calling `foo`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Variant?.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.foo(variant: arg0)), into: returnValue)

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
        guard swiftGodotShouldInitializeClass(type: TestNode.self) else {
            return
        }
        let className = StringName("TestNode")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "foo",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Variant?.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Variant?.self, name: "variant")
            ],
            callFunction: { _, instance, args, count, result, error in
                TestNode._vproxy_foo(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                TestNode._pproxy_foo(instance, RawArguments(args: args), result)
            }
        )
    }
}
