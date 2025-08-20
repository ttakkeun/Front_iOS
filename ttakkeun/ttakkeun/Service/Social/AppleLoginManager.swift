import AuthenticationServices
import UIKit

final class AppleLoginManager: NSObject {

    enum Flow { case login, accountDeletion }

    private var flow: Flow?

    var onAuthorizationCompleted: ((String, String?, String?) -> Void)?
    var onAccountDeleteAuthorized: ((String) -> Void)?

    public func signWithApple() {
        flow = .login
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    public func accountDelete() {
        flow = .accountDeletion
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = []

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        defer { flow = nil }

        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("Apple 인증 실패: credential 형변환 실패")
            return
        }

        switch flow {
        case .login:
            guard let tokenData = credential.identityToken,
                  let identityToken = String(data: tokenData, encoding: .utf8) else {
                print("identityToken 없음")
                return
            }

            let formatter = PersonNameComponentsFormatter()
            let fullName = credential.fullName.flatMap { formatter.string(from: $0) }
            let email = credential.email

            onAuthorizationCompleted?(identityToken, email, fullName)

            #if DEBUG
            print("Apple 로그인 성공")
            print("토큰: \(identityToken)")
            print("이메일: \(email ?? "없음")")
            print("이름: \(fullName ?? "없음")")
            #endif

        case .accountDeletion:
            guard let codeData = credential.authorizationCode,
                  let code = String(data: codeData, encoding: .utf8) else {
                print("authorizationCode 없음")
                return
            }

            onAccountDeleteAuthorized?(code)

            #if DEBUG
            print("Apple 회원탈퇴용 인증 성공")
            print("authorizationCode: \(code)")
            #endif

        case .none:
            print("경고: flow 미설정 상태에서 응답 수신")
        }
    }

    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: Error) {
        defer { flow = nil }
        print("Apple 인증 실패: \(error.localizedDescription)")
    }
}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
