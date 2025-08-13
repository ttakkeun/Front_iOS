//
//  ReportBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/9/24.
//
import SwiftUI

/// 신고하기 선택 시 기본 화면
struct ReportView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: MyPageViewModel
    
    // MARK: - Constants
    fileprivate enum ReportConstants {
        static let btnVspacing: CGFloat = 17
        static let naviTitle: String = "신고하기"
        static let naviCloseImage: String = "chevron.left"
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: ReportConstants.btnVspacing, content: {
            ForEach(btnInfoArray, id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: btnInfo)
            }
            Spacer()
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaPadding(.top, UIConstants.topScrollPadding)
        .customNavigation(title: ReportConstants.naviTitle, leadingAction: {
            container.navigationRouter.pop()
        }, naviIcon: Image(systemName: ReportConstants.naviCloseImage))
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    /// 여러 종류의 신고하기 버튼
    private var btnInfoArray: [BtnInfo] {
        ReportType.allCases.map { category in
            BtnInfo(name: category.text, date: nil, action: {
                if category == .etcReport {
                    container.navigationRouter.push(to: .tips(.tipsWriteReport))
                } else {
                    container.navigationRouter.push(to: .tips(.tipsReportDetail(selectedReportCategory: category.param)))
                }
            })
        }
    }
}

#Preview {
    ReportView(container: DIContainer())
        .environmentObject(DIContainer())
}
