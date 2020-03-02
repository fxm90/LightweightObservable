//
//  Observable+KeyPathTestCase.swift
//  LightweightObservable_Tests
//
//  Created by Felix Mau on 13/02/20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import XCTest
import LightweightObservable

class ObservableKeyPathTestCase: XCTestCase {
    // MARK: - Private properties

    var disposeBag: DisposeBag!

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil

        super.tearDown()
    }

    // MARK: - Test method `bind(to:on)`

    func testBindToShouldUpdatePropertyAccordingly() {
        // Given
        // swiftlint:disable:next nesting
        class IntStorage {
            var value = 0
        }

        let intStorage = IntStorage()

        let variable = Variable(0)
        let observable: Observable<Int> = variable

        // When
        observable
            .bind(to: \.value, on: intStorage)
            .disposed(by: &disposeBag)

        variable.value = 123

        // Then
        XCTAssertEqual(variable.value, intStorage.value)
    }

    func testBindToShouldUpdateOptionalPropertyAccordingly() {
        // Given
        // swiftlint:disable:next nesting
        class IntStorage {
            var value: Int?
        }

        let intStorage = IntStorage()

        let variable = Variable(0)
        let observable: Observable<Int> = variable

        // When
        observable
            .bind(to: \.value, on: intStorage)
            .disposed(by: &disposeBag)

        variable.value = 456

        // Then
        XCTAssertEqual(variable.value, intStorage.value)
    }
}
