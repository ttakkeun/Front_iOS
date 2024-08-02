//
//  QnaView.swift
//  ttakkeun
//
//  Created by 한지강 on 7/28/24.
//
import SwiftUI

struct QnaView: View {
    
    @StateObject private var viewModel = QnaViewModel()
    
    let segments: [String] = ["FAQ", "TIPS"]
    @State private var selected: String = "FAQ"
    @Namespace var name
    
    let categoryColors: [CategoryType: Color] = [
        .ear: Color.afterEar,
        .eye: Color.afterEye,
        .hair: Color.afterHair,
        .claw: Color.afterClaw,
        .teeth: Color.afterTeeth
    ]
    @State private var selectedCategory: CategoryType = .ear
    @State private var expandedQuestionIds: Set<UUID> = []
    
    //MARK: - Init
    init() {
        self._viewModel = StateObject(wrappedValue: QnaViewModel())
    }
    
    
    //MARK: - Contents
    var body: some View {
        VStack(spacing: 0) {
            Header
            ScrollView(.vertical){
                topTenQuestionSet
                categoryQna
                Spacer()
            }
        }
    }
    
    /// StatusBar랑 FAQ,TIPS segmentedControl 모은 최상단 Header
    private var Header: some View {
        VStack(alignment: .leading) {
            topStatusBar()
            Spacer()
            customSegmentedControl
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Color.mainBg)
        .overlay(
            Rectangle()
                .frame(width: .infinity, height: 1)
                .foregroundColor(Color.gray200),
            alignment: .bottom)
    }
    
    /// 제목과 10개의 질문 모음
    private var topTenQuestionSet: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("자주 묻는 질문 Top 10")
                .font(.H4_bold)
                .padding(.top, 30)
                .padding(.leading, 14)
            topTenQuestion
        }
        .frame(maxHeight: 200)
        .padding(.bottom, 30)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray200),
            alignment: .bottom)
    }
  
    /// 카테고리 버튼과 카테고리별 qna 모음
    private var categoryQna: some View {
        VStack(spacing: 15) {
            fiveCategoryButton
                categoryQnaList
        }
    }
    
    /// FAQ, TIPS segmented Control
    private var customSegmentedControl: some View {
        HStack(spacing: 0){
            ForEach(segments, id: \.self) { segment in
                Button {
                    withAnimation{
                        selected = segment
                    }
                } label: {
                    VStack(spacing: 6) {
                        if selected == segment {
                            Text(segment)
                                .font(.Body2_bold)
                                .foregroundColor(.gray900)
                        } else {
                            Text(segment)
                                .font(.Body2_regular)
                                .foregroundColor(.gray900)
                        }
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(width: 46, height: 3)
                            if selected == segment {
                                Capsule()
                                    .fill(Color.gray600)
                                    .frame(width: 46, height: 3)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //TODO: - 배열 Json으로 바꿔야함!! 내가 생각하기에 question데이터의 구조가 다 똑같다. 그래서 TIPS뷰 나오면 toptenquestion 데이타 삭제하고 Questiondata로 통일 > 대신 Json 파일만 다르게
    /// 질문 LazyHgrid
    private var topTenQuestion: some View {
        let rows = [GridItem(.flexible(minimum: 160, maximum: 180))]
        let questions: [TopTenQuestionData] = [
            TopTenQuestionData(category: .ear, content: "털이 왜 이렇게 빠지는 지 궁금해요 !!"),
            TopTenQuestionData(category: .eye, content: "눈이 왜 이렇게 빨간가요?"),
            TopTenQuestionData(category: .hair, content: "털이 왜 이렇게 빠지는 지 궁금해요 !!"),
            TopTenQuestionData(category: .claw, content: "발톱을 자주 깎아줘야 하나요?"),
            TopTenQuestionData(category: .teeth, content: "이빨이 자주 아파요."),
            TopTenQuestionData(category: .ear, content: "귀에서 이상한 소리가 나요."),
            TopTenQuestionData(category: .eye, content: "눈곱이 많이 끼는 이유는 무엇인가요?"),
            TopTenQuestionData(category: .hair, content: "털이 왜 이렇게 빠지는 지 궁금해요 !!"),
            TopTenQuestionData(category: .claw, content: "발톱을 자주 깎아줘야 하나요?"),
            TopTenQuestionData(category: .teeth, content: "이빨이 자주 아파요.")
        ]
        return ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 16) {
                Spacer().frame(width: -2)
                ForEach(Array(questions.prefix(10).enumerated()), id: \.element.id) { index, question in
                    
                    Button(action: {print("버튼 클릭")}){
                        TopTenQuestion(data: question, index: index)
                            .foregroundStyle(Color.gray900)
                    }
                }
            }
        }
    }
    
    /// 카테고리 버튼 텍스트 변환
    private func categoryText(_ category: CategoryType) -> String {
        switch category {
        case .ear:
            return "귀"
        case .eye:
            return "눈"
        case .hair:
            return "털"
        case .claw:
            return "발톱"
        case .teeth:
            return "이빨"
        }
    }
    
    /// 카테고리 버튼
    private var fiveCategoryButton: some View {
        let categories = CategoryType.allCases
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        return LazyVGrid(columns: columns, spacing: 11) {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    Text(categoryText(category))
                        .frame(width: 105, height: 43)
                        .font(.Body3_semibold)
                        .foregroundStyle(Color.gray900)
                        .background(selectedCategory == category ? categoryColors[category] : Color.checkBg)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding()
    }
    
    /// 뷰모델에서 질문이랑 대답 가져와서 배열에 넣기
    private var filteredQnaItems: [CategoryQnAData] {
        return viewModel.qnaItems.filter { $0.category == selectedCategory }
    }
    
    /// 카테고리별 질문 , 클릭하면 id부여해서 답나오게 함
    private var categoryQnaList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(filteredQnaItems) { item in
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        withAnimation {
                            if expandedQuestionIds.contains(item.id) {
                                expandedQuestionIds.remove(item.id)
                            } else {
                                expandedQuestionIds.insert(item.id)
                            }
                        }
                    }) {
                        VStack(alignment: .leading, spacing: -5) {
                            HStack {
                                Text("Q. \(item.question)")
                                    .font(.Body3_semibold)
                                    .foregroundStyle(Color.gray900)
                                    .padding(.leading, 19)
                                
                                Spacer()
                                
                                Image(systemName: expandedQuestionIds.contains(item.id) ? "chevron.up" : "chevron.down")
                                    .foregroundStyle(Color.gray500)
                                    .padding(.trailing, 19)
                            }
                            .frame(maxWidth: .infinity, minHeight: 58)
                            .background(Color.clear)
                            
                            if expandedQuestionIds.contains(item.id) {
                                HStack(alignment: .top, spacing: 5){
                                    Text("A.")
                                        .font(.Body3_semibold)
                                        .foregroundStyle(Color.primarycolor700)
                                        .padding(.leading, 40)
                                    Text(item.answer)
                                        .frame(maxWidth: 300, alignment: .leading)
                                        .font(.Body3_semibold)
                                        .foregroundStyle(Color.primarycolor700)
                                }
                                .padding(.bottom, 31)
                                .transition(.opacity .animation(.easeInOut(duration: 0.2)))
                            }
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray200),
                            alignment: .top
                        )
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray200),
                            alignment: .bottom
                        )
                    }
                }
            }
        }
    }
}

//MARK: - Preview
struct QnaFAQView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            QnaView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
