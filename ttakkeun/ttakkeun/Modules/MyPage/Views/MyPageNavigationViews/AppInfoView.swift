//
//  AppInfoView.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/27/24.
//

import SwiftUI

struct AppInfoView: View {
    
//    let btnInfoArray: [BtnInfo] = [BtnInfo(name: <#T##String#>, date: <#T##String?#>, action: <#T##() -> Void#>), BtnInfo(name: <#T##String#>, date: <#T##String?#>, action: <#T##() -> Void#>)]
    
    var body: some View {
        VStack(alignment: .center, spacing: 40, content: {
            CustomNavigation(action: { print("hello world") },
                             title: "이용약관 및 정책",
                             currentPage: nil
                             )
            
            infoBtns
            
            Spacer()
        })
    }
    
    //MARK: - Components
    /// Detail Info 볼 수 있는 버튼들
    private var infoBtns: some View {
        VStack(alignment: .center, spacing: 17, content: {
            //TODO: 버튼 액션 필요함
            
//            ForEach(btnInfoArray, id: \.id) { btnInfo in
//                Text(btnInfo.name)
//            }
            
            SelectBtnBox(title: "서비스 이용약관", action: {print("서비스 이용약관 버튼 눌림")})
            SelectBtnBox(title: "개인정보 수집 및 이용 동의서", action: {print("개인정보 수집 및 이용 동의서 버튼 눌림")})
            SelectBtnBox(title: "마케팅 정보 수신 동의서", action: {print("마케팅 정보 수신 동의서 버튼 눌림")})
        })
    }
    
}

//MARK: - Preview
struct AppInfoView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            AppInfoView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
