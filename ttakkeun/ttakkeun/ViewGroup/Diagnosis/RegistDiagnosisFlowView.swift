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
        Text("hello")
    }
}

#Preview {
    RegistDiagnosisFlowView(petState: PetState())
}
