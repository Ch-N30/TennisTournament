import Combine

/// Owns one assembly attempt for the lifetime of the root view.
@MainActor
final class AppBootstrap: ObservableObject {
    let coordinator: AppCoordinator?
    let error: (any Error)?

    init(makeDependencies: @MainActor () throws -> AppDependencyContainer = AppDependencyContainer.makeLive) {
        do {
            coordinator = AppCoordinator(dependencies: try makeDependencies())
            error = nil
        } catch {
            coordinator = nil
            self.error = error
        }
    }

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        error = nil
    }
}
