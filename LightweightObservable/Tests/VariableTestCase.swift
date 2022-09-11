//
//  VariableTestCase.swift
//  LightweightObservableTests
//
//  Created by Felix Mau on 11.02.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import LightweightObservable
import XCTest

final class VariableTestCase: XCTestCase {

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

    func test_value_shouldContainInitialValue() {
        // Given
        let initialValue = 123
        let variable = Variable(initialValue)

        // Then
        XCTAssertEqual(variable.value, initialValue)
    }

    // MARK: - Test method `update(_:)`

    func test_update_shouldUpdatePropertyValue() {
        // Given
        let variable = Variable(123)
        let newValue = 456

        // When
        variable.update(newValue)

        // Then
        XCTAssertEqual(variable.value, newValue)
    }

    // MARK: - Test method `observe(_:)`

    func test_variable_shouldInformSubscriber_withInitialValue() {
        // Given
        var receivedNewValue: Int?
        var receivedOldValue: Int?

        let expectation = expectation(description: "Expect observer to be informed.")

        let variable = Variable(0)

        // When
        variable.subscribe { newValue, oldValue in
            receivedNewValue = newValue
            receivedOldValue = oldValue

            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // Then
        wait(for: [expectation], timeout: .ulpOfOne)

        XCTAssertEqual(receivedNewValue, 0)
        XCTAssertNil(receivedOldValue)
    }

    func test_variable_shouldUpdateSubscriber_withCorrectValues() {
        // Given
        var receivedNewValues = [Int]()
        var receivedOldValues = [Int?]()

        let expectation = expectation(description: "Expected observer to be invoked ten times between `0` and `9`.")
        expectation.expectedFulfillmentCount = 10

        let variable = Variable(0)
        variable.subscribe { newValue, oldValue in
            receivedNewValues.append(newValue)
            receivedOldValues.append(oldValue)

            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        for value in 1 ..< 10 {
            variable.update(value)
        }

        // Then
        wait(for: [expectation], timeout: .ulpOfOne)

        let expectedNewValues = Array(0 ..< 10)
        XCTAssertEqual(receivedNewValues, expectedNewValues)

        let expectedOldValues = [nil] + expectedNewValues.dropLast()
        XCTAssertEqual(receivedOldValues, expectedOldValues)
    }

    func test_variable_shouldUpdateSubscriber_withNilValueWithoutCrashing() {
        // Given
        var receivedNewValue: Int?

        let expectation = expectation(description: "Expect observer to be informed two times: Once with the initial value and second with `nil`.")
        expectation.expectedFulfillmentCount = 2

        let variable: Variable<Int?> = Variable(0)
        variable.subscribe { newValue, _ in
            receivedNewValue = newValue
            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        variable.update(nil)

        // Then
        wait(for: [expectation], timeout: .ulpOfOne)

        XCTAssertNil(receivedNewValue)
    }

    /// Test case for <https://github.com/fxm90/LightweightObservable/pull/5>.
    func test_variable_shouldUpdateValue_fromSubscriptionClosure() {
        // Given
        enum Counter {
            case one
            case two
        }

        var receivedValues = [Counter]()
        let counterVariable = Variable<Counter>(.one)

        // When
        counterVariable.subscribe { newValue, _ in
            receivedValues.append(newValue)

            switch newValue {
            case .one:
                counterVariable.value = .two

            case .two:
                break
            }
        }.disposed(by: &disposeBag)

        // Then
        XCTAssertEqual(receivedValues, [.one, .two])
    }
}
