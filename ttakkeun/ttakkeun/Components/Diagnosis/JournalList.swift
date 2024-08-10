//
//  JournalList.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import SwiftUI

/// 일지 목록 리스트 뷰 없을 시 데이터
struct JournalList: View {
    
    @ObservedObject var viewModel: JournalListViewModel
    
    var body: some View {
        noDataImage
    }
    
    /// 일지 데이터 없을 시 등장하는 이미지
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
        JournalList(viewModel: JournalListViewModel())
    }
}
