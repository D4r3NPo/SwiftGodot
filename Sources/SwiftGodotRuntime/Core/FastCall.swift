import GDExtension

/// Raw callback API for diagnostic and manually specialized methods.
public typealias FastMethodCall = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, UnsafePointer<UnsafeRawPointer?>?, Int64, UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> Void
public typealias FastMethodPtrCall = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?, UnsafePointer<UnsafeRawPointer?>?, UnsafeMutableRawPointer?) -> Void

public func _registerFastMethod(className: StringName, name: StringName, flags: MethodFlags = .default, returnValue: PropInfo?, arguments: [PropInfo], call: FastMethodCall, ptrCall: FastMethodPtrCall? = nil) {
    _registerSpecializedMethod(className: className, name: name, flags: flags,
        returnValue: returnValue, arguments: arguments,
        callFunction: unsafeBitCast(call, to: GDExtensionClassMethodCall.self),
        ptrFunction: ptrCall.map { unsafeBitCast($0, to: GDExtensionClassMethodPtrCall.self) })
}

@inline(__always)
public func _fastArgument(_ arguments: UnsafePointer<UnsafeRawPointer?>?, _ index: Int) -> UnsafeMutableRawPointer? {
    arguments?[index].map { UnsafeMutableRawPointer(mutating: $0) }
}

@inline(__always)
public func _fastIntFromVariant(_ variant: UnsafeMutableRawPointer?) -> Int64 {
    var value: Int64 = 0
    VariantGodotInterface.intFromVariant(&value, variant)
    return value
}

@inline(__always)
public func _fastVariantFromInt(_ value: Int64, into target: UnsafeMutableRawPointer?) {
    var value = value
    VariantGodotInterface.variantFromInt(target, &value)
}

@inline(__always)
public func _fastObjectHandleFromVariant(_ variant: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    var handle: UnsafeMutableRawPointer?
    Object.selfFromVariant(&handle, variant)
    return handle
}

@inline(__always)
public func _fastVariantFromObjectHandle(_ handle: UnsafeMutableRawPointer?, into target: UnsafeMutableRawPointer?) {
    var handle = handle
    Object.variantFromSelf(target, &handle)
}

@inline(__always)
public func _fastVariantCopy(from source: UnsafeMutableRawPointer?, into target: UnsafeMutableRawPointer?) {
    gi.variant_new_copy(target, source.map { UnsafeRawPointer($0) })
}

@inline(__always)
public func _fastCallSucceeded(_ error: UnsafeMutableRawPointer?) { _callSucceeded(error) }

@inline(__always)
public func _fastBoundWrapper(_ handle: UnsafeMutableRawPointer) -> Wrapped? {
    liveWrappedReference(for: handle)?.value
}

@inline(__always)
public func _fastPtrInt(_ arguments: UnsafePointer<UnsafeRawPointer?>?, _ index: Int) -> Int64 {
    arguments?[index]?.load(as: Int64.self) ?? 0
}

@inline(__always)
public func _fastPtrObjectHandle(_ arguments: UnsafePointer<UnsafeRawPointer?>?, _ index: Int) -> UnsafeMutableRawPointer? {
    arguments?[index]?.load(as: UnsafeMutableRawPointer?.self)
}

@inline(__always)
public func _fastPtrReturn<T>(_ value: T, into target: UnsafeMutableRawPointer?) {
    target?.storeBytes(of: value, as: T.self)
}
