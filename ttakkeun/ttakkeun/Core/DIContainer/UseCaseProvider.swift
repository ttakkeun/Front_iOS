//
//  UserCaseProvider.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/28/24.
//

import Foundation

protocol UseCaseProtocol {
    var authUseCase: AuthUseCase { get set }
    var petProfileUseCase: PetProfileUseCase { get set }
}

class UseCaseProvider: UseCaseProtocol {
    
    var authUseCase: AuthUseCase
    var petProfileUseCase: PetProfileUseCase
    
    init() {
        self.authUseCase = AuthUseCase()
        self.petProfileUseCase = PetProfileUseCase()
    }
}
