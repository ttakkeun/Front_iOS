//
//  AgreementViewModel.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/13/24.
//

import SwiftUI
import Combine

class AgreementViewModel: ObservableObject {
    @Published var agreements: [AgreementData] = []
    @Published var selectedAgreement: AgreementData?
    
    init() {
        loadAgreements()
    }
    
    // 모든 항목이 체크되었는지 확인
    var isAllChecked: Bool {
        agreements.allSatisfy { $0.isChecked }
    }
    
    // 필수 항목들이 모두 체크되었는지 확인
    var isAllMandatoryChecked: Bool {
        agreements.filter { $0.isMandatory }.allSatisfy { $0.isChecked }
    }
    
    func toggleCheck(for item: AgreementData) {
        if let index = agreements.firstIndex(where: { $0.id == item.id }) {
            agreements[index].isChecked.toggle()
        }
    }
    
    func toggleAllAgreements() {
        let newValue = !isAllChecked
        for index in agreements.indices {
            agreements[index].isChecked = newValue
        }
    }
    
    private func loadAgreements() {
        agreements = [
            AgreementData(title: "서비스 이용 약관 동의 (필수)", isMandatory: true, detailText: "서비스 이용에 대한 약관 내용..."),
            AgreementData(title: "개인정보 수집 및 이용 동의 (필수)", isMandatory: true, detailText: "개인정보 수집 및 이용에 대한 약관 내용..."),
            AgreementData(title: "마케팅 정보 수신 동의 (선택)", isMandatory: false, detailText: "마케팅 정보 수신에 대한 약관 내용...")
        ]
    }
}
