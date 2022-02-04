//
//  Observable+Combine.swift
//  LightweightObservable
//
//  Created by Felix Mau on 04.02.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import Combine

// Based on:
// https://thoughtbot.com/blog/lets-build-a-custom-publisher-in-combine

@available(iOS 13.0, *)
extension Observable: Publisher {
    public typealias Output = T
    public typealias Failure = Never

    public func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        let subscription = Subscription(observable: self, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

@available(iOS 13.0, *)
private extension Observable {
    ///
    ///
    final class Subscription<S: Subscriber> where S.Input == Output, S.Failure == Failure {
        ///
        private let subscriber: S?

        ///
        private var disposable: Disposable?

        ///
        ///
        init(observable: Observable<Output>, subscriber: S) {
            self.subscriber = subscriber

            //
            //
            disposable = observable.subscribe { [weak self] value, _ in
                _ = self?.subscriber?.receive(value)
            }
        }
    }
}

@available(iOS 13.0, *)
extension Observable.Subscription: Subscription {
    func request(_: Subscribers.Demand) {
        // Nothing to do here, as we only want to send events when they occur.
    }

    func cancel() {
        disposable = nil
    }
}
