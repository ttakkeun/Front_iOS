//
//  JournalList.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import SwiftUI

struct JournalList: View {
    
    @ObservedObject var viewModel: DiagnosisViewModel
    
    var body: some View {
        noDataImage
    }
    
    private var noDataImage: some View {
        VStack(alignment: .center, spacing: 5, content: {
            Icon.bubble.image
                .fixedSize()
            Icon.bubbleLogo.image
                .fixedSize()
        })
    }
}

struct JournalList_Preview: PreviewProvider {
    static var previews: some View {
        JournalList(viewModel: DiagnosisViewModel())
    }
}
