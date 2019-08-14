import Foundation
import Nimble


/// A basic protocol that every state type must conform to in order to be testable.
protocol State {

    associatedtype Event

    /// A basic reduce that accepts current state and event and produces a new state.
    ///
    /// - Parameters:
    ///   - state: current state;
    ///   - event: event that affects the state;
    /// - Returns: New state.
    static func reduce(state: Self, event: Event) -> Self
}


extension State {

    /// Convenience method to mutate a state.
    ///
    /// - Parameters:
    ///   - event: event to apply to receiver;
    mutating func apply(_ event: Event) {
        self = Self.reduce(state: self, event: event)
    }
}

extension Expectation where T: State {

    typealias Query<Q> = (T) -> Q?

    func after(_ events: T.Event...) -> StateChangeExpectation<T> {
        return StateChangeExpectation(expectation: self, events: events, change: nil)
    }

    func after(_ events: [T.Event]) -> StateChangeExpectation<T> {
        return StateChangeExpectation(expectation: self, events: events, change: nil)
    }

    func after(_ change: @escaping () -> (), _ events: T.Event...) -> StateChangeExpectation<T> {
        return StateChangeExpectation(expectation: self, events: events, change: change)
    }

    func to<Q>(_ query: @escaping Query<Q>) {
        StateChangeExpectation(expectation: self, events: [], change: nil)
            .to(query)
    }

    func toHave<Q>(_ query: @escaping Query<Q>) {
        to(query)
    }

    func toMatch(_ matcher: @escaping (T) -> Bool) {
        StateChangeExpectation(expectation: self, events: [], change: nil)
            .resolve(matcher)
    }
}

// MARK: - StateChangeExpectation

struct StateChangeExpectation<S: State> {

    let expectation: Expectation<S>
    let events: [S.Event]
    let change: (() -> ())?

    var noChanges: Bool {
        return events.isEmpty && change == nil
    }

    private func afterChanges(to state: S) -> S {
        change?()
        return events.reduce(into: state) { $0.apply($1) }
    }
}

// MARK: Query

extension StateChangeExpectation {

    typealias Query<Q> = (S) -> Q?

    func to<Q>(_ query: @escaping Query<Q>) {
        resolve(query, toBecomeNonNil: true)
    }

    func toHave<Q>(_ query: @escaping Query<Q>) {
        resolve(query, toBecomeNonNil: true)
    }

    func notTo<Q>(_ query: @escaping Query<Q>) {
        resolve(query, toBecomeNonNil: false)
    }

    private func resolve<Q>(_ query: @escaping Query<Q>, toBecomeNonNil: Bool) {
        resolve({ query($0) == nil }, to: "be a nil query", expectToFail: toBecomeNonNil)
    }
}

// MARK: Match

extension StateChangeExpectation {

    typealias Match = (S) -> Bool


    /// An expectation that checks whether a value changes after received events.
    ///
    /// - Parameters:
    ///   - matcher: a predicate to match a value against.
    func toTurn(_ matcher: @escaping Match) {
        resolve(matcher)
    }

    /// An expectation that checks whether a value remains the same after received events.
    ///
    /// - Parameters:
    ///   - matcher: a predicate to match a value against.
    func toStay(_ matcher: @escaping Match) {
        resolve(matcher, expectSameResult: true)
    }
}

// MARK: -

private extension StateChangeExpectation {

    func resolve(_ matcher: @escaping Match, to msg: String = "match",
                 expectToFail: Bool = false,
                 expectSameResult: Bool = false) {

        let afterTo = expectToFail ? expectation.notTo : expectation.to
        let beforeTo = expectSameResult ? afterTo : expectToFail ? expectation.to : expectation.notTo

        if noChanges {
            afterTo(predicate("\(msg) without any events", with: matcher), nil)
        } else {
            beforeTo(predicate("\(msg) before applying events", with: matcher), nil)
            afterTo(predicate("\(msg) after applying events", with: { matcher(self.afterChanges(to: $0)) }), nil)
        }
    }

    func predicate(_ msg: String, with matcher: @escaping Match) -> Predicate<S> {
        return Predicate { s -> PredicateResult in
            let result = try s.evaluate().flatMap(matcher) ?? false
            return PredicateResult(bool: result, message: .expectedTo(msg))
        }
    }

    func apply(_ events: [S.Event], then matcher: @escaping Match) -> Match {
        return { matcher(events.reduce(into: $0) { $0.apply($1) }) }
    }
}


