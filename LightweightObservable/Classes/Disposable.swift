//
//  Disposable.swift
//  LightweightObservable
//
//  Created by Felix Mau on 11/02/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

/// Helper to allow storing multiple disposables (and matching name from RxSwift).
public typealias DisposeBag = [Disposable]

///
public final class Disposable {
    // MARK: - Types

    /// Type for closure to be executed on `deinit`.
    public typealias Dispose = () -> Void

    // MARK: - Private properties

    /// Closure to be executed on `deinit`.
    private let dispose: Dispose

    // MARK: - Initializer

    ///
    public init(_ dispose: @escaping Dispose) {
        self.dispose = dispose
    }

    ///
    ///
    ///
    deinit {
        dispose()
    }

    // MARK: - Public methods

    /// Adds the current closure to an array of closures.
    public func add(to disposeBag: inout DisposeBag) {
        disposeBag.append(self)
    }
}
