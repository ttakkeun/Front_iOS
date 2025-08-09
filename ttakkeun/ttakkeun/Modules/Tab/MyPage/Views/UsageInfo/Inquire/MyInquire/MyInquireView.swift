//
//  MyInquireBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/16/24.
//
import SwiftUI

/// 내가 문의한 내용 보기 뷰
struct MyInquireView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: InquireViewModel
    
    // MARK: - Constants
    fileprivate enum MyInquireCostants {
        static let contentsVspacing: CGFloat = 19
        static let btnVspacing: CGFloat = 17
        static let naviTitle: String = "내 문의 내용"
        static let naviClose: String = "xmark"
        static let topTitle: String = "내가 문의한 내용 확인하기"
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: MyInquireCostants.contentsVspacing, content: {
            inquireBtns
            Spacer()
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .customNavigation(title: MyInquireCostants.naviTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: MyInquireCostants.naviClose))
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
//        .task {
//            viewModel.getMyInquire()
//        }
    }
    
    //MARK: - Components
    /// 내가 문의한 내용들 볼 수 있는 버튼들
    private var inquireBtns: some View {
        VStack(alignment: .leading, spacing: MyInquireCostants.btnVspacing, content: {
            Text(MyInquireCostants.topTitle)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)

            ForEach(viewModel.myInquiryData, id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: .init(name: btnInfo.contents, date: btnInfo.created_at.convertedToKoreanTimeDateString(), action: {
                    container.navigationRouter.push(to: .myInquiryConfirm(selectedInquiryData: btnInfo))
                }))
            }
        })
    }
}

#Preview {
    MyInquireView(container: DIContainer())
        .environmentObject(DIContainer())
}
