//
//  DateTimeViewController.swift
//  LightweightObservable_Example
//
//  Created by Felix Mau on 04/27/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import UIKit
import LightweightObservable

class DateTimeViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var dateTimeLabel: UILabel!

    @IBOutlet private var savedFormattedDateTimesTextView: UITextView!

    // MARK: - Private properties

    /// The view model calculating the current date and time.
    private let dateTimeViewModel = DateTimeViewModel()

    /// The dispose bag for this view controller. On it's deallocation, it removes the
    /// subscription-closures from the corresponding observable-properties.
    private var disposeBag = DisposeBag()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModelToView()
    }

    @IBAction func didTapSaveTimeButton(_: Any) {
        dateTimeViewModel.didTapSaveTimeButton()
    }

    // MARK: - Private methods

    private func bindViewModelToView() {
        dateTimeViewModel
            .formattedDateTime
            .bind(to: \.text, on: dateTimeLabel)
            .disposed(by: &disposeBag)

        dateTimeViewModel
            .saveFormattedDateTime
            .subscribe { [weak self] newValue, _ in
                self?.savedFormattedDateTimesTextView.text.append(newValue)
            }
            .disposed(by: &disposeBag)
    }
}
