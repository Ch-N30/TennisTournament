import SwiftUI

public struct SettingsScreen: View {
    private let onDismiss: () -> Void

    public init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Navigation") {
                    LabeledContent("Provider", value: "PRNDSwift")
                    LabeledContent("Version", value: "0.1.0-alpha.1")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: onDismiss)
                }
            }
        }
    }
}
