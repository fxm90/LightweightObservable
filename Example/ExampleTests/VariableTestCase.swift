//
//  VariableTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 11.02.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import XCTest
import LightweightObservable

final class VariableTestCase: XCTestCase {
    // MARK: - Private properties

    private var disposeBag: DisposeBag!

    private var oldValue: Int?
    private var newValue: Int?

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

    func testValueShouldContainTheInitialValue() {
        // Given
        let initialValue = 123
        let variable = Variable(initialValue)

        // Then
        XCTAssertEqual(variable.value, initialValue)
    }

    // MARK: - Test method `update(_:)`

    func testUpdateShouldUpdatePropertyValue() {
        // Given
        let variable = Variable(123)
        let newValue = 456

        // When
        variable.update(newValue)

        // Then
        XCTAssertEqual(variable.value, newValue)
    }

    // MARK: - Test method `observe(_:)`

    func testVariableShouldInformSubscriberWithInitialValue() {
        // Given
        let variable = Variable(0)

        // When
        variable.subscribe { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }.disposed(by: &disposeBag)

        // Then
        XCTAssertEqual(newValue, 0)
        XCTAssertNil(oldValue)
    }

    func testVariableShouldUpdateSubscriberWithCorrectValues() {
        // Given
        let variable = Variable(0)
        variable.subscribe { newValue, oldValue in
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

    func testVariableShouldUpdateSubscriberWithNilValueWithoutCrashing() {
        // Given
        let variable: Variable<Int?> = Variable(0)
        variable.subscribe { newValue, _ in
            self.newValue = newValue
        }.disposed(by: &disposeBag)

        // When
        variable.value = nil

        // Then
        XCTAssertNil(newValue)
    }

    /// Test case for <https://github.com/fxm90/LightweightObservable/pull/5>.
    func testVariableShouldUpdateValueFromSubscriptionClosure() {
        // Given
        enum Counter {
            case one
            case two
        }

        let counterVariable = Variable<Counter>(.one)
        var receivedValues = [Counter]()

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
