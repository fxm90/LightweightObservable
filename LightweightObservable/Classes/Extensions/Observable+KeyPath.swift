//
//  Observable+KeyPath.swift
//  LightweightObservable
//
//  Created by Felix Mau on 03/01/20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import Foundation

/// Additional helper methods for using Swifts `KeyPath` feature to bind an observable to a property.
public extension Observable {
    /// Updates the property at the given key-path on changes to our property `value`.
    ///
    /// - Parameters:
    ///   - keyPath: The key-path that indicates the property to assign.
    ///   - object: The object containing the property to update.
    func bind<Root: AnyObject>(to keyPath: WritableKeyPath<Root, Value>, on object: Root) -> Disposable {
        subscribe { newValue, _ in
            var mutableObject = object
            mutableObject[keyPath: keyPath] = newValue
        }
    }

    /// Updates the property at the given key-path on changes to our property `value`.
    ///
    /// - Parameters:
    ///   - keyPath: The key-path that indicates the property to assign.
    ///   - object: The object containing the property to update.
    ///
    /// - Note: We need to explicitly define this method for an optional type of `Value`, as otherwise we e.g. could not bind a `String` to the
    ///         optional string property `text` of an `UILabel`
    func bind<Root>(to keyPath: WritableKeyPath<Root, Value?>, on object: Root) -> Disposable {
        subscribe { newValue, _ in
            var mutableObject = object
            mutableObject[keyPath: keyPath] = newValue
        }
    }
}
