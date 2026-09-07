import SwiftUI

public struct TournamentEditorScreen: View {
    private let onSave: (String, String) -> Void
    private let onCancel: () -> Void

    @State private var name: String
    @State private var format: String

    public init(
        tournament: TournamentSummary,
        onSave: @escaping (String, String) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.onSave = onSave
        self.onCancel = onCancel
        _name = State(initialValue: tournament.name)
        _format = State(initialValue: tournament.format)
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedFormat: String {
        format.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedName.isEmpty && !trimmedFormat.isEmpty
    }

    public var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                TextField("Format", text: $format)
            }
            .navigationTitle("Edit tournament")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(trimmedName, trimmedFormat)
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
