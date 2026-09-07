import SwiftUI

struct MatchScreen: View {
    @ObservedObject var viewModel: MatchViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                scoreBoard
                completedSets
                if viewModel.match.score.needsTieBreak { tieBreakForm }
                if let error = viewModel.errorMessage { errorPanel(error) }
                if viewModel.isSaving {
                    ProgressView("Сохраняем…")
                } else if viewModel.isLoading {
                    ProgressView("Обновляем…")
                }
                Button(action: viewModel.undo) {
                    Label("Отменить последнее действие", systemImage: "arrow.uturn.backward")
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.bordered)
                .disabled(!viewModel.canUndo)
                Text("Счёт сохраняется после каждого действия. Можно выйти и продолжить матч позже.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: 680)
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.match.isFinished ? "Результат матча" : "Матч")
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.reload() }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text(viewModel.match.categoryTitle).font(.subheadline).foregroundStyle(.secondary)
            Text(viewModel.match.configuration.format.title).font(.subheadline)
            if let winner = viewModel.match.score.winner {
                Label("Матч завершён", systemImage: "trophy.fill")
                    .font(.title2.bold()).foregroundStyle(.green)
                Text("Победитель: \(viewModel.match.sideName(winner))")
                    .font(.headline).multilineTextAlignment(.center)
            } else {
                Text("Сет \(viewModel.match.score.sets.count + 1)")
                    .font(.title2.bold())
            }
        }
    }

    private var scoreBoard: some View {
        VStack(spacing: 16) {
            Text(viewModel.match.isFinished ? "Последний сет" : "Геймы текущего сета")
                .font(.subheadline).foregroundStyle(.secondary)
            HStack(alignment: .top, spacing: 16) {
                sidePanel(.first, games: viewModel.match.score.games.first)
                Text(":").font(.largeTitle).padding(.top, 50).accessibilityHidden(true)
                sidePanel(.second, games: viewModel.match.score.games.second)
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 20))
    }

    private func sidePanel(_ side: MatchSide, games: Int) -> some View {
        VStack(spacing: 12) {
            Text("Сторона \(side.rawValue + 1)").font(.caption).foregroundStyle(.secondary)
            Text(games, format: .number)
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit().minimumScaleFactor(0.6).lineLimit(1)
                .accessibilityLabel("Сторона \(side.rawValue + 1), геймы: \(games)")
            Text(viewModel.match.sideName(side))
                .font(.headline).multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Button { viewModel.addGame(to: side) } label: {
                Label("Гейм", systemImage: "plus")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel("Гейм стороне \(side.rawValue + 1)")
            .disabled(!viewModel.canAddGame)
        }
        .frame(maxWidth: .infinity)
    }

    private var completedSets: some View {
        VStack(spacing: 8) {
            ForEach(Array(viewModel.match.score.sets.enumerated()), id: \.offset) { index, set in
                HStack {
                    Text("Сет \(index + 1)")
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(set.games.title).font(.headline).monospacedDigit()
                        if let points = set.tieBreak {
                            Text("Тай-брейк \(points.title)").font(.caption)
                        }
                    }
                }
            }
        }
    }

    private var tieBreakForm: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Тай-брейк при 6:6").font(.headline)
            Text("Введите итоговые очки. До 7 с разницей 2; при 6:6 — до преимущества в 2.")
                .font(.subheadline).foregroundStyle(.secondary)
            HStack {
                TextField("Сторона 1", text: $viewModel.tieBreakFirst)
                    .accessibilityLabel("Очки тай-брейка стороны 1")
                Text(":")
                TextField("Сторона 2", text: $viewModel.tieBreakSecond)
                    .accessibilityLabel("Очки тай-брейка стороны 2")
            }
            .keyboardType(.numberPad).textFieldStyle(.roundedBorder)
            Button("Сохранить тай-брейк", action: viewModel.submitTieBreak)
                .buttonStyle(.borderedProminent)
        }
        .disabled(viewModel.isBusy)
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
    }

    private func errorPanel(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(message).foregroundStyle(.red)
            if viewModel.canRetry {
                Button("Повторить сохранение", action: viewModel.retry)
            }
            Button("Обновить данные") { Task { await viewModel.reload() } }
        }
        .disabled(viewModel.isBusy)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
