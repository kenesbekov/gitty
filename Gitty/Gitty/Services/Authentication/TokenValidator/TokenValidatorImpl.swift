import Foundation

final class TokenValidatorImpl: TokenValidator {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func validate(_ token: String) async throws -> Bool {
        let endpoint = "/user"
        let headers = ["Authorization": "token \(token)"]

        do {
            let _: UserProfile = try await networkClient.request(
                endpoint,
                method: .get,
                body: nil,
                headers: headers,
                isOAuthRequest: false
            )
            return true
        } catch {
            return false
        }
    }
}
