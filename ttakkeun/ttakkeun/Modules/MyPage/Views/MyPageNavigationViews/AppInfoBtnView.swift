//
//  AppInfoBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/27/24.
//

import SwiftUI

/// 앱 이용정보 분야 선택뷰
struct AppInfoBtnView: View {
    
    @EnvironmentObject var container: DIContainer
    
    var btnInfoArray: [BtnInfo] {
        return [
            //TODO: 버튼 액션 필요함
            BtnInfo(name: "서비스 이용 약관", date: nil, action: {container.navigationRouter.push(to: .agreementData(selectedAgreementData: AgreementDetailData.loadAgreements()[0]))}),
            BtnInfo(name: "개인정보 수집 및 이용 동의서", date: nil, action: {container.navigationRouter.push(to: .agreementData(selectedAgreementData: AgreementDetailData.loadAgreements()[1]))}),
            BtnInfo(name: "마케팅 정보 수신 동의서", date: nil, action: {container.navigationRouter.push(to: .agreementData(selectedAgreementData: AgreementDetailData.loadAgreements()[2]))})
        ]
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 40, content: {
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "이용약관 및 정책",
                             currentPage: nil)
            infoBtns
            Spacer()
        })
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: NavigationDestination.self) { destination in
            NavigationRoutingView(destination: destination)
                .environmentObject(container)
        }
    }
    
    //MARK: - Components
    /// Detail Info 볼 수 있는 버튼들
    private var infoBtns: some View {
        VStack(alignment: .center, spacing: 17, content: {
            ForEach(btnInfoArray, id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: btnInfo)
            }
        })
    }
    
}

//MARK: - Preview
struct AppInfoBtnView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            AppInfoBtnView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}
