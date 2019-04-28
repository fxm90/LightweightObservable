//
//  Observable.swift
//  LightweightObservable
//
//  Created by Felix Mau on 11/02/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

///
public class Observable<T> {
    // MARK: - Types

    /// The type for the new value of the observable.
    public typealias NewValue = T

    /// The type for the previous value of the observable.
    public typealias OldValue = T?

    /// The type for the closure to executed on change of the observable.
    public typealias Observer = (NewValue, OldValue) -> Void

    /// We store all observers within a dictionary, for which this is the type of the key.
    private typealias Index = UInt

    // MARK: - Public properties

    /// The current (readonly) value of the observable.
    fileprivate(set) var value: T {
        didSet {
            for (_, observer) in observers {
                observer(value, oldValue)
            }
        }
    }

    // MARK: - Private properties

    /// The index of the last inserted observer.
    private var lastIndex: Index = 0

    /// Map with all active observers.
    private var observers = [Index: Observer]()

    // MARK: - Initalizer

    /// Initializes a new observable with the given value.
    ///
    /// - Note: Declared `fileprivate` in order to prevent directly initializing an observable, which can not be updated.
    fileprivate init(_ value: T) {
        self.value = value
    }

    // MARK: - Public methods

    /// Informs the given observer on changes to our `value`.
    ///
    /// - Parameter observer: The observer-closure that is notified on changes.
    public func subscribe(_ observer: @escaping Observer) -> Disposable {
        let currentIndex = lastIndex + 1
        observers[currentIndex] = observer

        lastIndex = currentIndex

        // Inform observer with initial value.
        observer(value, nil)

        // Return a disposable, that removes the entry for this observer when it's deallocated.
        return Disposable { [weak self] in
            self?.observers[currentIndex] = nil
        }
    }
}

///
public extension Observable where T: Equatable {
    // MARK: - Types

    /// The type for the filter closure.
    typealias Filter = (NewValue, OldValue) -> Bool

    // MARK: - Public methods

    /// Informs the given observer on changes to our `value`, only if the given filter matches.
    ///
    /// - Parameters:
    ///   - filter: The filer-closure, that must return `true` in order for the observer to be notified.
    ///   - observer: The observer-closure that is notified on changes.
    func subscribe(filter: @escaping Filter, observer: @escaping Observer) -> Disposable {
        return subscribe { nextValue, prevValue in
            guard filter(nextValue, prevValue) else { return }

            observer(nextValue, prevValue)
        }
    }

    /// Informs the given observer on **distinct** changes to our `value`.
    ///
    /// - Parameter observer: The observer-closure that is notified on changes.
    func subscribeDistinct(_ observer: @escaping Observer) -> Disposable {
        return subscribe(filter: { $0 != $1 },
                         observer: observer)
    }
}

///
public final class Variable<T>: Observable<T> {
    // MARK: - Public properties

    /// The current variable converted to an (readonly) `Observable`.
    public var asObservable: Observable<T> {
        return self as Observable
    }

    /// The current value of the observable.
    public override var value: T {
        get {
            return super.value
        }
        set {
            super.value = newValue
        }
    }

    // MARK: - Initializer

    /// Initializes a new variable with the given value.
    ///
    /// - Note: As we've made the initializer to the super class `Observable` fileprivate, we must override it here with public access.
    public override init(_ value: T) {
        super.init(value)
    }
}
