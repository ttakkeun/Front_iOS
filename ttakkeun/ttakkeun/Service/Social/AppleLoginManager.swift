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
    
    public func signWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("credential 형변환 실패")
            return
        }
        
        let formatter = PersonNameComponentsFormatter()
        let fullName = credential.fullName.flatMap { formatter.string(from: $0) }
        
        guard
            let identityTokenData = credential.identityToken,
            let identityToken = String(data: identityTokenData, encoding: .utf8)
        else {
            print("identityToken 변환 실패")
            return
        }
        
        let email = credential.email
        self.onAuthorizationCompleted?(identityToken, email, fullName)
        
        #if DEBUG
        print("Apple 로그인 성공")
        print("토큰: \(identityToken)")
        print("이메일: \(email ?? "없음")")
        print("이름: \(fullName ?? "없음")")
        #endif
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 실패: \(error.localizedDescription)")
    }
}
