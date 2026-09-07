import SwiftUI

struct MatchSetupScreen: View {
    @ObservedObject var viewModel: MatchSetupViewModel
    let profile: UserProfile

    var body: some View {
        Form {
            Section("Формат матча") {
                Picker("Состав", selection: Binding(
                    get: { viewModel.kind }, set: { viewModel.requestKind($0) }
                )) {
                    ForEach(MatchKind.allCases, id: \.self) { Text($0.title).tag($0) }
                }
                Picker("Категория", selection: Binding(
                    get: { viewModel.category }, set: { viewModel.requestCategory($0) }
                )) {
                    ForEach(viewModel.categories, id: \.self) { Text($0.title).tag($0) }
                }
                Picker("Продолжительность", selection: $viewModel.format) {
                    ForEach(MatchFormat.allCases, id: \.self) { Text($0.title).tag($0) }
                }
            }
            ForEach(0..<2, id: \.self) { side in
                Section("Сторона \(side + 1)") {
                    ForEach(viewModel.sides[side]) { player in
                        playerFields(player)
                    }
                }
            }
            Section {
                Text("Записывайте выигранные геймы, без очков 15–30–40. При 6:6 введите итог тай-брейка.")
                    .font(.footnote).foregroundStyle(.secondary)
                Text("После старта состав и правила нельзя изменить. Участие владельца профиля необязательно.")
                    .font(.footnote).foregroundStyle(.secondary)
                if let error = viewModel.errorMessage {
                    Text(error).foregroundStyle(.red)
                }
                Button(action: viewModel.start) {
                    HStack {
                        if viewModel.isSaving { ProgressView() }
                        Text(viewModel.isSaving ? "Сохраняем матч…" : "Начать матч")
                        Spacer()
                        Image(systemName: "play.fill")
                    }
                }
                .disabled(viewModel.hasStarted)
            }
        }
        .disabled(viewModel.isSaving)
        .navigationTitle("Новый матч")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(viewModel.isSaving)
        .alert("Изменить состав?", isPresented: $viewModel.showsCompositionConfirmation) {
            Button("Отмена", role: .cancel, action: viewModel.cancelComposition)
            Button("Изменить", role: .destructive, action: viewModel.confirmComposition)
        } message: {
            Text("Несовместимые с новым составом или категорией заполненные места будут удалены. Остальные сохранятся.")
        }
    }

    private func playerFields(_ player: MatchPlayerDraft) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(player.gender == .male ? "Мужчина" : "Женщина")
                .font(.subheadline).foregroundStyle(.secondary)
            TextField("Имя", text: Binding(
                get: { viewModel.player(id: player.id)?.name ?? "" },
                set: { viewModel.updatePlayer(id: player.id, name: $0) }
            ))
                .textContentType(.givenName)
                .disabled(player.profileID != nil)
            TextField("Фамилия", text: Binding(
                get: { viewModel.player(id: player.id)?.surname ?? "" },
                set: { viewModel.updatePlayer(id: player.id, surname: $0) }
            ))
                .textContentType(.familyName)
                .disabled(player.profileID != nil)
            if player.hasInput {
                Button(player.profileID == nil ? "Очистить игрока" : "Убрать меня", role: .destructive) {
                    viewModel.clearPlayer(id: player.id)
                }
            } else {
                Button("Добавить меня") { viewModel.addProfile(profile, playerID: player.id) }
                    .disabled(!viewModel.canAddProfile(profile, playerID: player.id))
            }
        }
        .padding(.vertical, 4)
    }
}
