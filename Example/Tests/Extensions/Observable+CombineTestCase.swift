//
//  Observable+CombineTestCase.swift
//  LightweightObservable_Tests
//
//  Created by Felix Mau on 18.05.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import XCTest
import Combine

import LightweightObservable

@available(iOS 13.0, *)
final class ObservableCombineTestCase: XCTestCase {
    // MARK: - Private properties

    private var subscriptions: Set<AnyCancellable>!

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        subscriptions = Set<AnyCancellable>()
    }

    override func tearDown() {
        subscriptions = nil

        super.tearDown()
    }

    // MARK: - Test `sink`

    func test_sink() {
        // Given
        var receivedValues = [Int]()

        let publishSubject = PublishSubject<Int>()
        publishSubject.sink {
            receivedValues.append($0)
        }.store(in: &subscriptions)

        // When
        for value in 0 ..< 10 {
            publishSubject.update(value)
        }

        // Then
        XCTAssertEqual(receivedValues, Array(0 ... 9))
    }
}
