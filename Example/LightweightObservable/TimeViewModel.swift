//
//  TimeViewModel.swift
//  LightweightObservable_Example
//
//  Created by Felix Mau on 27/04/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import LightweightObservable

class TimeViewModel {
    // MARK: - Public properties

    var formattedTime: Observable<String> {
        return formattedTimeSubject.asObservable
    }

    // MARK: - Private properties

    private let formattedTimeSubject: Variable<String> = Variable("")

    private var disposeBag = DisposeBag()

    private var timer: Timer?

    // MARK: - Initializer

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }

            self.formattedTimeSubject.value = self.makeFormattedTime()
        })
    }

    deinit {}

    // MARK: - Private methods

    private func makeFormattedTime() -> String {
        return DateFormatter.localizedString(from: Date(),
                                             dateStyle: .medium,
                                             timeStyle: .medium)
    }
}
