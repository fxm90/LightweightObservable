//
//  ObservableTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 11.02.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import XCTest
import LightweightObservable

final class ObservableTestCase: XCTestCase {

    // MARK: - Test method `subscribe(_:)`

    func test_subscribe_shouldNotInformSubscriber_afterDeallocatedDisposable() {
        // Given
        let expectation = expectation(description: "Expect subscription closure to NOT be invoked!")
        expectation.isInverted = true

        let publishSubject = PublishSubject<Int>()
        let observable: Observable<Int> = publishSubject

        var disposable: Disposable? = observable.subscribe { _, _ in
            expectation.fulfill()
        }

        // Workaround to fix warning `Variable 'disposable' was written to, but never read`
        XCTAssertNotNil(disposable, "Precondition failed - Expected to have a valid instance at this point.")

        // When
        disposable = nil
        publishSubject.update(1)

        // Then
        wait(for: [expectation], timeout: .ulpOfOne)
    }

    func test_subscribe_shouldNotInformSubscriber_afterDeallocatedDisposeBag() {
        // Given
        let expectation = expectation(description: "Expect subscription closure to NOT be invoked!")
        expectation.isInverted = true

        let publishSubject = PublishSubject<Int>()
        let observable: Observable<Int> = publishSubject

        var disposeBag = DisposeBag()
        observable.subscribe { _, _ in
            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        disposeBag.removeAll()
        publishSubject.update(1)

        // Then
        wait(for: [expectation], timeout: .ulpOfOne)
    }
}
