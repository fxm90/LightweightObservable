# Lightweight Observable 2.0 Migration Guide

Lightweight Observable 2.0 is the latest major release of Lightweight Observable. As a major release, following Semantic Versioning conventions, 2.0 introduces some API-breaking changes that one should be aware of.

This guide is provided in order to ease the transition of existing applications using Lightweight Observable 1.x to the latest APIs, as well as explain the design and structure of new and changed functionality.

## Benefits of Upgrading
 - **PublishSubject:** A new subject type, that starts empty and only emits new elements to subscribers.

---

## Breaking API Changes

### Type of property `value` changed to optional
As a `PublishSubject` doesn't have an initial value, the property `value` of the class `Observable` has changed to an optional type. However, it's always better to subscribe to a given observable! This **shortcut** should only be used during **testing**.

### Removed property `asObservable` from class `Variable`
Eventhough it is a bit more readable there is no need to write `.asObservable` to cast a `Variable` to an `Observable` as Swift can do the casting automatically.

Instead of writing:

```swift
var someVariable: Observable<Int> = {
    someVariableSubject.asObservable
}
```

you can simply write:

```swift
var someVariable: Observable<Int> = {
    someVariableSubject
}
```

```swift
lazy var someVariable: Observable<Int> = someVariableSubject
```

Therefore this computed property has been removed.
