//
//  Observable+EquatableTestCase.swift
//  LightweightObservable_Tests
//
//  Created by Felix Mau on 18/05/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import XCTest
import LightweightObservable

class ObservableEquatableTestCase: XCTestCase {
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

    // MARK: - Test method `subscribe(filter:)`

    func testPublishSubjectShouldUpdateSubscriberOnlyOnFilterMatched() {
        // Given
        let assertNewValueIsEvenFilter: (Int, Int?) -> Bool = { newValue, _ in
            newValue.isEven
        }

        let expectation = self.expectation(description: "Expected five even numbers between `0` and `9`.")
        expectation.expectedFulfillmentCount = 5

        let publishSubject = PublishSubject<Int>()
        publishSubject.subscribe(filter: assertNewValueIsEvenFilter, observer: { newValue, _ in
            guard newValue.isEven else { return }

            expectation.fulfill()
        }).disposed(by: &disposeBag)

        // When
        for value in 0 ..< 10 {
            publishSubject.update(value)
        }

        // Then
        waitForExpectations(timeout: 0.001, handler: nil)
    }

    // MARK: - Test method `subscribeDistinct(:)`

    func testVariableShouldInformDistinctSubscriberWithInitialValues() {
        // Given
        let variable = Variable(0)

        // When
        variable.subscribeDistinct { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }.disposed(by: &disposeBag)

        // Then
        XCTAssertEqual(newValue, 0)
        XCTAssertNil(oldValue)
    }

    func testPublishSubjectShouldUpdateDistinctSubscriberWithCorrectValues() {
        // Given
        let expectation = self.expectation(description: "Expected distinct observer to be informed ten times between `0` and `9`.")
        expectation.expectedFulfillmentCount = 10

        let publishSubject = PublishSubject<Int>()
        publishSubject.subscribeDistinct { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue

            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        for value in 0 ..< 10 {
            publishSubject.update(value)

            // Then
            XCTAssertEqual(newValue, value)

            if value == 0 {
                XCTAssertNil(oldValue, "As a `PublishSubject` doesn't have an initial value `oldValue` should still be `nil` during the first iteration.")
            } else {
                XCTAssertEqual(oldValue, value - 1)
            }
        }

        waitForExpectations(timeout: 0.001, handler: nil)
    }

    func testPublishSubjectShouldUpdateDistinctSubscriberJustOnceForSameValue() {
        // Given
        let expectation = self.expectation(description: "Expected distinct observer to be informed just once.")
        expectation.expectedFulfillmentCount = 1

        let publishSubject = PublishSubject<Int>()
        publishSubject.subscribeDistinct { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue

            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        for _ in 0 ..< 10 {
            publishSubject.update(1)

            // Then
            XCTAssertEqual(newValue, 1)
            XCTAssertNil(oldValue)
        }

        waitForExpectations(timeout: 0.001, handler: nil)
    }
}

// MARK: - Helpers

private extension Int {
    var isEven: Bool {
        isMultiple(of: 2)
    }
}
