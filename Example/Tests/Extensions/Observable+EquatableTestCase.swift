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

    func testObservableShouldUpdateSubscriberOnlyOnFilterMatched() {
        // Given
        let assertNewValueIsEvenFilter: (Int, Int?) -> Bool = { newValue, _ in
            newValue.isEven
        }

        let expectation = self.expectation(description: "Expected five even numbers between `0` and `9`.")
        expectation.expectedFulfillmentCount = 5

        let variable = Variable(0)
        variable.subscribe(filter: assertNewValueIsEvenFilter, observer: { newValue, _ in
            guard newValue.isEven else {
                XCTFail("The received value `\(newValue)` is odd!")
                return
            }

            expectation.fulfill()
        }).disposed(by: &disposeBag)

        // When
        for value in 1 ..< 10 {
            variable.value = value
        }

        // Then
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    // MARK: - Test method `subscribeDistinct(:)`

    func testObservableShouldInformDistinctSubscriberWithInitialValues() {
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

    func testObservableShouldUpdateDistinctSubscriberWithCorrectValues() {
        // Given
        let variable = Variable(0)

        variable.subscribeDistinct { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }.disposed(by: &disposeBag)

        // When
        for value in 1 ..< 10 {
            variable.value = value

            // Then
            XCTAssertEqual(newValue, value)
            XCTAssertEqual(oldValue, value - 1)
        }
    }

    func testObservableShouldUpdateDistinctSubscriberJustOnceForSameValue() {
        // Given
        let expectation = self.expectation(description: "Expected distinct observer to be informed two times: The initial call and the new value.")
        expectation.expectedFulfillmentCount = 2

        let variable = Variable(0)
        variable.subscribeDistinct { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue

            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        for _ in 1 ..< 10 {
            variable.value = 1

            // Then
            XCTAssertEqual(newValue, 1)
            XCTAssertEqual(oldValue, 0)
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

// MARK: - Helpers

private extension Int {
    var isEven: Bool {
        isMultiple(of: 2)
    }
}
