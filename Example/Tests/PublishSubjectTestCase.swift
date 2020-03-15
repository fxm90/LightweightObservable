//
//  PublishSubjectTestCase.swift
//  LightweightObservable_Tests
//
//  Created by Felix Mau on 22/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import LightweightObservable

class PublishSubjectTestCase: XCTestCase {
    // MARK: - Private properties

    var disposeBag: DisposeBag!

    var oldValue: Int?
    var newValue: Int?

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()

        oldValue = nil
        newValue = nil
    }

    override func tearDown() {
        disposeBag = nil

        super.tearDown()
    }

    // MARK: - Test property `value`

    func testValueShouldContainNilInitially() {
        // Given
        let publishSubject = PublishSubject<Int>()

        // Then
        XCTAssertNil(publishSubject.value)
    }

    func testValueShouldContainNewValueAfterUpdating() {
        // Given
        let publishSubject = PublishSubject<Int>()
        let newValue = 123

        // When
        publishSubject.update(newValue)

        // Then
        XCTAssertEqual(publishSubject.value, newValue)
    }

    // MARK: - Test method `observe(:)`

    func testPublishSubjectShouldNotInformSubscriberWithInitialValue() {
        // Given
        let publishSubject = PublishSubject<Int>()

        let expectation = self.expectation(description: "Expect observer to NOT be informed.")
        expectation.isInverted = true

        // When
        publishSubject.subscribe { _, _ in
            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // Then
        wait(for: [expectation], timeout: 0.1)
    }

    func testPublishSubjectShouldUpdateSubscriberWithGivenValues() {
        // Given
        let publishSubject = PublishSubject<Int>()
        publishSubject.subscribe { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }.disposed(by: &disposeBag)

        // When
        for value in 0 ..< 10 {
            publishSubject.update(value)

            // Then
            XCTAssertEqual(newValue, value)

            if value == 0 {
                XCTAssertNil(oldValue, "As a `PublishSubject` doesn't have an initial value, the `oldValue` should still be `nil` during the first iteration.")
            } else {
                XCTAssertEqual(oldValue, value - 1)
            }
        }
    }

    func testPublishSubjectShouldUpdateSubscriberWithNilValueWithoutCrashing() {
        // Given
        let publishSubject = PublishSubject<Int?>()
        publishSubject.subscribe { newValue, _ in
            self.newValue = newValue
        }.disposed(by: &disposeBag)

        // When
        publishSubject.update(nil)

        // Then
        XCTAssertNil(newValue)
    }
}
