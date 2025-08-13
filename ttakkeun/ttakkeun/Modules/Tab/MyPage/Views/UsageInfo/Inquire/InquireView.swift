//
//  InquireBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

/// 문의하기 버튼 클릭 시 기본 화면
struct InquireView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: InquireViewModel
    
    // MARK: - Constants
    fileprivate enum InquireViewConstants {
        static let contentsVspacing: CGFloat =  29
        static let categoryVpsacing: CGFloat = 17
        
        static let categoryText: String = "카테고리"
        static let myInquireBtnText: String = "내가 문의한 내용 확인하기"
        static let naviTitle: String = "문의하기"
        static let naviCloseBtn: String = "chevron.left"
    }
    
    // MARK: - Body
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: InquireViewConstants.contentsVspacing, content: {
            topContents
            Divider()
            middleContents
            Spacer()
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaPadding(.top, UIConstants.topScrollPadding)
        .customNavigation(title: InquireViewConstants.naviTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: InquireViewConstants.naviCloseBtn))
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    // MARK: - TopContents
    ///내가 문의한 내용 확인 버튼
    private var topContents: some View {
        SelectBtnBox(btnInfo: BtnInfo(name: InquireViewConstants.myInquireBtnText, date: nil, action: {
            container.navigationRouter.push(to: .inquire(.myInquire))
        }))
    }
    
    // MARK: - MiddleContents
    /// 서비스 문의 카테고리 볼 수 있는 버튼들
    private var middleContents: some View {
        VStack(alignment: .leading, spacing: InquireViewConstants.categoryVpsacing, content: {
            Text(InquireViewConstants.categoryText)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            ForEach(categoryButtons, id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: btnInfo)
            }
        })
    }
    
    /// 서비스 문의 카테고리 버튼 데이터 모음
    private var categoryButtons: [BtnInfo] {
        InquireType.allCases.map { category in
            BtnInfo(name: category.text, date: nil, action: {
                container.navigationRouter.push(to: .inquire(.writeInquire(selectedInquiryCategory: category.param)))
            })
        }
    }
}

#Preview {
    InquireView(container: DIContainer())
        .environmentObject(DIContainer())
}
