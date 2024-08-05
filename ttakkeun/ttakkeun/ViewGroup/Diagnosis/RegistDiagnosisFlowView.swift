//
//  RegistDiagnosisFlowView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import SwiftUI

struct RegistDiagnosisFlowView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: RegistJournalViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: RegistJournalViewModel())
    }
    
    var body: some View {
        VStack(alignment: .center, content: {
            CustomNavigation(action: {
                dismiss()
            }, currentPage: viewModel.currentPage)
        })
    }
}

#Preview {
    RegistDiagnosisFlowView()
}
