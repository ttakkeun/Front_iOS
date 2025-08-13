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
            ForEach(btnInfoArray, id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: btnInfo)
            }
        })
        .navigationBarBackButtonHidden(true)
        .customNavigation(title: PrivacyAndPoliciesConstants.navigationTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: PrivacyAndPoliciesConstants.navigationIcon))
    }
    
    // MARK: - TopContents
    /// 앱 이용정보 관련 처리 버튼 모음
    private var btnInfoArray: [BtnInfo] {
        AppInfoType.allCases.map { category in
            BtnInfo(name: category.title, date: nil, action: {
                container.navigationRouter.push(to: .appInfo(.privacyDetail(selectedAgreementData: category.param)))
            })
        }
    }
}

#Preview {
    PrivacyAndPoliciesView()
        .environmentObject(DIContainer())
}
