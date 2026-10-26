class CallableCollectionsNode: Node {
    func get_ages() -> [Int] {
        [1, 2, 3, 4]
    }

    static func _mproxy_get_ages(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_ages`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.get_ages())

    }
    @inline(always)
    static func _pproxy_get_ages(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_ages`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.get_ages()) 

    }
    @inline(always)
    static func _vproxy_get_ages(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_ages`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.get_ages()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }
    func get_markers() -> [Marker3D] {
        [.init(), .init(), .init()]
    }

    static func _mproxy_get_markers(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_markers`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.get_markers())

    }
    @inline(always)
    static func _pproxy_get_markers(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_markers`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.get_markers()) 

    }
    @inline(always)
    static func _vproxy_get_markers(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `get_markers`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.get_markers()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass()
    }

    private static func _initializeClass() {
        guard swiftGodotShouldInitializeClass(type: CallableCollectionsNode.self) else {
            return
        }
        let className = StringName("CallableCollectionsNode")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "get_ages",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo([Int].self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                CallableCollectionsNode._vproxy_get_ages(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                CallableCollectionsNode._pproxy_get_ages(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "get_markers",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo([Marker3D].self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                CallableCollectionsNode._vproxy_get_markers(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                CallableCollectionsNode._pproxy_get_markers(instance, RawArguments(args: args), result)
            }
        )
    }
}
