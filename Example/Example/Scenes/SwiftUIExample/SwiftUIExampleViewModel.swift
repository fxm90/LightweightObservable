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
    /// - Note: The underlying subject is a `Variable`, therefore a new subscriber will be informed with the **current value up on subscription**!
    var formattedDate: Observable<String> {
        formattedDateSubject
    }

    // MARK: - Private properties

    /// The current date and time as a formatted string.
    ///
    /// - Note: This value is mutable and therefore the we store it with a `private` access level.
    private let formattedDateSubject = Variable(Date.localizedDateAndTime)

    private var timer: Timer?

    // MARK: - Initializer

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.formattedDateSubject.value = Date.localizedDateAndTime
        }
    }
}

// MARK: - Helpers

private extension Date {
    static var localizedDateAndTime: String {
        DateFormatter.localizedString(from: .now, dateStyle: .medium, timeStyle: .medium)
    }
}
