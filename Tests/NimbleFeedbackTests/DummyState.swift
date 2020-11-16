@testable import NimbleFeedback

struct DummyState: State {

    enum Event {
        case none
        case alpha
        case beta
    }

    var lastEvent: Event?

    static func reduce(state: DummyState, event: DummyState.Event) -> DummyState {
        var result = state

        result.lastEvent = (event == .none ? nil : event)

        return result
    }

    var isAlpha: Bool? {
        if let le = lastEvent {
            return le == .alpha
        }
        return nil
    }
}
