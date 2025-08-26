//
//  MyInquireBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/16/24.
//
import SwiftUI

/// 내가 문의한 내용 목록 보기 뷰
struct MyInquireView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: InquireViewModel
    
    // MARK: - Constants
    fileprivate enum MyInquireCostants {
        static let contentsVspacing: CGFloat = 19
        static let btnVspacing: CGFloat = 17
        static let cornerRadius: CGFloat = 10
        static let rectangleHeight: CGFloat = 100
        static let naviTitle: String = "내 문의 내용"
        static let naviClose: String = "chevron.left"
        static let topTitle: String = "내가 문의한 내용 확인하기"
        static let noInquireText: String = "문의한 내용이 없습니다."
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: MyInquireCostants.contentsVspacing, content: {
            topTitle
            inquireBranch
            Spacer()
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaPadding(.top, UIConstants.topScrollPadding)
        .customNavigation(title: MyInquireCostants.naviTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: MyInquireCostants.naviClose))
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
        .task {
            viewModel.getMyInquire()
        }
    }
    
    //MARK: - Components
    /// 상단 버튼 타이틀
    private var topTitle: some View {
        Text(MyInquireCostants.topTitle)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    /// 문의 사항 버튼 분기처리
    @ViewBuilder
    private var inquireBranch: some View {
        if !viewModel.myInquiryData.isEmpty {
            inquireBtns
        } else {
            noInquireBtns
        }
    }
    /// 내가 문의한 내용들 볼 수 있는 버튼들
    private var inquireBtns: some View {
        VStack(alignment: .leading, spacing: MyInquireCostants.btnVspacing, content: {
            ForEach(viewModel.myInquiryData, id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: .init(name: btnInfo.contents, date: btnInfo.createdAt.formattedDateString, action: {
                    container.navigationRouter.push(to: .inquire(.myInquiryConfirm(selectedInquiryData: btnInfo)))
                }))
            }
        })
    }
    
    /// 문의한 내용 없을 시, 가이드 문구
    private var noInquireBtns: some View {
        ZStack {
            RoundedRectangle(cornerRadius: MyInquireCostants.cornerRadius)
                .fill(Color.clear)
                .stroke(Color.gray500, style: .init())
                .frame(height: MyInquireCostants.rectangleHeight)
            
            Text(MyInquireCostants.noInquireText)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
        }
    }
}

#Preview {
    MyInquireView(container: DIContainer())
        .environmentObject(DIContainer())
}
