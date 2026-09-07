import Combine
import Foundation

@MainActor
final class MatchesListViewModel: ObservableObject {
    @Published private(set) var matches: [StandaloneMatch] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    private let repository: any MatchRepository

    init(repository: any MatchRepository) { self.repository = repository }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let loaded = try await repository.loadMatches()
            // A read may resume after a newer write callback. Never replace a newer revision.
            for match in loaded { accept(match) }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func accept(_ match: StandaloneMatch) {
        if let index = matches.firstIndex(where: { $0.id == match.id }) {
            if matches[index].revision <= match.revision { matches[index] = match }
        } else {
            matches.append(match)
        }
        matches.sort {
            if $0.isFinished != $1.isFinished { return !$0.isFinished }
            if $0.createdAt != $1.createdAt { return $0.createdAt > $1.createdAt }
            return $0.id.uuidString < $1.id.uuidString
        }
    }
}
