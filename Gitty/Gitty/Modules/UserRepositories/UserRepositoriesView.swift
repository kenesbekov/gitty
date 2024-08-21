import SwiftUI

struct UserRepositoriesView: View {
    @Environment(\.openURL) private var openURL
    @StateObject private var viewModel: UserRepositoriesViewModel

    init(with user: User) {
        _viewModel = StateObject(wrappedValue: UserRepositoriesViewModel(with: user))
    }

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                repositoryListView
            }
        }
        .navigationTitle("\(viewModel.user.login)'s Repos")
    }

    private var repositoryListView: some View {
        LazyVStack(spacing: 0) {
            ForEach(viewModel.repositories.indices, id: \.self) { index in
                RepositoryRowView(
                    repository: viewModel.repositories[index],
                    openURL: { url in openURL(url) },
                    markAsViewed: { viewModel.markAsViewed(at: index) }
                )
            }
        }
        .padding(.bottom, 20)
    }
}
