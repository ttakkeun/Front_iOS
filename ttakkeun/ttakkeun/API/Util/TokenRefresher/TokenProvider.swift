//
//  TokenProvider.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/21/24.
//

import Foundation
import Moya

class TokenProvider: TokenProviding {
    private let userSession = "ttakkeunUser"
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
            if keyChain.saveSession(userInfo, for: "ttakkeunUser") {
                print("유저 액세스 토큰 갱신됨")
            }
        }
    }
    
    var refreshToken: String? {
        get {
            guard let userInfo = keyChain.loadSession(for: userSession) else { return nil }
            return userInfo.refreshToken
        }
        
        set {
            guard var userInfo = keyChain.loadSession(for: userSession) else { return  }
            userInfo.refreshToken = newValue
            if keyChain.saveSession(userInfo, for: userSession) {
                print("유저 리프레시 토큰 갱신 됨")
            }
        }
    }
    
    func refreshToken(completion: @escaping (String?, (any Error)?) -> Void) {
        guard let userInfo = keyChain.loadSession(for: userSession), let refreshToken = userInfo.refreshToken else {
            let error = NSError(domain: "ttakkeun.com", code: -2, userInfo: [NSLocalizedDescriptionKey: "User session or refresh token not found"])
            completion(nil, error)
            return
        }
        
        provider.request(.sendRefreshToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                do {
                    let tokenData = try JSONDecoder().decode(ResponseData<TokenResponse>.self, from: response.data)
                    if tokenData.isSuccess {
                        self.accessToken = tokenData.result?.accessToken
                        self.refreshToken = tokenData.result?.refreshToken
                        completion(self.accessToken, nil)
                    } else {
                        let error = NSError(domain: "example.com", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token Refresh failed: isSuccess false"])
                        completion(nil, error)
                    }
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
