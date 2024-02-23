import Compass

final class AppNavigator: Navigator {

    private let window: Window

    init(window: Window) {
        self.window = window
    }

    func navigate(to viewController: Compass.ViewController, transition: Compass.Transition) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    func exitFlow(coordinator: Compass.Coordinator, animated: Bool) {
        fatalError("shouldn't exit")
    }

    func dismiss(animated: Bool) {
        fatalError("shouldn't dismiss")
    }

    func popViewController(animated: Bool) {
        fatalError("shouldn't pop")
    }

    func popToViewController(_ viewController: Compass.ViewController, animated: Bool) {
        fatalError("shouldn't pop")
    }

    func popToRootViewController(animated: Bool) {
        fatalError("shouldn't pop")
    }

}
