//
//  Observable+KeyPathTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 13.02.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import XCTest
import LightweightObservable

final class ObservableKeyPathTestCase: XCTestCase {
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

    // MARK: - Test method `bind(to:on)`

    func test_bindTo_shouldUpdatePropertyAccordingly() {
        // Given
        let storage = Storage(0)

        let variable = Variable(0)
        let observable: Observable<Int> = variable

        // When
        observable
            .bind(to: \.value, on: storage)
            .disposed(by: &disposeBag)

        variable.value = 123

        // Then
        XCTAssertEqual(variable.value, storage.value)
    }

    func test_bindTo_shouldUpdateOptionalPropertyAccordingly() {
        // Given
        let storage = Storage<Int?>(nil)

        let variable = Variable(0)
        let observable: Observable<Int> = variable

        // When
        observable
            .bind(to: \.value, on: storage)
            .disposed(by: &disposeBag)

        variable.value = 456

        // Then
        XCTAssertEqual(variable.value, storage.value)
    }
}

// MARK: - Helper

private final class Storage<T: Equatable> {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}
