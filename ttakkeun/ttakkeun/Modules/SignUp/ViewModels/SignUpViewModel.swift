//
//  SignUpViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/30/24.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var agreements: [AgreementData] = AgreementDetailData.loadAgreements()
    @Published var selectedAgreement: AgreementData?
    
    public func toggleCheck(for item: AgreementData) {
        if let index = agreements.firstIndex(where: { $0.id == item.id }) {
            agreements[index].isChecked.toggle()
        }
    }
    
    public func toggleAllAgreements() {
        let newValue = !isAllChecked
        for index in agreements.indices {
            agreements[index].isChecked = newValue
        }
    }
    
    var isAllChecked: Bool {
        agreements.allSatisfy { $0.isChecked }
    }
    
    var isAllMandatoryChecked: Bool {
        agreements.filter { $0.isMandatory }.allSatisfy { $0.isChecked }
    }
}
