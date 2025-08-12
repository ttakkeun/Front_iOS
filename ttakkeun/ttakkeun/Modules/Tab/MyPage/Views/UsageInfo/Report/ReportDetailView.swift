//
//  ReportDetailBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/16/24.
//

import SwiftUI

/// 신고하기 카테고리 디테일 선택 뷰
struct ReportDetailView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: MyPageViewModel
    @State private var selectedBtnName: String? = nil
    let selectedCategory: ReportType
    
    // MARK: - Constants
    fileprivate enum ReportDetailConstants {
        static let btnHeight: CGFloat = 63
        static let btnVspacing: CGFloat = 17
        static let naviTitle: String = "신고하기"
        static let naviCloseImage: String = "xmark"
    }
    
    // MARK: - Init
    init(container: DIContainer, selectedCategory: ReportType) {
        self.viewModel = .init(container: container)
        self.selectedCategory = selectedCategory
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: ReportDetailConstants.btnVspacing, content: {
            topContents
            middleContents
            Spacer()
            MainButton(
                btnText: ReportDetailConstants.naviTitle,
                height: ReportDetailConstants.btnHeight,
                action: {
                    // TODO: - 신고하기
                    print("hello")
                },
                color: selectedBtnName == nil ? Color.checkBg : Color.mainPrimary
            )
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaPadding(.top, UIConstants.topScrollPadding)
        .customNavigation(title: ReportDetailConstants.naviTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: ReportDetailConstants.naviCloseImage))
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    // MARK: - TopContents
    /// 상단 경로 표시
    private var topContents: some View {
        Text("\(ReportDetailConstants.naviTitle) > \(selectedCategory.text)")
            .font(.Body4_medium)
            .foregroundStyle(Color.gray400)
    }
    
    //MARK: - MiddleContents
    /// 중간 여러 종류의 신고 버튼
    private var middleContents: some View {
        VStack(alignment: .center, spacing: ReportDetailConstants.btnVspacing, content: {
            ForEach(btnInfoArray, id: \.id) { btn in
                let isSelectedBinding = Binding<Bool>(
                    get: {
                        selectedBtnName == btn.name
                    },
                    set: { newValue in
                        if newValue {
                            selectedBtnName = btn.name
                        } else {
                            selectedBtnName = nil
                        }
                    })
                
                SelectBtnBox(btnInfo: .init(name: btn.name, date: btn.date, action: btn.action), isSelected: isSelectedBinding)
            }
        })
    }
    
    /// 버튼 배열 생성
    private var btnInfoArray: [BtnInfo] {
        guard let subItems = selectedCategory.subItems else { return [] }
        return subItems.compactMap { item in
            if let itemEnum = item as? ItemsText {
                return BtnInfo(name: itemEnum.text, date: nil, action: {
                    selectedBtnName = itemEnum.text
                })
            }
            return nil
        }
    }
}

#Preview {
    ReportDetailView(container: DIContainer(), selectedCategory: .animalAbuse)
        .environmentObject(DIContainer())
}
