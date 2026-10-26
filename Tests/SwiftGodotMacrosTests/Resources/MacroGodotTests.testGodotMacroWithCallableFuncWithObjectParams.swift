class Castro: Node {
    func deleteEpisode() {}

    static func _mproxy_deleteEpisode(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `deleteEpisode`: failed to unwrap instance \(String(describing: pInstance))")
            return nil
        }
        return SwiftGodotRuntime._wrapCallableResult(object.deleteEpisode())

    }
    @inline(always)
    static func _pproxy_deleteEpisode(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `deleteEpisode`: failed to unwrap instance \(String(describing: pInstance))")
            return
        }
        SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.deleteEpisode()) 

    }
    @inline(always)
    static func _vproxy_deleteEpisode(
        _ pInstance: UnsafeMutableRawPointer?,
        _ variantArgs: UnsafePointer<UnsafeRawPointer?>?,
        _ argc: Int64,
        _ returnValue: UnsafeMutableRawPointer?,
        _ callError: UnsafeMutableRawPointer?
    ) {
        guard SwiftGodotRuntime._checkCallArgumentCount(argc, minimum: 0, maximum: 0, error: callError, returnValue: returnValue) else { return }
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
            SwiftGodotRuntime.GD.printErr("Error calling `deleteEpisode`: failed to unwrap instance \(String(describing: pInstance))")
            SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
        }
        SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.deleteEpisode()), into: returnValue)

    SwiftGodotRuntime._callSucceeded(callError)
    }
    func subscribe(podcast: Podcast) {}

    static func _mproxy_subscribe(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `subscribe`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Podcast.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.subscribe(podcast: arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `subscribe`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_subscribe(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `subscribe`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Podcast = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.subscribe(podcast: arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `subscribe`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_subscribe(
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
                SwiftGodotRuntime.GD.printErr("Error calling `subscribe`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Podcast.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.subscribe(podcast: arg0)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }
    func perhapsSubscribe(podcast: Podcast?) {}

    static func _mproxy_perhapsSubscribe(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `perhapsSubscribe`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Podcast?.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.perhapsSubscribe(podcast: arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `perhapsSubscribe`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_perhapsSubscribe(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `perhapsSubscribe`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Podcast? = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.perhapsSubscribe(podcast: arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `perhapsSubscribe`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_perhapsSubscribe(
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
                SwiftGodotRuntime.GD.printErr("Error calling `perhapsSubscribe`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Podcast?.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.perhapsSubscribe(podcast: arg0)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }
    func removeSilences(from: Variant) {}

    static func _mproxy_removeSilences(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `removeSilences`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Variant.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.removeSilences(from: arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `removeSilences`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_removeSilences(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `removeSilences`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Variant = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.removeSilences(from: arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `removeSilences`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_removeSilences(
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
                SwiftGodotRuntime.GD.printErr("Error calling `removeSilences`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Variant.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.removeSilences(from: arg0)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }
    func getLatestEpisode(podcast: Podcast) -> Episode {}

    static func _mproxy_getLatestEpisode(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `getLatestEpisode`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Podcast.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.getLatestEpisode(podcast: arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `getLatestEpisode`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_getLatestEpisode(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `getLatestEpisode`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Podcast = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.getLatestEpisode(podcast: arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `getLatestEpisode`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_getLatestEpisode(
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
                SwiftGodotRuntime.GD.printErr("Error calling `getLatestEpisode`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Podcast.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.getLatestEpisode(podcast: arg0)), into: returnValue)

        SwiftGodotRuntime._callSucceeded(callError)
    } catch {
        SwiftGodotRuntime._callFailed(callError, returnValue: returnValue)
    }
    }
    func queue(_ podcast: Podcast, after preceedingPodcast: Podcast) {}

    static func _mproxy_queue(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `queue`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: Podcast.self, at: 0)
            let arg1 = try arguments.argument(ofType: Podcast.self, at: 1)
            return SwiftGodotRuntime._wrapCallableResult(object.queue(arg0, after: arg1))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `queue`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_queue(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `queue`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: Podcast = try rargs.fetchArgument(at: 0)
        let arg1: Podcast = try rargs.fetchArgument(at: 1)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.queue(arg0, after: arg1)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `queue`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_queue(
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
                SwiftGodotRuntime.GD.printErr("Error calling `queue`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: Podcast.self, at: 0)
            let arg1 = try arguments.argument(ofType: Podcast.self, at: 1)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.queue(arg0, after: arg1)), into: returnValue)

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
        guard swiftGodotShouldInitializeClass(type: Castro.self) else {
            return
        }
        let className = StringName("Castro")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "deleteEpisode",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [

            ],
            callFunction: { _, instance, args, count, result, error in
                Castro._vproxy_deleteEpisode(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                Castro._pproxy_deleteEpisode(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "subscribe",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Podcast.self, name: "podcast")
            ],
            callFunction: { _, instance, args, count, result, error in
                Castro._vproxy_subscribe(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                Castro._pproxy_subscribe(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "perhapsSubscribe",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Podcast?.self, name: "podcast")
            ],
            callFunction: { _, instance, args, count, result, error in
                Castro._vproxy_perhapsSubscribe(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                Castro._pproxy_perhapsSubscribe(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "removeSilences",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Variant.self, name: "from")
            ],
            callFunction: { _, instance, args, count, result, error in
                Castro._vproxy_removeSilences(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                Castro._pproxy_removeSilences(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "getLatestEpisode",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Episode.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Podcast.self, name: "podcast")
            ],
            callFunction: { _, instance, args, count, result, error in
                Castro._vproxy_getLatestEpisode(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                Castro._pproxy_getLatestEpisode(instance, RawArguments(args: args), result)
            }
        )
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "queue",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(Swift.Void.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(Podcast.self, name: "podcast"),
                SwiftGodotRuntime._argumentPropInfo(Podcast.self, name: "preceedingPodcast")
            ],
            callFunction: { _, instance, args, count, result, error in
                Castro._vproxy_queue(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                Castro._pproxy_queue(instance, RawArguments(args: args), result)
            }
        )
    }
}
