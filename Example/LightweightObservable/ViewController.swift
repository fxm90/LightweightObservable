//
//  TimeViewController.swift
//  LightweightObservable_Example
//
//  Created by Felix Mau on 04/27/2019.
//  Copyright (c) 2019 Felix Mau. All rights reserved.
//

import UIKit
import LightweightObservable

class TimeViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var timeLabel: UILabel!

    // MARK: - Private properties

    private let timeViewModel = TimeViewModel()

    private var disposeBag = DisposeBag()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        timeViewModel.formattedTime.subscribe { [weak self] newFormattedTime, _ in
            self?.timeLabel.text = newFormattedTime
        }.add(to: &disposeBag)
    }
}
