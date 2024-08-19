import Foundation

final class AccessTokenProviderImpl: AccessTokenProvider {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func get(for authorizationCode: String) async throws {
        let endpoint = "/login/oauth/access_token"
        let bodyComponents = [
            "client_id": Constants.clientID,
            "client_secret": Constants.clientSecret,
            "code": authorizationCode,
            "redirect_uri": Constants.redirectURI
        ]

        guard let body = createBody(from: bodyComponents) else {
            throw URLError(.cannotParseResponse)
        }

        let headers = ["Content-Type": "application/x-www-form-urlencoded"]

        do {
            let response: OAuthTokenResponse = try await networkClient.request(
                endpoint,
                method: .post,
                body: body,
                headers: headers,
                isOAuthRequest: true
            )
            try KeychainService.shared.saveToken(response.accessToken)
        } catch let KeychainError.keychainError(status: status) {
            print("Failed to fetch access token: \(status)")
        }
    }

    private func createBody(from components: [String: String]) -> Data? {
        let bodyString = components
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")

        return bodyString.data(using: .utf8)
    }
}
