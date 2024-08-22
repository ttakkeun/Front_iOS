//
//  SuggestionVIew.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/11/24.
//

import SwiftUI

struct SuggestionView: View {
    @StateObject private var viewModel = SuggestionViewModel()

    var body: some View {
        SuggestionInitialView(viewModel: viewModel)
            .background(Color.scheduleCard)
    }
}

#Preview {
    SuggestionView()
}
