import Foundation

extension DependencyContainer {
    func registerAuthorizationServices() {
        register(AccessTokenProviderImpl(), forType: AccessTokenProvider.self)
        register(AuthorizationURLProviderImpl(), forType: AuthorizationURLProvider.self)
        register(OAuthHandlerImpl(), forType: OAuthHandler.self)
        register(TokenValidatorImpl(), forType: TokenValidator.self)
    }
}
