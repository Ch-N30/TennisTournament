import Combine
import Foundation

@MainActor
final class MatchViewModel: ObservableObject {
    @Published private(set) var match: StandaloneMatch
    @Published private(set) var isSaving = false
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var tieBreakFirst = ""
    @Published var tieBreakSecond = ""

    private var failedAction: MatchAction?
    private let repository: any MatchRepository
    private let onSaved: (StandaloneMatch) -> Void

    init(match: StandaloneMatch, repository: any MatchRepository, onSaved: @escaping (StandaloneMatch) -> Void) {
        self.match = match
        self.repository = repository
        self.onSaved = onSaved
    }

    var isBusy: Bool { isSaving || isLoading }
    var canRetry: Bool { failedAction != nil }
    var canAddGame: Bool { !isBusy && !match.isFinished && !match.score.needsTieBreak }
    var canUndo: Bool { !isBusy && !match.history.isEmpty }

    func addGame(to side: MatchSide) { perform(.game(side)) }
    func undo() { perform(.undo) }
    func retry() {
        guard let failedAction else { return }
        perform(failedAction)
    }

    func submitTieBreak() {
        guard !isBusy else { return }
        guard let first = Int(tieBreakFirst.trimmingCharacters(in: .whitespacesAndNewlines)),
              let second = Int(tieBreakSecond.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            errorMessage = "Введите два целых неотрицательных числа — итоговые очки тай-брейка."
            return
        }
        perform(.tieBreak(MatchPoints(first: first, second: second)))
    }

    func reload() async {
        guard !isBusy else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let matches = try await repository.loadMatches()
            guard let loaded = matches.first(where: { $0.id == match.id }) else {
                throw MatchStorageError.notFound
            }
            match = loaded
            failedAction = nil
            errorMessage = nil
            onSaved(loaded)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func perform(_ action: MatchAction) {
        guard !isBusy else { return }
        errorMessage = nil
        failedAction = nil
        // Validate before launching any persistence work; keep the displayed score unchanged until commit.
        do {
            _ = try match.applying(action)
        } catch {
            errorMessage = error.localizedDescription
            return
        }
        isSaving = true
        let revision = match.revision
        Task {
            defer { isSaving = false }
            do {
                let saved = try await repository.apply(action, to: match.id, revision: revision)
                match = saved
                tieBreakFirst = ""
                tieBreakSecond = ""
                onSaved(saved)
            } catch {
                failedAction = action
                errorMessage = error.localizedDescription
            }
        }
    }
}
