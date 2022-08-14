//
//  PublishSubjectTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 11.02.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import LightweightObservable
import XCTest

final class PublishSubjectTestCase: XCTestCase {

    // MARK: - Private properties

    private var disposeBag: DisposeBag!

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil

        super.tearDown()
    }

    // MARK: - Test property `value`

    func test_value_shouldContainNil_initially() {
        // Given
        let publishSubject = PublishSubject<Int>()

        // Then
        XCTAssertNil(publishSubject.value)
    }

    // MARK: - Test method `update(_:)`

    func test_update_shouldUpdatePropertyValue() {
        // Given
        let publishSubject = PublishSubject<Int>()
        let newValue = 123

        // When
        publishSubject.update(newValue)

        // Then
        XCTAssertEqual(publishSubject.value, newValue)
    }

    // MARK: - Test method `observe(_:)`

    func test_publishSubject_shouldNotInformSubscriber_withInitialValue() {
        // Given
        let publishSubject = PublishSubject<Int>()

        let expectation = expectation(description: "Expect observer to NOT be informed.")
        expectation.isInverted = true

        // When
        publishSubject.subscribe { _, _ in
            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // Then
        wait(for: [expectation], timeout: .ulpOfOne)
    }

    func test_publishSubject_shouldUpdateSubscriber_withGivenValues() {
        // Given
        var receivedNewValues = [Int]()
        var receivedOldValues = [Int?]()

        let expectation = expectation(description: "Expected observer to be invoked ten times between `0` and `9`.")
        expectation.expectedFulfillmentCount = 10

        let publishSubject = PublishSubject<Int>()
        publishSubject.subscribe { newValue, oldValue in
            receivedNewValues.append(newValue)
            receivedOldValues.append(oldValue)

            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        for value in 0 ..< 10 {
            publishSubject.update(value)
        }

        // Then
        wait(for: [expectation], timeout: .ulpOfOne)

        let expectedNewValues = Array(0 ..< 10)
        XCTAssertEqual(receivedNewValues, expectedNewValues)

        let expectedOldValues = [nil] + expectedNewValues.dropLast()
        XCTAssertEqual(receivedOldValues, expectedOldValues)
    }

    func test_publishSubject_shouldUpdateSubscriber_withNilValueWithoutCrashing() {
        // Given
        var receivedNewValue: Int?
        let expectation = expectation(description: "Expect observer to be informed with `nil`.")

        let publishSubject = PublishSubject<Int?>()
        publishSubject.subscribe { newValue, _ in
            receivedNewValue = newValue
            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        publishSubject.update(nil)

        // Then
        wait(for: [expectation], timeout: .ulpOfOne)

        XCTAssertNil(receivedNewValue)
    }
}
