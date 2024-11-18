//
//  JournalResultCheckView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import SwiftUI

/// 일지 생성 시 작성한 질문과 답변 서버 전송 후, 전달 받는 뷰
struct JournalResultCheckView: View {
    
    @ObservedObject var viewModel: JournalListViewModel
    
    var body: some View {
        topTitle(data: ("2024.06.24", "10:23:11.223"))
    }
}

extension JournalResultCheckView {
    
    func topTitle(data: (String, String)) -> some View {
        VStack(spacing: 0, content: {
            makeTitle()
            
            makeTimeAndData(data.0, data.1)
        })
    }
    
    func makeTitle() -> HStack<some View> {
        return HStack(spacing: 2, content: {
            Icon.leftCat.image
                .fixedSize()
            
            Text("일지 체크리스트")
                .font(.H2_bold)
                .foregroundStyle(Color.gray900)
            
            Icon.rightDog.image
                .fixedSize()
        })
    }
    
    func makeTimeAndData(_ date: String, _ time: String) -> HStack<some View> {
        return HStack(spacing: 3, content: {
            Text(DataFormatter.shared.formattedDate(from: date))
                .font(.Body3_bold)
                .foregroundStyle(Color.gray400)
            
            Text(DataFormatter.shared.formattedTime(from: time))
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
        })
    }
}

struct JournalResultCheckView_Preview: PreviewProvider {
    static var previews: some View {
        JournalResultCheckView(viewModel: JournalListViewModel())
    }
}
