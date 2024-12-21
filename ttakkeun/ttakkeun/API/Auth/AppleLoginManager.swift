//
//  AppleLoginManager.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import Foundation
import AuthenticationServices

class AppleLoginManager: NSObject {
    var onAuthorizationCompleted: ((String, String?, String) -> Void)?
    
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
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            DispatchQueue.main.async {
                let fullName =  appleIDCredential.fullName.flatMap { nameComponents in
                    [nameComponents.familyName, nameComponents.givenName]
                        .compactMap{ $0 }
                        .joined(separator: "")
                }
                
                let appleUserData = AppleUserData(
                    userIdentifier: appleIDCredential.user,
                    fullName: fullName ?? "",
                    email: appleIDCredential.email ?? "",
                    authorizationCode: String(data: appleIDCredential.authorizationCode ?? Data(), encoding: .utf8),
                    identityToken: String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8)
                )
                
                if let identityCode = appleUserData.identityToken {
                    self.onAuthorizationCompleted?(identityCode, appleUserData.email, appleUserData.fullName)
                    print("유저 인가 코드: \(identityCode)")
                    print("유저 이메일 : \(appleUserData.email ?? "")")
                    print("유저 이름 : \(appleUserData.fullName)")
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 실패: \(error.localizedDescription)")
    }
}
