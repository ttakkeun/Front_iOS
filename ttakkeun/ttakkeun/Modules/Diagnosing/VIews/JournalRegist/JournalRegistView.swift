//
//  JournalRegistView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct JournalRegistView: View {
    @StateObject var viewModel: JournalRegistViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: .init(petID: UserState.shared.getPetId()))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 38, content: {
            CustomNavigation(action: {
                print("디스미스 처리")
            }, title: nil, currentPage: viewModel.currentPage)
            
            JournalRegistContents(viewModel: viewModel)
        })
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    JournalRegistView()
}
