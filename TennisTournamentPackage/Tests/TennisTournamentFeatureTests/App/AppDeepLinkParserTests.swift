import Foundation
import Testing
@testable import TennisTournamentFeature

struct AppDeepLinkParserTests {
    private let parser = AppDeepLinkParser()
    private let tournamentID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

    @Test("Parses every supported deep link")
    func parsesSupportedDeepLinks() throws {
        let detailsURL = try #require(URL(string: "tennistournament://tournaments/\(tournamentID)"))
        let profileURL = try #require(URL(string: "tennistournament://tournaments/\(tournamentID)/profile"))
        let editorURL = try #require(URL(string: "tennistournament://tournaments/\(tournamentID)/edit"))
        let settingsURL = try #require(URL(string: "tennistournament://settings"))

        #expect(parser.parse(detailsURL) == .tournamentDetails(id: tournamentID))
        #expect(parser.parse(profileURL) == .tournamentProfile(id: tournamentID))
        #expect(parser.parse(editorURL) == .tournamentEditor(id: tournamentID))
        #expect(parser.parse(settingsURL) == .settings)
    }

    @Test("Rejects unsupported and malformed URLs")
    func rejectsInvalidDeepLinks() throws {
        let wrongScheme = try #require(URL(string: "https://tournaments/\(tournamentID)"))
        let missingID = try #require(URL(string: "tennistournament://tournaments"))
        let malformedID = try #require(URL(string: "tennistournament://tournaments/not-a-uuid"))
        let extraPath = try #require(URL(string: "tennistournament://settings/extra"))

        #expect(parser.parse(wrongScheme) == nil)
        #expect(parser.parse(missingID) == nil)
        #expect(parser.parse(malformedID) == nil)
        #expect(parser.parse(extraPath) == nil)
    }
}
