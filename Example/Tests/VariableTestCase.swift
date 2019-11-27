//
//  VariableTestCase.swift
//  LightweightObservable_Tests
//
//  Created by Felix Mau on 22/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import LightweightObservable

class VariableTestCase: XCTestCase {
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

    func testValueShouldContainTheInitialValue() {
        // Given
        let initialValue = 123
        let variable = Variable(initialValue)

        // Then
        XCTAssertEqual(variable.value, initialValue)
    }

    func testValueShouldContainNewValueAfterUpdating() {
        // Given
        let variable = Variable(123)
        let newValue = 456

        // When
        variable.value = newValue

        // Then
        XCTAssertEqual(variable.value, newValue)
    }

    // MARK: - Test method `observe(:)`

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
}
