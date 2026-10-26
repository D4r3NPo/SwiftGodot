# Instance bindings and specialized calls

Requires Swift 6.4. The existing language mode is retained; the change does not
require a Swift 6 concurrency migration of user extensions.

## Ownership

Each native object owns a retained `WrappedReference` in the runtime's instance
binding slot. Binding creation allocates only that empty cell, because Godot holds
its per-object lock during the callback. Swift wrapper construction happens after
that callback returns, preventing recursive acquisition of the native lock.
A per-cell lock serializes first creation; existing-wrapper lookup takes no
Swift global lock.

The cell retains non-refcounted wrappers until native destruction. Strong ownership
is represented explicitly with Unmanaged; wrapper reads still acquire a safe Swift
reference through weak storage rather than racing native releases. RefCounted
wrappers use the existing strong/weak transition protocol to avoid a native/Swift
ownership cycle. User class instance data holds a separate balanced retain on the
cell. Native destruction invalidates the wrapper handle before releasing it.

The pending-unreference queue stores generation-qualified native instance IDs,
and retains the binding cell until processing. The cell is invalidated before
native destruction finishes, including when ObjectDB still contains the ID.
Extension deinitialization drains the queue before and after unregistering classes,
while native method bindings and resource services are still available.
It is a work queue, not an instance registry. A dead ID
is skipped even if its old address has been reused.

`getActiveHandles` and `clearHandles` are unavailable: a runtime no longer owns a
list of all wrappers. Clients must release their native objects/bindings before
unloading a runtime. Metadata registries for classes and methods remain.

## Calls

`@Callable` emits a concrete `_vproxy_` and `_pproxy_` per method. Registration
installs noncapturing C callbacks that directly invoke these proxies, with no
per-method closure allocation or userdata. Swift 6.4 `@inline(always)` exposes
the concrete conversions to optimization within the extension module. Argument
count and conversion errors remain checked; return types are checked by Swift.
The noncopyable Arguments and FastVariant values remain stack-based, avoiding
introducing ARC boxes for those values. Object wrappers retain their existing
Swift class API and ARC lifetime rules.

The existing `_mproxy_` and closure-based registration APIs are retained for
manual registration and exported properties. They are not the optimized
`@Callable` route. Zero-argument ptrcalls accept a null argument array. Object
ptrcalls now surface engine classes as well as registered user classes.

The multi-process trait keeps its domain-specific deferred-release queue; object
lookup no longer needs a thread dictionary or a global instance table.

## Validation

The creating extension uses slot zero, including during hot reload. Objects
created elsewhere use the token-keyed lookup API.

Run `swift test` for macro expansion and platform tests, and
`swift run SwiftGodotTestRunner` for lifecycle and invocation tests inside Godot.
Use `swift run SwiftGodotTestRunner --release` to validate optimized code.
The runner enables the `testable` trait so optimized integration tests can import
internal APIs; ordinary release products do not enable testability.
Release compilation is required before drawing performance conclusions.
