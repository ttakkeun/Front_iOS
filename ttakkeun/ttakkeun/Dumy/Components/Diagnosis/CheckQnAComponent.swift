//
//  CheckQnAComponent.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/17/24.
//

import SwiftUI
import Kingfisher


/// 일지 체크리스트 뷰에서 서버로 받아온 질문 답변 사진 데이터 카드
struct CheckQnAComponent: View {
    
    @State var isClicked: Bool = true
    
    let data: QnAListData
    let dataIndex: Int
    
    init(data: QnAListData, dataIndex: Int) {
        self.data = data
        self.dataIndex = dataIndex
    }
    
    var body: some View {
            insideContents
    }
    
    /// 겉 배경 내부 질문 답변 사진 목록
    private var insideContents: some View {
        VStack(alignment: .leading, spacing: 16, content: {
            Text("\(dataIndex + 1). \(data.question)")
                .font(.Body1_bold)
                .foregroundStyle(Color.gray_900)
                .lineLimit(nil)
            
            selectedAnswer
            
            showAddImage
        })
        .padding(.horizontal, 15)
        .padding(.bottom, 25)
        .padding(.top, 15)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.clear)
                .stroke(Color.gray_200)
        )
        .frame(width: 344)
    }
    
    /// 일지 생성 시 선택했던 답변들 조회, 클릭 안되는 상태로 들어온다.
    private var selectedAnswer: some View {
        VStack(spacing: 5, content: {
            ForEach(data.answer, id: \.self) { answer in
                answerTextComponents(answer: answer)
                .disabled(true)
            }
        })
    }
    
    /// 이미지 처리 로딩 뷰
    @ViewBuilder
    private var showAddImage: some View {
        if let images = data.image {
            ScrollView(.horizontal) {
                HStack(spacing: 5, content: {
                    ForEach(images, id: \.self) { image in
                        if let url = URL(string: image) {
                            KFImage(url)
                                .placeholder {
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                }.retry(maxCount: 2, interval: .seconds(2))
                                .onFailure { _ in
                                    print("일지 답변 저장된 이미지 로딩 실패")
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 63, height: 63)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.clear)
                                        .stroke(Color.gray_200)
                                )
                        }
                    }
                })
            }
            .frame(width: 312)
        }  else {
            EmptyView()
        }
    }
    
    private func answerTextComponents(answer: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.primarycolor_200)
                .frame(width: 312, height: 65)
            
            HStack(alignment: .center, content: {
                Text(answer)
                    .font(.Body3_semibold)
                    .foregroundStyle(Color.gray_900)
                
                Spacer()
                
                Icon.answerCheck.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            })
            .frame(width: 264, height: 30)
        }
        .frame(width: 312, height: 65)
    }
}
