//
//  UserCaseProvider.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/28/24.
//

import Foundation

protocol UseCaseProtocol {
    var authUseCase: AuthUseCase { get set }
}

class UseCaseProvider: UseCaseProtocol {
    
     var authUseCase: AuthUseCase
    
    init() {
        self.authUseCase = AuthUseCase()
    }
}
