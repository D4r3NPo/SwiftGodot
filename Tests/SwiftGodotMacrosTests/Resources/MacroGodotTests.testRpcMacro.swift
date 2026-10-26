class MultiplayerNode: Node {

    func syncPosition(_ position: Vector3) {
    }

    static func _mproxy_syncPosition(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `syncPosition`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Vector3.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.syncPosition(arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `syncPosition`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_syncPosition(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `syncPosition`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Vector3 = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.syncPosition(arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `syncPosition`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_syncPosition(
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
                SwiftGodotRuntime.GD.printErr("Error calling `syncPosition`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Vector3.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.syncPosition(arg0)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }


    func defaultRpc() {
    }

    static func _mproxy_defaultRpc(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `defaultRpc`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.defaultRpc())

    }
    @inline(always)
    static func _pproxy_defaultRpc(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `defaultRpc`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.defaultRpc()) 

    }
    @inline(always)
    static func _vproxy_defaultRpc(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `defaultRpc`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.defaultRpc()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }


    func fullConfig() {
    }

    static func _mproxy_fullConfig(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `fullConfig`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.fullConfig())

    }
    @inline(always)
    static func _pproxy_fullConfig(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `fullConfig`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.fullConfig()) 

    }
    @inline(always)
    static func _vproxy_fullConfig(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `fullConfig`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.fullConfig()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }

    override open class var classInitializer: Void {
        let _ = super.classInitializer
        return _initializeClass()
    }

    private static func _initializeClass() {
        guard swiftGodotShouldInitializeClass(type: MultiplayerNode.self) else {
            return
        }
        let className = StringName("MultiplayerNode")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "syncPosition",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Vector3.self, name: "position")
            ],
            callFunction: { _, instance, args, count, result, error in
                MultiplayerNode._vproxy_syncPosition(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                MultiplayerNode._pproxy_syncPosition(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "defaultRpc",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                MultiplayerNode._vproxy_defaultRpc(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                MultiplayerNode._pproxy_defaultRpc(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "fullConfig",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                MultiplayerNode._vproxy_fullConfig(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                MultiplayerNode._pproxy_fullConfig(instance, RawArguments(args: args), result)
            }
        )
    }

    /// Called automatically before `_ready()`. Configures RPC for methods marked with `@Rpc`.
    override open func _before_ready() {
        super._before_ready()
        rpcConfig(
            method: StringName("sync_position"),
            config: Variant([
                "rpc_mode": Variant(MultiplayerAPI.RPCMode.anyPeer.rawValue),
                "call_local": Variant(false),
                "transfer_mode": Variant(MultiplayerPeer.TransferMode.reliable.rawValue),
                "channel": Variant(0)
            ] as GDictionary)
        )
        rpcConfig(
            method: StringName("default_rpc"),
            config: Variant([
                "rpc_mode": Variant(MultiplayerAPI.RPCMode.authority.rawValue),
                "call_local": Variant(false),
                "transfer_mode": Variant(MultiplayerPeer.TransferMode.unreliable.rawValue),
                "channel": Variant(0)
            ] as GDictionary)
        )
        rpcConfig(
            method: StringName("full_config"),
            config: Variant([
                "rpc_mode": Variant(MultiplayerAPI.RPCMode.authority.rawValue),
                "call_local": Variant(true),
                "transfer_mode": Variant(MultiplayerPeer.TransferMode.unreliableOrdered.rawValue),
                "channel": Variant(2)
            ] as GDictionary)
        )
        }
}
