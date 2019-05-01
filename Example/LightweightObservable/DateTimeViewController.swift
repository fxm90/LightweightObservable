//
//  TimeViewController.swift
//  LightweightObservable_Example
//
//  Created by Felix Mau on 04/27/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import UIKit
import LightweightObservable

class DateTimeViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!

    // MARK: - Private properties

    private let timeViewModel = DateTimeViewModel()

    private var disposeBag = DisposeBag()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        timeViewModel.formattedDate.subscribeDistinct { [weak self] newFormattedDate, _ in
            self?.dateLabel.text = newFormattedDate
        }.add(to: &disposeBag)

        timeViewModel.formattedTime.subscribe { [weak self] newFormattedTime, _ in
            self?.timeLabel.text = newFormattedTime
        }.add(to: &disposeBag)
    }
}
