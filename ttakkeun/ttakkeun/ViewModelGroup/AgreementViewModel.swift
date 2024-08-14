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
    
    //MARK: - INIT
    init() {
        loadAgreements()
    }
    
    //MARK: - Variable
    /// 모든 항목이 체크되었는지 확인
    var isAllChecked: Bool {
        agreements.allSatisfy { $0.isChecked }
    }
    
    /// 필수 항목들이 모두 체크되었는지 확인
    var isAllMandatoryChecked: Bool {
        agreements.filter { $0.isMandatory }.allSatisfy { $0.isChecked }
    }
    
    //MARK: - Function
    /// 특정 동의 항목의 체크 상태를 토글하는 함수
    func toggleCheck(for item: AgreementData) {
        if let index = agreements.firstIndex(where: { $0.id == item.id }) {
            agreements[index].isChecked.toggle()
        }
    }
    
    /// 모든 동의 항목의 체크 상태를 토글하는 함수
    func toggleAllAgreements() {
        /// 현재 모든 항목이 체크되었는지 여부에 따라 새로운 값을 설정
        let newValue = !isAllChecked
        for index in agreements.indices {
            agreements[index].isChecked = newValue
        }
    }
    
    /// 동의 항목 데이터를 로드하는 함수
    private func loadAgreements() {
        agreements = AgreementDetailData.loadAgreements()
    }
}
