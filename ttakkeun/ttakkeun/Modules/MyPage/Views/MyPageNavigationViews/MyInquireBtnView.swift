//
//  MyInquireBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/16/24.
//

import SwiftUI

/// 내가 문의한 내용 보기
struct MyInquireBtnView: View {
    
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: MyPageViewModel
    
    let btnInfoArray: [BtnInfo] = [
        //TODO: 버튼 액션 필요함
        BtnInfo(name: "이 사람 이상해요.", date: "24.09.20", action: {print("내가 문의한 내용 버튼1")}),
        BtnInfo(name: "앱 회원가입이 안되는데 어떻게 해야하나요?", date: "24.06.20", action: {print("내가 문의한 내용 버튼2")})
    ]
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 40, content: {
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "문의하기",
                             currentPage: nil)
            
            inquireBtns
            
            Spacer()
        })
        .navigationBarBackButtonHidden(true)
    }
    
    //MARK: - Components
    /// 내가 문의한 내용들 볼 수 있는 버튼들
    private var inquireBtns: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            Text("내가 문의한 내용 확인하기")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)

            ForEach(btnInfoArray, id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: btnInfo)
            }
        })
    }
    
}

//MARK: - Preview
struct MyInquireBtnView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            MyInquireBtnView(container: DIContainer())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}

