//
//  DateTimeViewModel.swift
//  LightweightObservable_Example
//
//  Created by Felix Mau on 27/04/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import LightweightObservable

class DateTimeViewModel {
    // MARK: - Public properties

    /// The current date as a formatted string.
    ///
    /// - Note: As this is a public property the value is immutable, so you can only subscribe to changes.
    var formattedDate: Observable<String> {
        formattedDateSubject
    }

    /// The current time as a formatted string.
    ///
    /// - Note: As this is a public property the value is immutable, so you can only subscribe to changes.
    var formattedTime: Observable<String> {
        formattedTimeSubject
    }

    // MARK: - Private properties

    /// The current date as a formatted string.
    ///
    /// - Note: As this is our private property the value is mutable, so only this class can modify it.
    private let formattedDateSubject = Variable(DateTimeViewModel.makeFormattedDate())

    /// The current time as a formatted string.
    ///
    /// - Note: As this is our private property the value is mutable, so only this class can modify it.
    private let formattedTimeSubject = Variable(DateTimeViewModel.makeFormattedTime())

    private var timer: Timer?

    // MARK: - Initializer

    init() {
        // Update variables with current date and time every second.
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }

            self.formattedDateSubject.value = Self.makeFormattedDate()
            self.formattedTimeSubject.value = Self.makeFormattedTime()
        })
    }

    // MARK: - Private methods

    private static func makeFormattedDate() -> String {
        DateFormatter.localizedString(from: Date(),
                                      dateStyle: .medium,
                                      timeStyle: .none)
    }

    private static func makeFormattedTime() -> String {
        DateFormatter.localizedString(from: Date(),
                                      dateStyle: .none,
                                      timeStyle: .medium)
    }
}
