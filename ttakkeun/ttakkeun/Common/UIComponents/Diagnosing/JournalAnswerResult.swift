//
//  JournalResultComponents.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import SwiftUI
import Kingfisher

/// 일지 선택 시, 선택했던 질문 및 답변 사진
struct JournalAnswerResult: View {
    
    let data: QnAListData
    let index: Int
    
    init(data: QnAListData, index: Int) {
        self.data = data
        self.index = index
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            selectedAnswerTitle
            
            selectedAnswerList
            
            selectedAnswerImage
        })
        .padding(.top, 20)
        .padding(.bottom, 24)
        .padding(.horizontal, 15)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .stroke(Color.gray200, lineWidth: 1)
        }
        .frame(width: 312)
    }
    
    private var selectedAnswerTitle: some View {
        Text("\(index + 1). \(data.question)")
            .font(.Body1_bold)
            .foregroundStyle(Color.gray900)
            .lineLimit(nil)
    }
    
    private var selectedAnswerList: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            ForEach(data.answer, id: \.self) { answer in
                JournalAnswerButton(isSelected: .constant(true),
                                    paddingValue: [18, 17, 24, 24],
                                    data: AnswerDetailData(answerText: answer),
                                    { print("nil") })
                    .disabled(true)
            }
        })
    }
    
    @ViewBuilder
    private var selectedAnswerImage: some View {
        if let images = data.image {
            ScrollView(.horizontal, content: {
                LazyHGrid(rows: Array(repeating: GridItem(.fixed(63)), count: 1), content: {
                    ForEach(images, id: \.self) { image in
                        if let url = URL(string: image) {
                            returnKFImage(url)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 64, height: 63)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.clear)
                                        .stroke(Color.gray200)
                                })
                        }
                    }
                })
            })
            .frame(maxWidth: 312, maxHeight: 70)
            .padding(.horizontal, 3)
        } else {
            EmptyView()
        }
    }
}

extension JournalAnswerResult {
    
    func returnKFImage(_ url: URL) -> KFImage {
        return KFImage(url)
            .placeholder {
                ProgressView()
                    .frame(width: 100, height: 100)
            }.retry(maxCount: 2, interval: .seconds(2))
    }
}

struct JournalAnswerResult_Preview: PreviewProvider {
    static var previews: some View {
        JournalAnswerResult(data: QnAListData(question: "평소보다 털빠짐이 심한가요?", answer: ["털빠짐이 심해요"], image: ["https://i.namu.wiki/i/tyVGcLlVT6Tun2Q2jMF3wPUJcQBkLFx2sFyv8OtW5Aeg_WSGWMBczlYKyzgHxReqktu8ZqESSqDoCp4J9jyRdzPml5awOeERU3yIaKDBZ1m2qLgml683--d0M4C3YWBer80In3yRSr4suSW0c0Lzsw.webp", "https://i.namu.wiki/i/AAqta2XOGzlv_kLJGyKfVvL2i2nkRGngXI8Oh7a2heu9O4NQA_t9q28pPx2zAojfb_Ehc-SW57Y0xR3TZvDivXnp6KDEtI-Rkpu0aysUaX76giL1Ae9xjHUtNShGGwl9j3NyFRRpGZphzVaE6AzIZw.webp"]), index: 1)
    }
}
