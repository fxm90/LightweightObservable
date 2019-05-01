LightweightObservable
====================

![Swift5.0](https://img.shields.io/badge/Swift-5.0-green.svg?style=flat) [![CI Status](http://img.shields.io/travis/fxm90/LightweightObservable.svg?style=flat)](https://travis-ci.org/fxm90/LightweightObservable) [![Version](https://img.shields.io/cocoapods/v/LightweightObservable.svg?style=flat)](http://cocoapods.org/pods/LightweightObservable) [![License](https://img.shields.io/cocoapods/l/LightweightObservable.svg?style=flat)](http://cocoapods.org/pods/LightweightObservable) [![Platform](https://img.shields.io/cocoapods/p/LightweightObservable.svg?style=flat)](http://cocoapods.org/pods/LightweightObservable)

A lightweight implementation of an observable sequence that you can subscribe to.

**Credits:** The code was heavily influenced by [roberthein/observable](https://github.com/roberthein/Observable). But I needed something that was syntactically closer to [RxSwift](https://github.com/ReactiveX/RxSwift), which is why I came up with this code, and for reusability reasons afterwards moved it into a CocoaPod.

### Example
To run the example project, clone the repo, and open the workspace from the Example directory.

### Integration
##### CocoaPods
LightweightObservable can be added to your project using [CocoaPods](https://cocoapods.org/) by adding the following line to your Podfile:
```
pod 'LightweightObservable', '~> 1.0'
```

##### Carthage
To integrate LightweightObservable into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your Cartfile:
```
github "fxm90/LightweightObservable" ~> 1.0
```
Run carthage update to build the framework and drag the built `LightweightObservable.framework` into your Xcode project.

### Hot to use
The pod provides two classes `Observable` and `Variable`:
 - `Observable`: Contains an immutable value, you only can subscribe to. This is useful in order to avoid side-effects on an internal API. 
 - `Variable`: Subclass of `Observable`, where you can modify the value as well.

#### – Create a variable
```swift
let formattedTimeSubject = Variable("")

// ...

formattedTimeSubject.value = "4:20 PM"
```

#### – Create an observable
Initializing an observable directly is not possible, as this would lead to a sequence that will never change. Instead, use the computed property `asObservable` from `Variable` to cast the instance to an observable.
```swift
var formattedTime: Observable<String> {
    return formattedTimeSubject.asObservable
}
```

#### – Subscribe to changes
Every subscriber gets informed with the initial / current value and on all further changes to the observable value.

```swift
formattedTime.subscribe { [weak self] newFormattedTime, oldFormattedTime in
    self?.timeLabel.text = newFormattedTime
}
```

Please notice that the old value (`oldFormattedTime`) is an optional, as we don't have this value on the initial call to the subscriber.

**Important:** To avoid retain cycles and/or crashes, **always** use `[weak self]` when self is needed by an observer.

#### – Memory Management (`Disposable` / `DisposeBag`)

@TODO: Explain why 

In case you only use a single subscriber you can store the returned `Disposable` to a variable:
```swift
let disposable = formattedTime.subscribe { [weak self] newFormattedTime, oldFormattedTime in
	// ...
}
```

In case you're having multiple observers, you can store all returned `Disposable` in an array of `Disposable`. (To match the RX syntax, this pod contains a typealias called `DisposeBag`, which is an array of `Disposable`).
```swift
var disposeBag = DisposeBag()

formattedTime.subscribe { [weak self] newFormattedTime, oldFormattedTime in
    // ...
}.disposed(by: &disposeBag)

formattedDate.subscribe { [weak self] newFormattedDate, oldFormattedDate in
    // ...
}.disposed(by: &disposeBag)
```

#### – Observing `Equatable` values
If you create an Observable which underlying type conforms to `Equtable` you can subscribe to changes using a specific filter. Therefore this pod contains the method:
```swift 
func subscribe(filter: @escaping Filter, observer: @escaping Observer) -> Disposable {
```

Now the observer will only be notified on changes if the filter matches.

This pod comes with one predefined filter method, called `subscribeDistinct`. Subscribing to an observable using this method, will only notify the subscriber if the new value is different from the old value. This is useful to prevent unnecessary UI-Updates.

Feel free to add more filters, by extending the `Observable` like this:
```swift
public extension Observable where T: Equatable {}
```

### Author

Felix Mau, me@felix.hamburg

### License

LightweightObservable is available under the MIT license. See the LICENSE file for more info.
