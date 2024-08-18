//
//  CheckQuestionAnswer.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/17/24.
//

import SwiftUI

/// 일지 생성 시 작성한 질문과 답변 서버 전송 후 전달 받는 뷰
struct CheckQnAnswerView: View {
    
    let data: CheckJournalQnAResponseData
    
    init(data: CheckJournalQnAResponseData) {
        self.data = data
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
