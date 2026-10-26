class SomeNode: Node {
    func square(_ integers: TypedArray<Int>) -> TypedArray<Int> {
        integers.map { $0 * $0 }.reduce(into: TypedArray<Int>()) { $0.append(value: $1) }
    }

    static func _mproxy_square(pInstance: UnsafeRawPointer?, arguments: borrowing SwiftGodotRuntime.Arguments) -> SwiftGodotRuntime.FastVariant? {
        do { // safe arguments access scope
            guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `square`: failed to unwrap instance \(String(describing: pInstance))")
                return nil
            }
            let arg0 = try arguments.argument(ofType: TypedArray<Int>.self, at: 0)
            return SwiftGodotRuntime._wrapCallableResult(object.square(arg0))

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `square`: \(error.description)")
        }

        return nil
    }
    @inline(always)
    static func _pproxy_square(        
    _ pInstance: UnsafeMutableRawPointer?,
    _ rargs: SwiftGodotRuntime.RawArguments,
    _ returnValue: UnsafeMutableRawPointer?) {
        do { // safe arguments access scope
                    guard let object = SwiftGodotRuntime._unwrap(self, pInstance: pInstance) else {
                SwiftGodotRuntime.GD.printErr("Error calling `square`: failed to unwrap instance \(String(describing: pInstance))")
                return
            }
        let arg0: TypedArray<Int> = try rargs.fetchArgument(at: 0)
            SwiftGodotRuntime.RawReturnWriter.writeResult(returnValue, object.square(arg0)) 

        } catch {
            SwiftGodotRuntime.GD.printErr("Error calling `square`: \(String(describing: error))")                    
        }
    }
    @inline(always)
    static func _vproxy_square(
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
                SwiftGodotRuntime.GD.printErr("Error calling `square`: failed to unwrap instance \(String(describing: pInstance))")
                SwiftGodotRuntime._callInstanceMissing(callError, returnValue: returnValue); return
            }
            let arg0 = try arguments.argument(ofType: TypedArray<Int>.self, at: 0)
            SwiftGodotRuntime._writeCallResult(SwiftGodotRuntime._wrapCallableResult(object.square(arg0)), into: returnValue)

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
        guard swiftGodotShouldInitializeClass(type: SomeNode.self) else {
            return
        }
        let className = StringName("SomeNode")
        if classInitializationLevel.rawValue >= ExtensionInitializationLevel.scene.rawValue {
            // ClassDB singleton is not available prior to `.scene` level
            assert(ClassDB.classExists(class: className))
        }
        SwiftGodotRuntime._registerSpecializedMethod(
            className: className,
            name: "square",
            flags: .default,
            returnValue: SwiftGodotRuntime._returnValuePropInfo(TypedArray<Int>.self),
            arguments: [
                SwiftGodotRuntime._argumentPropInfo(TypedArray<Int>.self, name: "integers")
            ],
            callFunction: { _, instance, args, count, result, error in
                SomeNode._vproxy_square(instance, args, count, result, error.map {
                        UnsafeMutableRawPointer($0)
                    })
            },
            ptrFunction: { _, instance, args, result in
                SomeNode._pproxy_square(instance, RawArguments(args: args), result)
            }
        )
    }
}
