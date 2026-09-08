import Combine
import Foundation
import PRNDSSwiftUI

enum MatchRoute: Hashable {
    case setup
    case match(UUID)
}

enum MatchModalRoute: Hashable {}

@MainActor
public final class MatchesCoordinator: ObservableObject {
    let navigationStore = SwiftUINavigationStore<MatchRoute, MatchModalRoute>()
    let listViewModel: MatchesListViewModel
    @Published private(set) var setupViewModel: MatchSetupViewModel?
    @Published private(set) var matchViewModel: MatchViewModel?
    private let repository: any MatchRepository
    private var flowID = UUID()

    public init(repository: any MatchRepository) {
        self.repository = repository
        listViewModel = MatchesListViewModel(repository: repository)
    }

    func showSetup() {
        guard navigationStore.path.isEmpty else { return }
        let flowID = flowID
        setupViewModel = MatchSetupViewModel(repository: repository) { [weak self] match in
            guard let self else { return }
            listViewModel.accept(match)
            guard self.flowID == flowID, navigationStore.path == [.setup] else { return }
            showMatch(match)
        }
        navigationStore.push(.setup)
    }

    func showMatch(_ match: StandaloneMatch) {
        matchViewModel = MatchViewModel(match: match, repository: repository) { [weak self] saved in
            self?.listViewModel.accept(saved)
        }
        // Replace setup: Back returns to the list, never to an already-started draft.
        navigationStore.setPath([.match(match.id)])
    }

    func reset() {
        flowID = UUID()
        navigationStore.popToRoot()
        setupViewModel = nil
        matchViewModel = nil
    }
}
