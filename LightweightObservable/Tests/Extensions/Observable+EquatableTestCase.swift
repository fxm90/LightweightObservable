//
//  Observable+EquatableTestCase.swift
//  LightweightObservableTests
//
//  Created by Felix Mau on 18.05.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import LightweightObservable
import XCTest

final class ObservableEquatableTestCase: XCTestCase {

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

    // MARK: - Test method `subscribe(filter:observer:)`

    func test_publishSubject_shouldUpdateFilteredSubscriber_withCorrectValues() {
        // Given
        var receivedNewValues = [Int]()
        var receivedOldValues = [Int?]()

        let expectation = expectation(description: "Expected observer to be invoked five times for even numbers between `0` and `9`.")
        expectation.expectedFulfillmentCount = 5

        let publishSubject = PublishSubject<Int>()
        publishSubject.subscribe(filter: assertNewValueIsEven) { newValue, oldValue in
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

        let expectedNewValues = Array(stride(from: 0, to: 10, by: 2))
        XCTAssertEqual(receivedNewValues, expectedNewValues)

        let expectedOldValues = [nil] + expectedNewValues.dropLast()
        XCTAssertEqual(receivedOldValues, expectedOldValues)
    }

    // MARK: - Test method `subscribeDistinct(_:)`

    func test_variable_shouldInformDistinctSubscriber_withInitialValue() {
        // Given
        var receivedNewValue: Int?
        var receivedOldValue: Int?

        let variable = Variable(0)

        // When
        variable.subscribeDistinct { newValue, oldValue in
            receivedNewValue = newValue
            receivedOldValue = oldValue
        }.disposed(by: &disposeBag)

        // Then
        XCTAssertEqual(receivedNewValue, 0)
        XCTAssertNil(receivedOldValue)
    }

    func test_publishSubject_shouldUpdateDistinctSubscriber_withCorrectValues() {
        // Given
        var receivedNewValues = [Int]()
        var receivedOldValues = [Int?]()

        let expectation = expectation(description: "Expected distinct observer to be invoked ten times between `0` and `9`.")
        expectation.expectedFulfillmentCount = 10

        let publishSubject = PublishSubject<Int>()
        publishSubject.subscribeDistinct { newValue, oldValue in
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

    func test_publishSubject_shouldUpdateDistinctSubscriber_justOnceForSameValue() {
        // Given
        var receivedNewValue: Int?
        var receivedOldValue: Int?

        let expectation = expectation(description: "Expected distinct observer to be invoked just once.")
        expectation.expectedFulfillmentCount = 1

        let publishSubject = PublishSubject<Int>()
        publishSubject.subscribeDistinct { newValue, oldValue in
            receivedNewValue = newValue
            receivedOldValue = oldValue

            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        for _ in 0 ..< 10 {
            publishSubject.update(1)
        }

        // Then
        wait(for: [expectation], timeout: .ulpOfOne)

        XCTAssertEqual(receivedNewValue, 1)
        XCTAssertNil(receivedOldValue)
    }
}

// MARK: - Helper

private extension ObservableEquatableTestCase {
    // swiftformat:disable:next unusedArguments
    func assertNewValueIsEven(_ newValue: Int, oldValue _: Int?) -> Bool {
        newValue.isMultiple(of: 2)
    }
}
