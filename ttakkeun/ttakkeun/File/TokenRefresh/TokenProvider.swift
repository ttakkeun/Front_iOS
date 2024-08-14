//
//  TokenProvider.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation
import Moya

class TokenProvider: TokenProviding {
    
    
    private let userSession = "userSession"
    private let keyChain = KeyChainManager.standard
    private let provider = MoyaProvider<AuthAPITarget>()
    
    var accessToken: String? {
        get {
            guard let userInfo = keyChain.loadSession(for: userSession) else { return nil }
            return userInfo.accessToken
        }
        
        set {
            guard var userInfo = keyChain.loadSession(for: userSession) else { return }
            userInfo.accessToken = newValue
            if keyChain.saveSession(userInfo, for: "userSession") {
                print("유저 액세스 토큰 갱신 됨")
            }
        }
    }
    
    var refreshToken: String? {
        get {
            guard let userInfo = keyChain.loadSession(for: userSession) else { return nil }
            return userInfo.refreshToken
        }
        
        set {
            guard var userInfo = keyChain.loadSession(for: userSession) else { return }
            userInfo.refreshToken = newValue
            if keyChain.saveSession(userInfo, for: "userSession") {
                print("유저 리프레시 토큰 갱신 됨")
            }
        }
    }
    
    /* 리프레시 토큰 전달하여 유저 정보 탐색 및 액세스 토큰 초기화 */
    func refreshToken(completion: @escaping (String?, Error?) -> Void) {
        
        guard let userInfo = keyChain.loadSession(for: "userSession"), let refreshToken = userInfo.refreshToken else {
            let error = NSError(domain: "example.com", code: -2, userInfo: [NSLocalizedDescriptionKey: "User session or refresh token not found"])
            completion(nil, error)
                return
            }
        
        provider.request(.refreshToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let tokenData = try JSONDecoder().decode(TokenResponse.self, from: response.data)
                    if tokenData.isSuccess {
                        self.accessToken = tokenData.result.accessToken
                        self.refreshToken = tokenData.result.refreshToken
                        completion(self.accessToken, nil)
                    } else {
                        let error = NSError(domain: "example.com", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token Refresh failed: isSuccess false"])
                        completion(nil, error)
                    }
                } catch {
                    print("리프레시 토큰 디코더 에러: \(error)")
                    completion(nil, error)
                }
            case .failure(let error):
                print("리프레시 토큰 네트워크 오류 : \(error)")
                completion(nil, error)
            }
        }
    }
    
}
