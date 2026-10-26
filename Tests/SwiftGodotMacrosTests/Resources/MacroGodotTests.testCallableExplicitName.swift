class TestClass: Node {
    func originalName() {}

    static func _mproxy_originalName(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `originalName`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.originalName())

    }
    @inline(always)
    static func _pproxy_originalName(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `originalName`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.originalName()) 

    }
    @inline(always)
    static func _vproxy_originalName(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `originalName`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.originalName()), into: returnValue)

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
            name: "testExplicitName",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                TestClass._vproxy_originalName(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                TestClass._pproxy_originalName(instance, RawArguments(args: args), result)
            }
        )
    }
}
