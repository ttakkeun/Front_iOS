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
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    var body: some View {
        WriteFormView(
            textEidtor: $viewModel.contentsText,
            emailText: .constant(nil),
            images: $viewModel.selectedImage,
            type: .writeReport
        ) {
            await alert.trigger(type: .receivingReportAlert, showAlert: true, action: {
                Task {
                    await container.navigationRouter.pop()
                }
            })
        }
        .customAlert(alert: alert)
    }
}

#Preview {
    ReportWriteView(container: DIContainer())
        .environmentObject(DIContainer())
}
