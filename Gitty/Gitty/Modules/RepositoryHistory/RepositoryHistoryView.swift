import SwiftUI

struct RepositoryHistoryView: View {
    @Injected private var cleaner: RepositoryHistoryCleaner
    @Injected private var provider: RepositoryHistoryProvider

    @Environment(\.openURL) private var openURL
    @State private var showAlert = false
    @State private var repositories: [Repository]

    init() {
        @Injected var provider: RepositoryHistoryProvider
        self.repositories = provider.repositories
    }

    var body: some View {
        ZStack {
            if repositories.isEmpty {
                emptyStateView
            } else {
                repositoryListView
            }
        }
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAlert = true
                } label: {
                    Text("Clear")
                }
                .disabled(repositories.isEmpty)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Clear History"),
                message: Text("Are you sure you want to clear the history?"),
                primaryButton: .destructive(Text("Clear")) {
                    clearHistory()
                },
                secondaryButton: .cancel()
            )
        }
        .animation(.easeInOut, value: repositories)
    }

    private func clearHistory() {
        repositories.removeAll()
        cleaner.clear()
        provideSuccessHapticFeedback()
    }

    private func provideSuccessHapticFeedback() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        feedbackGenerator.notificationOccurred(.success)
    }

    private var emptyStateView: some View {
        VStack {
            Image(systemName: "clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
                .padding()

            Text("No viewed repos")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        }
    }

    private var repositoryListView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(repositories) { repository in
                    RepositoriesRowView(
                        repository: repository,
                        openURL: { url in openURL(url) },
                        markAsViewed: {
                            provider.add(repository)
                            repositories = provider.repositories
                        },
                        showViewedIndicator: false
                    )
                }
            }
            .padding(.bottom, 20)
        }
    }
}
