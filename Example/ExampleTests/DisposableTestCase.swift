//
//  DisposableTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 11.02.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import XCTest
import LightweightObservable

final class DisposableTestCase: XCTestCase {
    // MARK: - Test `deinit`

    func testDisposeClosureShouldNotBeCalledBeforeDeInit() {
        // Given
        let expectation = expectation(description: "Expect dispose closure not to be called.")
        expectation.isInverted = true

        var disposable: Disposable? = Disposable {
            expectation.fulfill()
        }

        // Workaround to fix warning `Variable 'disposable' was written to, but never read`
        XCTAssertNotNil(disposable, "Precondition failed - Expected to have a valid instance at this point.")

        // When
        // ...

        // Then
        wait(for: [expectation], timeout: 0.1)
    }

    func testDisposeClosureShouldBeCalledOnDeInit() {
        // Given
        let expectation = expectation(description: "Expect dispose closure to be called on deinit.")

        var disposable: Disposable? = Disposable {
            expectation.fulfill()
        }

        // Workaround to fix warning `Variable 'disposable' was written to, but never read`
        XCTAssertNotNil(disposable, "Precondition failed - Expected to have a valid instance at this point.")

        // When
        disposable = nil

        // Then
        wait(for: [expectation], timeout: .ulpOfOne)
    }

    // MARK: - Test method `disposed(by:)`

    func testDisposedByShouldAddDisposableToGivenDisposeBag() {
        // Given
        var disposeBag = DisposeBag()
        let disposable = Disposable {}

        // When
        disposable.disposed(by: &disposeBag)

        // Then
        XCTAssertEqual(disposeBag.count, 1)
        XCTAssertTrue(disposeBag.first === disposable)
    }
}
