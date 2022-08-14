//
//  UIKitExampleViewController.swift
//  Example
//
//  Created by Felix Mau on 05.02.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import LightweightObservable
import SwiftUI
import UIKit

final class UIKitExampleViewController: UIViewController {

    // MARK: - Config

    private enum Config {
        static let backgroundRotationAngle: CGFloat = 0.2
        static let stackViewLargeSpacing: CGFloat = 16

        static let animationDuration: TimeInterval = 0.75
        static let animationDelay: TimeInterval = 0.5
    }

    // MARK: - Outlets

    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var contentStackView: UIStackView!

    @IBOutlet private var headlineLabel: UILabel!
    @IBOutlet private var currentDateLabel: UILabel!

    @IBOutlet private var tapEventDateLabel: UILabel!

    // MARK: - Private properties

    /// The view model calculating the current date and time.
    private let viewModel = UIKitExampleViewModel()

    /// The dispose bag for this view controller. On it's deallocation, it removes the
    /// subscription-closures from the corresponding observable-properties.
    private var disposeBag = DisposeBag()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        applyStyle()
        bindViewModelToView()
    }

    // MARK: - Private methods

    private func applyStyle() {
        backgroundImageView.transform = CGAffineTransform(rotationAngle: Config.backgroundRotationAngle)

        contentStackView.setCustomSpacing(Config.stackViewLargeSpacing,
                                          after: currentDateLabel)

        tapEventDateLabel.alpha = 0
    }

    private func bindViewModelToView() {
        viewModel
            .currentDate
            .bind(to: \.text, on: currentDateLabel)
            .disposed(by: &disposeBag)

        viewModel
            .tapEventDate
            .subscribe { [weak self] tapEventDate, _ in
                self?.showTapEventDate(tapEventDate)
            }
            .disposed(by: &disposeBag)
    }

    private func showTapEventDate(_ tapEventDate: String) {
        tapEventDateLabel.text = "Tapped at \(tapEventDate)"
        tapEventDateLabel.alpha = 1

        UIView.animate(withDuration: Config.animationDuration, delay: Config.animationDelay, options: [.curveEaseIn], animations: {
            self.tapEventDateLabel.alpha = 0
        })
    }

    @IBAction
    private func tapMeButtonTouchUpInside(_: Any) {
        viewModel.tapMeButtonTouchUpInside()
    }
}

// MARK: - Helper

struct UIKitExampleView: View {
    var body: some View {
        StoryboardView(name: "UIKitExample")
            .navigationTitle("🏡 UIKit Example")
            .navigationBarTitleDisplayMode(.large)
    }
}
