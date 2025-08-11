//
//  ReportView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/9/24.
//

import SwiftUI

/// 신고하기 작성 뷰
struct ReportyWriteView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
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
            print("클릭")
            await container.navigationRouter.pop()
        }
    }
}

#Preview {
    ReportyWriteView(container: DIContainer())
        .environmentObject(DIContainer())
}
