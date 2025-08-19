//
//  AppleLoginManager.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import Foundation
import AuthenticationServices

class AppleLoginManager: NSObject {
    var onAuthorizationCompleted: ((String, String?, String?) -> Void)?
    var onAccountDeleteAuthorized: ((String) -> Void)?
    
    public func signWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    public func accountDelete() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = []
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("Apple 인증 실패: credential 형변환 실패")
            return
        }
        
        // 로그인 플로우 (identityToken, email, fullName)
        if let identityTokenData = credential.identityToken,
           let identityToken = String(data: identityTokenData, encoding: .utf8) {
            
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
        }
        
        // 회원 탈퇴 플로우 (authorizationCode만 필요)
        if let authorizationCodeData = credential.authorizationCode,
           let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) {
            
            onAccountDeleteAuthorized?(authorizationCode)
            
            #if DEBUG
            print("Apple 회원탈퇴용 인증 성공")
            print("authorizationCode: \(authorizationCode)")
            #endif
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 인증 실패: \(error.localizedDescription)")
    }
}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
