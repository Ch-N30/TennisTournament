import Foundation

public protocol MatchRepository: Sendable {
    func loadMatches() async throws -> [StandaloneMatch]
    func create(_ match: StandaloneMatch) async throws -> StandaloneMatch
    func apply(_ action: MatchAction, to id: UUID, revision: Int) async throws -> StandaloneMatch
}

enum MatchStorageError: LocalizedError {
    case corrupt, read(String), write(String), conflict, notFound

    var errorDescription: String? {
        switch self {
        case .corrupt:
            "Файл матчей повреждён или имеет неподдерживаемую версию. Он не перезаписан. Сохраните его копию для восстановления."
        case .read(let reason): "Не удалось прочитать матчи: \(reason)"
        case .write(let reason): "Не удалось сохранить матч: \(reason). Изменение не применено. Повторите действие."
        case .conflict: "Матч уже изменён. Обновите данные перед следующим действием."
        case .notFound: "Матч не найден. Обновите список."
        }
    }
}

/// One live instance owns this file. Actor methods have no suspension points during read/modify/write.
public actor LocalMatchRepository: MatchRepository {
    private struct Archive: Codable {
        let version: Int
        var matches: [StandaloneMatch]
    }

    private let fileURL: URL
    private var hasSeenFile = false

    public init(fileURL: URL = URL.applicationSupportDirectory
        .appendingPathComponent("TennisTournament", isDirectory: true)
        .appendingPathComponent("matches-v1.json")) {
        self.fileURL = fileURL
    }

    public func loadMatches() throws -> [StandaloneMatch] {
        try readArchive().matches
    }

    public func create(_ match: StandaloneMatch) throws -> StandaloneMatch {
        var archive = try readArchive()
        try match.validateStoredState()
        if let existing = archive.matches.first(where: { $0.id == match.id }) {
            guard existing == match else { throw MatchStorageError.conflict }
            return existing
        }
        guard match.revision == 0, match.history.isEmpty else { throw MatchStorageError.conflict }
        archive.matches.append(match)
        try writeArchive(archive)
        return match
    }

    public func apply(_ action: MatchAction, to id: UUID, revision: Int) throws -> StandaloneMatch {
        var archive = try readArchive()
        guard let index = archive.matches.firstIndex(where: { $0.id == id }) else {
            throw MatchStorageError.notFound
        }
        guard archive.matches[index].revision == revision else { throw MatchStorageError.conflict }
        let updated = try archive.matches[index].applying(action)
        archive.matches[index] = updated
        try writeArchive(archive)
        return updated
    }

    private func readArchive() throws -> Archive {
        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
            hasSeenFile = true
        } catch {
            let cocoaError = error as NSError
            if cocoaError.domain == NSCocoaErrorDomain,
               cocoaError.code == NSFileReadNoSuchFileError, !hasSeenFile {
                return Archive(version: 1, matches: [])
            }
            throw MatchStorageError.read(error.localizedDescription)
        }
        do {
            let archive = try JSONDecoder().decode(Archive.self, from: data)
            guard archive.version == 1,
                  Set(archive.matches.map(\.id)).count == archive.matches.count else {
                throw MatchStorageError.corrupt
            }
            for match in archive.matches { try match.validateStoredState() }
            return archive
        } catch {
            throw MatchStorageError.corrupt
        }
    }

    private func writeArchive(_ archive: Archive) throws {
        do {
            let data = try JSONEncoder().encode(archive)
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true
            )
            try data.write(to: fileURL, options: .atomic)
            hasSeenFile = true
        } catch {
            throw MatchStorageError.write(error.localizedDescription)
        }
    }
}
