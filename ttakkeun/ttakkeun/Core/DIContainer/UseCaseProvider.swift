//
//  UserCaseProvider.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/28/24.
//

import Foundation

protocol UseCaseProtocol {
    var authUseCase: AuthUseCase { get set }
    var diagnoseUseCase: DiagnoseUseCase { get set }
    var myPageUseCase: MyPageUseCase { get set }
    var petProfileUseCase: PetProfileUseCase { get set }
    var productUseCase: ProductUseCase { get set }
    var recordUseCase: RecordUseCase { get set }
    var tipUseCase: TipUseCase { get set }
    var todoUseCase: TodoUseCase { get set }
}

class UseCaseProvider: UseCaseProtocol {
    var authUseCase: AuthUseCase
    var diagnoseUseCase: DiagnoseUseCase
    var myPageUseCase: MyPageUseCase
    var petProfileUseCase: PetProfileUseCase
    var productUseCase: ProductUseCase
    var recordUseCase: RecordUseCase
    var tipUseCase: TipUseCase
    var todoUseCase: TodoUseCase
    
    init() {
        self.authUseCase = AuthUseCase()
        self.diagnoseUseCase = DiagnoseUseCase()
        self.myPageUseCase = MyPageUseCase()
        self.petProfileUseCase = PetProfileUseCase()
        self.productUseCase = ProductUseCase()
        self.recordUseCase = RecordUseCase()
        self.tipUseCase = TipUseCase()
        self.todoUseCase = TodoUseCase()
    }
}
