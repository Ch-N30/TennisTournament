import SwiftUI

struct MatchesHomeScreen: View {
    @ObservedObject var viewModel: MatchesListViewModel
    let onCreate: () -> Void
    let onSelect: (StandaloneMatch) -> Void

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.matches.isEmpty {
                ProgressView("Загружаем матчи…")
            } else if viewModel.matches.isEmpty, viewModel.errorMessage == nil {
                ContentUnavailableView {
                    Label("Пока нет матчей", systemImage: "sportscourt")
                } description: {
                    Text("Создайте матч и записывайте выигранные геймы.")
                } actions: {
                    Button("Создать матч", action: onCreate).buttonStyle(.borderedProminent)
                }
            } else {
                List {
                    if let error = viewModel.errorMessage {
                        Section {
                            Text(error).foregroundStyle(.red)
                            Button("Обновить список") { Task { await viewModel.load() } }
                        }
                    }
                    matchSection("В процессе", matches: viewModel.matches.filter { !$0.isFinished })
                    matchSection("Завершённые", matches: viewModel.matches.filter(\.isFinished))
                }
                .refreshable { await viewModel.load() }
            }
        }
        .navigationTitle("Матчи")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onCreate) { Image(systemName: "plus") }
                    .accessibilityLabel("Создать матч")
            }
        }
        .task { await viewModel.load() }
        .alert("Удалить матч?", isPresented: Binding(
            get: { viewModel.pendingDeletion != nil },
            set: { if !$0 { viewModel.pendingDeletion = nil } }
        ), presenting: viewModel.pendingDeletion) { match in
            Button("Отмена", role: .cancel) { viewModel.pendingDeletion = nil }
            Button("Удалить", role: .destructive) { viewModel.confirmDeletion(match) }
        } message: { match in
            Text("\(match.sideName(.first)) против \(match.sideName(.second)). " +
                 "Матч и вся история счёта будут удалены без возможности восстановления.")
        }
    }

    @ViewBuilder
    private func matchSection(_ title: String, matches: [StandaloneMatch]) -> some View {
        if !matches.isEmpty {
            Section(title) {
                ForEach(matches) { match in
                    Button { onSelect(match) } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                if viewModel.deletingID == match.id { ProgressView() }
                                Text(match.statusTitle).font(.caption.bold())
                                    .foregroundStyle(match.isFinished ? Color.secondary : Color.green)
                                Spacer()
                                Text(match.createdAt, format: .dateTime.day().month().year())
                                    .font(.caption).foregroundStyle(.secondary)
                                Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
                            }
                            Text(match.sideName(.first)).font(.headline)
                            Text("против \(match.sideName(.second))").font(.subheadline)
                            Text(match.categoryTitle).font(.caption).foregroundStyle(.secondary)
                            Text(match.scoreTitle).font(.headline).monospacedDigit()
                        }
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button { viewModel.requestDeletion(match) } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                    .disabled(viewModel.isLoading || viewModel.deletingID != nil)
                }
            }
        }
    }
}
