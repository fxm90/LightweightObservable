//
//  SwiftUIExampleViewModel.swift
//  Example
//
//  Created by Felix Mau on 05.02.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import Foundation
import LightweightObservable

final class SwiftUIExampleViewModel {
    // MARK: - Public properties

    /// The observable for the current date and time as a formatted string.
    ///
    /// - Note: This value is immutable (meaning you can only subscribe to changes), therefore we have it with an `internal` access level.
    var formattedDate: Observable<String> {
        formattedDateSubject
    }

    // MARK: - Private properties

    /// The current date and time as a formatted string.
    ///
    /// - Note: This value is mutable and thereof the we store it with a `private` access level.
    private let formattedDateSubject = Variable(Date.localizedDateAndTime)

    private var timer: Timer?

    // MARK: - Initializer

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.formattedDateSubject.value = Date.localizedDateAndTime
        })
    }
}

// MARK: - Helpers

private extension Date {
    static var localizedDateAndTime: String {
        DateFormatter.localizedString(from: .now, dateStyle: .medium, timeStyle: .medium)
    }
}
