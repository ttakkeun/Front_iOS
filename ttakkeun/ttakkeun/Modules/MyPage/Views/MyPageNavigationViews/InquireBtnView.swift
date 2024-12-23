//
//  InquireBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

/// 문의하기 분야 선택 뷰
struct InquireBtnView: View {
    
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: InquireViewModel
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 40, content: {
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "문의하기",
                             currentPage: nil)
            
            
            myInquire
            
            inquireBtns
            
            Spacer()
        })
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: NavigationDestination.self) { destination in
            NavigationRoutingView(destination: destination)
                .environmentObject(container)
        }
    }
    
    //MARK: - Components
    ///내가 문의한 내용 확인 버튼
    private var myInquire: some View {
        SelectBtnBox(btnInfo: BtnInfo(name: "내가 문의한 내용 확인하기", date: nil, action: {container.navigationRouter.push(to: .myInquire)}))
    }
    
    /// 서비스 문의 카테고리 볼 수 있는 버튼들
    private var inquireBtns: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            Text("카테고리")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)

            ForEach(makeBtnInfoArray(), id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: btnInfo)
            }
        })
    }
    
    private func makeBtnInfoArray() -> [BtnInfo] {
        return [
            BtnInfo(name: "서비스 이용 문의", date: nil, action: { container.navigationRouter.push(to: .writeInquire(selectedInquiryCategory: "서비스 이용 문의"))}),
            BtnInfo(name: "광고 문의", date: nil, action: { container.navigationRouter.push(to: .writeInquire(selectedInquiryCategory: "광고 문의"))}),
            BtnInfo(name: "제휴 문의", date: nil, action: { container.navigationRouter.push(to: .writeInquire(selectedInquiryCategory: "제휴 문의"))})
        ]
    }
    
}

//MARK: - Preview
struct InquireBtnView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            InquireBtnView(container: DIContainer())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}

