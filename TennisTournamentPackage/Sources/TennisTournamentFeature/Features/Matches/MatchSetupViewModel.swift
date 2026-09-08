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
    private struct PendingComposition {
        let kind: MatchKind
        let category: MatchCategory
        let sides: [[MatchPlayerDraft]]
    }

    @Published private(set) var kind: MatchKind = .singles
    @Published private(set) var category: MatchCategory = .men
    @Published var format: MatchFormat = .oneSet
    @Published private(set) var sides = [[MatchPlayerDraft(gender: .male)], [MatchPlayerDraft(gender: .male)]]
    @Published private(set) var isSaving = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var hasStarted = false
    @Published var showsCompositionConfirmation = false

    private var pendingComposition: PendingComposition?
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
        guard let pendingComposition else { return }
        kind = pendingComposition.kind
        category = pendingComposition.category
        sides = pendingComposition.sides
        self.pendingComposition = nil
        showsCompositionConfirmation = false
        errorMessage = nil
    }

    func cancelComposition() {
        pendingComposition = nil
        showsCompositionConfirmation = false
    }

    func player(id: UUID) -> MatchPlayerDraft? {
        sides.flatMap { $0 }.first { $0.id == id }
    }

    func updatePlayer(id: UUID, name: String? = nil, surname: String? = nil) {
        guard !isSaving, let (side, position) = location(of: id),
              sides[side][position].profileID == nil else { return }
        if let name { sides[side][position].name = name }
        if let surname { sides[side][position].surname = surname }
    }

    func canAddProfile(_ profile: UserProfile, playerID: UUID) -> Bool {
        guard let player = player(id: playerID) else { return false }
        return !player.hasInput && player.gender == profile.gender &&
            !sides.flatMap({ $0 }).contains(where: { $0.profileID == profile.id })
    }

    func addProfile(_ profile: UserProfile, playerID: UUID) {
        guard !isSaving, canAddProfile(profile, playerID: playerID),
              let (side, position) = location(of: playerID) else { return }
        sides[side][position].name = profile.name
        sides[side][position].surname = profile.surname
        sides[side][position].profileID = profile.id
    }

    func clearPlayer(id: UUID) {
        guard !isSaving, let (side, position) = location(of: id) else { return }
        sides[side][position] = MatchPlayerDraft(gender: category.gender(at: position))
    }

    private func location(of id: UUID) -> (Int, Int)? {
        for side in sides.indices {
            if let position = sides[side].firstIndex(where: { $0.id == id }) { return (side, position) }
        }
        return nil
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
                let filledIndex = remaining.firstIndex { $0.gender == gender && $0.hasInput }
                if let index = filledIndex ?? remaining.firstIndex(where: { $0.gender == gender }) {
                    return remaining.remove(at: index)
                }
                return MatchPlayerDraft(gender: gender)
            }
            dropsInput = dropsInput || remaining.contains(where: \.hasInput)
            return result
        }
        pendingComposition = PendingComposition(kind: kind, category: category, sides: newSides)
        if dropsInput { showsCompositionConfirmation = true } else { confirmComposition() }
    }
}
