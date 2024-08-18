//
//  AppleLoginManager.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/10/24.
//

import Foundation
import AuthenticationServices

class AppleLoginManager: NSObject {
    var onAuthorizationCompleted: ((String, String?) -> Void)?
    
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
            let workItem = DispatchWorkItem {
                let fullName = appleIDCredential.fullName.flatMap { nameComponents in
                    [nameComponents.givenName, nameComponents.familyName]
                        .compactMap { $0 }
                        .joined(separator: " ")
                }
                
                let userData = AppleUserData(
                    userIdentifier: appleIDCredential.user,
                    fullName: fullName ?? "",
                    email: appleIDCredential.email ?? "",
                    authorizationCode: String(data: appleIDCredential.authorizationCode ?? Data(), encoding: .utf8),
                    identityToken: String(data: appleIDCredential.identityToken ?? Data(), encoding: .utf8)
                )
                
                if let authorizationCode = userData.identityToken {
                    self.onAuthorizationCompleted?(authorizationCode, userData.email)
                    print("유저 인가 코드: \(authorizationCode)")
                }
            }   
            DispatchQueue.main.async(execute: workItem)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 실패: \(error.localizedDescription)")
    }
}
