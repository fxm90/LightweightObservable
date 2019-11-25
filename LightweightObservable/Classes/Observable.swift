//
//  Observable.swift
//  LightweightObservable
//
//  Created by Felix Mau on 11/02/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

/// An observable sequence that you can subscribe to. Any of the subscriber will receive the most
/// recent element and everything that is emitted by that sequence after the subscription happened.
///
/// - Note: Implementation based on [roberthein/Observable](https://github.com/roberthein/Observable).
public class Observable<T> {
    // MARK: - Types

    /// The type for the new value of the observable.
    public typealias Value = T

    /// The type for the previous value of the observable.
    public typealias OldValue = T?

    /// The type for the closure to executed on change of the observable.
    public typealias Observer = (Value, OldValue) -> Void

    /// The current state describing whether a value has been set or not.
    ///
    /// - Note: We can't use a simple optional here, as this wouldn't work with having an optional generic value.
    fileprivate enum State {
        /// No value has been set.
        case none
        /// Some value has been set.
        case some(Value)
    }

    /// We store all observers within a dictionary, for which this is the type of the key.
    private typealias Index = UInt

    // MARK: - Public properties

    /// The current (readonly) value of the observable (if available).
    ///
    /// - Note: It's always better to subscribe to a given observable! This **shortcut** should only be used during **testing**.
    public var value: Value? {
        switch state {
        case .none:
            return nil

        case let .some(value):
            return value
        }
    }

    // MARK: - Private properties

    fileprivate var state: State = .none {
        didSet {
            switch (state, oldValue) {
            case (.none, _):
                assertionFailure("⚠️ – Updated `state` to `.none`. This isn't supposed to happen!")

            case (let .some(value), .none):
                notifyObserver(value, oldValue: nil)

            case let (.some(value), .some(oldValue)):
                notifyObserver(value, oldValue: oldValue)
            }
        }
    }

    /// The index of the last inserted observer.
    private var lastIndex: Index = 0

    /// Map with all active observers.
    private var observers = [Index: Observer]()

    // MARK: - Initalizer

    /// Initializes a new observable with the given value.
    ///
    /// - Note: Declared `fileprivate` in order to prevent directly initializing an observable, which can not be updated.
    fileprivate init() {
        // swiftformat:disable:previous redundantFileprivate
    }

    // MARK: - Public methods

    /// Informs the given observer on changes to our `value`.
    ///
    /// - Parameter observer: The observer-closure that is notified on changes.
    public func subscribe(_ observer: @escaping Observer) -> Disposable {
        let currentIndex = lastIndex + 1
        observers[currentIndex] = observer
        lastIndex = currentIndex

        // Return a disposable, that removes the entry for this observer on it's deallocation.
        return Disposable { [weak self] in
            self?.observers[currentIndex] = nil
        }
    }

    // MARK: - Private methods

    private func notifyObserver(_ value: Value, oldValue: OldValue) {
        for (_, observer) in observers {
            observer(value, oldValue)
        }
    }
}

/// Starts empty and only emits new elements to subscribers.
public final class PublishSubject<T>: Observable<T> {
    // MARK: - Initializer

    /// Initializes a new publish subject.
    ///
    /// - Note: As we've made the initializer to the super class `Observable` fileprivate, we must override it here to allow public access.
    public override init() {
        super.init()
    }

    // MARK: - Public methods

    public func update(_ value: Value) {
        state = .some(value)
    }
}

/// Starts with an initial value and replays it or the latest element to new subscribers.
public class Variable<T>: Observable<T> {
    // MARK: - Public properties

    /// The current value of the variable.
    public override var value: Value {
        get {
            switch state {
            case .none:
                preconditionFailure("⚠️ – Property `state` was `.none`. This isn't supposed to happen, please double check the initialization and setter!")

            case let .some(value):
                return value
            }
        }
        set {
            super.state = .some(newValue)
        }
    }

    // MARK: - Initializer

    /// Initializes a new variable with the given value.
    ///
    /// - Note: We keep the initializer to the super class `Observable` fileprivate in order to verify always having a value.
    public init(_ value: Value) {
        super.init()

        state = .some(value)
    }

    // MARK: - Public methods

    public override func subscribe(_ observer: @escaping Observer) -> Disposable {
        // A variable should inform the observer with the initial value.
        observer(value, nil)

        return super.subscribe(observer)
    }
}
