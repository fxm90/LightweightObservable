//
//  Observable+CombineTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 05.02.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
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

    func testSinkShouldReceiveCorrectValuesFromPublishSubject() {
        // Given
        let publishSubject = PublishSubject<Int>()

        var receivedValues = [Int]()
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

    func testSinkShouldReceiveInitialValueFromVariable() {
        // When
        let initialValue = 123
        let publishSubject = Variable(initialValue)

        var receivedValue: Int?
        publishSubject.sink {
            receivedValue = $0
        }.store(in: &subscriptions)

        // Then
        XCTAssertEqual(receivedValue, initialValue)
    }

    func testSinkShouldNotReceiveValuesAfterRemovingSubscription() {
        // Given
        let publishSubject = PublishSubject<Int>()

        var receivedValues = [Int]()
        publishSubject.sink {
            receivedValues.append($0)
        }.store(in: &subscriptions)

        for value in 0 ..< 5 {
            publishSubject.update(value)
        }

        // When
        subscriptions.removeAll()

        for value in 5 ..< 9 {
            publishSubject.update(value)
        }

        // Then
        XCTAssertEqual(receivedValues, Array(0 ..< 5))
    }

    func testSinkShouldNotCreateARetainCycle() {
        // Given
        weak var optionalPublishSubject: PublishSubject<Int>?

        autoreleasepool {
            let publishSubject = PublishSubject<Int>()
            optionalPublishSubject = publishSubject

            // When
            publishSubject
                .sink { _ in }
                .store(in: &subscriptions)
        }

        // Then
        XCTAssertNil(optionalPublishSubject)
    }
}
