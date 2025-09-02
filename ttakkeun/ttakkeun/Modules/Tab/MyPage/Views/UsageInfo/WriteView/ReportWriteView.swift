//
//  ReportView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/9/24.
//

import SwiftUI

/// 신고하기 작성 뷰
struct ReportWriteView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @Environment(\.alert) var alert
    @State var viewModel: ReportViewModel
    let reportType: ReportType = .etcReport
    let tipId: Int
    
    // MARK: - Init
    init(container: DIContainer, tipId: Int) {
        self.viewModel = .init(container: container)
        self.tipId = tipId
    }
    
    var body: some View {
        WriteFormView(
            textEidtor: $viewModel.contentsText,
            emailText: .constant(nil),
            images: $viewModel.selectedImage,
            type: .writeReport
        ) {
            await viewModel.report(report: .init(tip_id: tipId, report_category: reportType.text, report_detail: viewModel.contentsText))
            await alert.trigger(type: .receivingReportAlert, showAlert: true, action: {
                Task {
                    await container.navigationRouter.pop()
                }
            })
        }
        .customAlert(alert: alert)
    }
}
