//
//  InquireView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

/// 문의하기 작성
struct InquireWriteView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @Environment(\.alert) var alert
    @State var viewModel: InquireViewModel
    @State var showAlert: Bool = false
    let type: InquireType
    
    // MARK: - Init
    init(container: DIContainer, type: InquireType) {
        self.viewModel = .init(container: container)
        self.type = type
    }
    
    // MARK: - Body
    var body: some View {
        WriteFormView(
            textEidtor: $viewModel.inquireText,
            emailText: Binding<String?>(
                get: { viewModel.emailText },
                set: { viewModel.emailText = $0 ?? "" }
            ),
            images: $viewModel.inquirfeImages,
            type: .writeInquire(path: type)
        ) {
            // TODO: - API 연결 시 수정 부분
            await alert.trigger(type: .receivingInquiryAlert, showAlert: true, action: {
                Task {
                    await container.navigationRouter.pop()
                }
            })
        }
        .customAlert(alert: alert)
    }
}

#Preview {
    InquireWriteView(container: DIContainer(), type: .PARTNERSHIP)
        .environmentObject(DIContainer())
}
