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
    
    init(petState: PetState) {
        self._viewModel = StateObject(wrappedValue: RegistJournalViewModel(petId: petState.petId))
    }
    
    var body: some View {
        VStack(alignment: .center, content: {
            CustomNavigation(action: {
                dismiss()
            }, title: "일지 생성", currentPage: viewModel.currentPage, naviIcon: Image("close"), width: 14, height: 14)
            
            Spacer()
            
            RegistDiagnosisPageContents(viewModel: viewModel)
        })
        .frame(width: 355, height: 749)
    }
}

#Preview {
    RegistDiagnosisFlowView(petState: PetState())
}
