import Combine
import Foundation

struct MatchPlayerDraft: Identifiable {
    let id: UUID
    var profileID: UUID?
    var name = ""
    var surname = ""
    let gender: UserGender

    init(gender: UserGender) {
        id = UUID()
        self.gender = gender
    }

    var hasInput: Bool { !name.isEmpty || !surname.isEmpty || profileID != nil }
    var player: MatchPlayer {
        MatchPlayer(
            id: id, profileID: profileID,
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            surname: surname.trimmingCharacters(in: .whitespacesAndNewlines), gender: gender
        )
    }
}

@MainActor
final class MatchSetupViewModel: ObservableObject {
    @Published private(set) var kind: MatchKind = .singles
    @Published private(set) var category: MatchCategory = .men
    @Published var format: MatchFormat = .oneSet
    @Published var sides = [[MatchPlayerDraft(gender: .male)], [MatchPlayerDraft(gender: .male)]]
    @Published private(set) var isSaving = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var hasStarted = false
    @Published var showsCompositionConfirmation = false

    private var pendingComposition: (MatchKind, MatchCategory, [[MatchPlayerDraft]])?
    private let repository: any MatchRepository
    private let onCreated: (StandaloneMatch) -> Void
    private let matchID = UUID()

    init(repository: any MatchRepository, onCreated: @escaping (StandaloneMatch) -> Void) {
        self.repository = repository
        self.onCreated = onCreated
    }

    var categories: [MatchCategory] { kind == .singles ? [.men, .women] : MatchCategory.allCases }

    func requestKind(_ kind: MatchKind) {
        requestComposition(kind: kind, category: kind == .singles && category == .mixed ? .men : category)
    }

    func requestCategory(_ category: MatchCategory) {
        requestComposition(kind: kind, category: category)
    }

    func confirmComposition() {
        guard let (kind, category, sides) = pendingComposition else { return }
        self.kind = kind
        self.category = category
        self.sides = sides
        pendingComposition = nil
        showsCompositionConfirmation = false
        errorMessage = nil
    }

    func cancelComposition() {
        pendingComposition = nil
        showsCompositionConfirmation = false
    }

    func canAddProfile(_ profile: UserProfile, side: Int, position: Int) -> Bool {
        !sides[side][position].hasInput && sides[side][position].gender == profile.gender &&
            !sides.flatMap({ $0 }).contains(where: { $0.profileID == profile.id })
    }

    func addProfile(_ profile: UserProfile, side: Int, position: Int) {
        guard !isSaving, canAddProfile(profile, side: side, position: position) else { return }
        sides[side][position].name = profile.name
        sides[side][position].surname = profile.surname
        sides[side][position].profileID = profile.id
    }

    func clearPlayer(side: Int, position: Int) {
        guard !isSaving else { return }
        sides[side][position] = MatchPlayerDraft(gender: category.gender(at: position))
    }

    func start() {
        guard !isSaving, !hasStarted else { return }
        errorMessage = nil
        do {
            let configuration = MatchConfiguration(
                kind: kind, category: category, format: format, sides: sides.map { $0.map(\.player) }
            )
            let match = try StandaloneMatch(id: matchID, configuration: configuration)
            isSaving = true
            Task {
                defer { isSaving = false }
                do {
                    let saved = try await repository.create(match)
                    hasStarted = true
                    onCreated(saved)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func requestComposition(kind: MatchKind, category: MatchCategory) {
        guard !isSaving else { return }
        var dropsInput = false
        let newSides = sides.map { side in
            var remaining = side
            let result = (0..<kind.playersPerSide).map { position in
                let gender = category.gender(at: position)
                if let index = remaining.firstIndex(where: { $0.gender == gender }) {
                    return remaining.remove(at: index)
                }
                return MatchPlayerDraft(gender: gender)
            }
            dropsInput = dropsInput || remaining.contains(where: \.hasInput)
            return result
        }
        pendingComposition = (kind, category, newSides)
        if dropsInput { showsCompositionConfirmation = true } else { confirmComposition() }
    }
}
