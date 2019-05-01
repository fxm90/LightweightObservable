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

    var formattedDate: Observable<String> {
        return formattedDateSubject.asObservable
    }

    var formattedTime: Observable<String> {
        return formattedTimeSubject.asObservable
    }

    // MARK: - Private properties

    private let formattedDateSubject: Variable<String> = Variable("")

    private let formattedTimeSubject: Variable<String> = Variable("")

    private var timer: Timer?

    // MARK: - Initializer

    init() {
        // Initialize variables with current date and time.
        formattedDateSubject.value = makeFormattedDate()
        formattedTimeSubject.value = makeFormattedTime()
        
        // Update variables with current date and time every second.
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }

            self.formattedDateSubject.value = self.makeFormattedDate()
            self.formattedTimeSubject.value = self.makeFormattedTime()
        })
    }

    deinit {}

    // MARK: - Private methods

    private func makeFormattedDate() -> String {
        return DateFormatter.localizedString(from: Date(),
                                             dateStyle: .medium,
                                             timeStyle: .none)
    }

    private func makeFormattedTime() -> String {
        return DateFormatter.localizedString(from: Date(),
                                             dateStyle: .none,
                                             timeStyle: .medium)
    }
}
