//
//  AppInfoBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/27/24.
//

import SwiftUI

/// 앱 이용정보 분야 선택뷰
struct PrivacyAndPoliciesView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    
    // MARK: - Constant
    fileprivate enum PrivacyAndPoliciesConstants {
        static let contentsVspacing: CGFloat = 17
        static let navigationTitle: String = "이용약관 및 정책"
        static let navigationIcon: String = "xmark"
        
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: PrivacyAndPoliciesConstants.contentsVspacing, content: {
        })
        .navigationBarBackButtonHidden(true)
        .customNavigation(title: PrivacyAndPoliciesConstants.navigationTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: PrivacyAndPoliciesConstants.navigationIcon))
    }
    
    // MARK: - TopContents
    
    
    private var infoBtns: some View {
        VStack(alignment: .center, spacing: 17, content: {
            ForEach(btnInfoArray(), id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: btnInfo)
            }
        })
    }
    
    private func btnInfoArray() -> [BtnInfo] {
        return [
            BtnInfo(name: "서비스 이용 약관", date: nil, action: {container.navigationRouter.push(to: .agreementData(selectedAgreementData: AgreementDetailData.loadAgreements()[0]))}),
            BtnInfo(name: "개인정보 수집 및 이용 동의서", date: nil, action: {container.navigationRouter.push(to: .agreementData(selectedAgreementData: AgreementDetailData.loadAgreements()[1]))}),
            BtnInfo(name: "마케팅 정보 수신 동의서", date: nil, action: {container.navigationRouter.push(to: .agreementData(selectedAgreementData: AgreementDetailData.loadAgreements()[2]))})
        ]
    }
}
