import Combine
import Foundation

@MainActor
final class MatchesListViewModel: ObservableObject {
    @Published private(set) var matches: [StandaloneMatch] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var deletingID: UUID?
    @Published var pendingDeletion: StandaloneMatch?
    private var deletedIDs: Set<UUID> = []
    private let repository: any MatchRepository

    init(repository: any MatchRepository) { self.repository = repository }

    func load() async {
        guard !isLoading, deletingID == nil else { return }
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
        // Ignore late score callbacks and read snapshots after a successful deletion.
        guard !deletedIDs.contains(match.id) else { return }
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

    func requestDeletion(_ match: StandaloneMatch) {
        guard !isLoading, deletingID == nil else { return }
        pendingDeletion = match
    }

    func confirmDeletion(_ match: StandaloneMatch) {
        guard !isLoading, deletingID == nil else { return }
        pendingDeletion = nil
        deletingID = match.id
        errorMessage = nil
        Task {
            defer { deletingID = nil }
            do {
                try await repository.delete(id: match.id, revision: match.revision)
                deletedIDs.insert(match.id)
                matches.removeAll { $0.id == match.id }
            } catch {
                errorMessage = "Не удалось удалить матч. \(error.localizedDescription)"
            }
        }
    }
}
