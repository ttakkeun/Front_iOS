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
        VStack(alignment: .center, content: {
            
            Capsule()
                .modifier(CapsuleModifier())
            
            Spacer().frame(height: 10)
            
            if let data = viewModel.journalResultData {
                topTitle(data: (data.date, data.time))
                
                Spacer().frame(height: 38)
                
                journalResultContents(data: data)
            } else {
                Spacer()
                
                ProgressView(label: {
                    LoadingDotsText(text: "일지 체크리스트 데이터를 받아오고 있습니다!! \n잠시만 기다려주세요")
                })
                .controlSize(.large)
                
                Spacer()
            }
        })
        .safeAreaPadding(EdgeInsets(top: 20, leading: 24, bottom: 20, trailing: 25))
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
    
    func makeJournalEtcTextBox(text: String) -> some View {
        return VStack(alignment: .leading, spacing: 16, content: {
            Text("4. 기타 특이사항이 있으면 알려주세요!")
                .font(.Body1_bold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
            
            
            TextEditor(text: .constant(text))
                .customStyleEditor(text: .constant(text), placeholder: "", maxTextCount: 150)
        })
        .frame(width: 314, height: 190)
        .modifier(JournalResultBoxModifier())
        
    }
    
    func journalResultContents(data: JournalResultResponse) -> some View {
        ScrollView(.vertical, content: {
            VStack(spacing: 32, content: {
                ForEach(data.qnaList.indices, id: \.self) { index in
                    JournalAnswerResult(data: data.qnaList[index], index: index)
                }
                
                if let text = data.etcString {
                        makeJournalEtcTextBox(text: text)
                }
            })
            .padding(.horizontal, 10)
        })
    }
}

struct JournalResultCheckView_Preview: PreviewProvider {
    static var previews: some View {
        JournalResultCheckView(viewModel: JournalListViewModel(container: DIContainer()))
    }
}
