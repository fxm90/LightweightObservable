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

    // MARK: - Test `deinit`

    func test_observable_shouldNotInformSubscriber_afterDeallocatedDisposable() {
        // Given
        let variable = Variable(0)
        let observable: Observable<Int> = variable

        var disposable: Disposable? = observable.subscribe { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }

        // Workaround to fix warning `Variable 'disposable' was written to, but never read`
        XCTAssertNotNil(disposable, "Precondition failed - Expected to have a valid instance at this point.")

        // When
        disposable = nil
        variable.value = 1

        // Then
        XCTAssertEqual(newValue, 0, "As we've deallocated our disposable the observer should not be updated.")
        XCTAssertNil(oldValue)
    }

    func test_observable_shouldNotInformSubscriber_afterDeallocatedDisposeBag() {
        // Given
        let variable = Variable(0)
        let observable: Observable<Int> = variable

        observable.subscribe { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }.disposed(by: &disposeBag)

        // When
        disposeBag = nil
        variable.value = 1

        // Then
        XCTAssertEqual(newValue, 0, "As we've deallocated our disposable the observer should not be updated.")
        XCTAssertNil(oldValue)
    }
}
