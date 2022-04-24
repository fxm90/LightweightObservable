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

    func test_validInstance_shouldNotInvokeClosure() {
        // Given
        let expectation = expectation(description: "As we've NOT deallocated our disposable we expect the closure to also NOT be invoked.")
        expectation.isInverted = true

        let disposable: Disposable? = Disposable {
            expectation.fulfill()
        }

        withExtendedLifetime(disposable) {
            // When
            // ...

            // Then
            wait(for: [expectation], timeout: .ulpOfOne)
        }
    }

    func test_deinit_shouldInvokeClosure() {
        // Given
        let expectation = expectation(description: "As we've deallocated our disposable we expect the closure to be invoked.")

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

    func test_disposedBy_shouldAddDisposable_toGivenDisposeBag() {
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
