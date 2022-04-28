//
//  UIKitExampleViewModel.swift
//  Example
//
//  Created by Felix Mau on 05.02.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import Foundation
import LightweightObservable

final class UIKitExampleViewModel {

    // MARK: - Public properties

    /// The observable for the current date and time as a formatted string.
    ///
    /// - Note: The underlying subject is a `Variable`, therefore a new subscriber will be informed with the **current value up on subscription**!
    var currentDate: Observable<String> {
        currentDateSubject
    }

    /// The observable for the date and time of a tap-event as a formatted string.
    ///
    /// - Note: The underlying subject is a `PublishSubject`, therefore a new subscriber will be informed **only with upcoming values**!
    var tapEventDate: Observable<String> {
        tapEventDateSubject
    }

    // MARK: - Private properties

    /// The current date and time as a formatted string.
    ///
    /// - Note: This value is mutable and therefore we store it with a `private` access level.
    private let currentDateSubject = Variable(Date.localizedDateAndTime)

    /// The date and time of a tap-event as a formatted string.
    ///
    /// - Note: This value is mutable and therefore we store it with a `private` access level.
    private let tapEventDateSubject = PublishSubject<String>()

    private var timer: Timer?

    // MARK: - Instance Lifecycle

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.currentDateSubject.value = Date.localizedDateAndTime
        }
    }

    // MARK: - Public methods

    func tapMeButtonTouchUpInside() {
        tapEventDateSubject.update(Date.localizedDateAndTime)
    }
}

// MARK: - Helper

private extension Date {
    static var localizedDateAndTime: String {
        DateFormatter.localizedString(from: .now, dateStyle: .medium, timeStyle: .medium)
    }
}
