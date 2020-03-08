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

    /// The current date and time as a formatted string.
    ///
    /// - Note: As this is a public property the value is immutable, so you can only subscribe to changes.
    var formattedDateTime: Observable<String> {
        formattedDateTimeSubject
    }

    /// The formatted date and time the user wants to save.
    ///
    /// - Note: As this is a public property the value is immutable, so you can only subscribe to changes.
    var saveFormattedDateTime: Observable<String> {
        saveFormattedDateTimeSubject
    }

    // MARK: - Private properties

    /// The current date and time as a formatted string.
    ///
    /// - Note: As this is our private property the value is mutable, so only this class can modify it.
    private let formattedDateTimeSubject = Variable(DateTimeViewModel.makeFormattedDateAndTime())

    /// The formatted date and time the user wants to save.
    ///
    /// - Note: As this is our private property the value is mutable, so only this class can modify it.
    private let saveFormattedDateTimeSubject = PublishSubject<String>()

    private var timer: Timer?

    // MARK: - Initializer

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.formattedDateTimeSubject.value = Self.makeFormattedDateAndTime()
        })
    }

    // MARK: - Public methods

    func didTapSaveTimeButton() {
        let delimiter = "\n"
        let textToSave = Self.makeFormattedDateAndTime() + delimiter

        saveFormattedDateTimeSubject.update(textToSave)
    }

    // MARK: - Private methods

    private static func makeFormattedDateAndTime() -> String {
        DateFormatter.localizedString(from: Date(),
                                      dateStyle: .long,
                                      timeStyle: .medium)
    }
}
