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
        .ear: Color(red: 1, green: 0.93, blue: 0.32)
        .opacity(0.4),
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
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        faqContent
                            .frame(width: geometry.size.width)
                        TipsView()
                            .frame(width: geometry.size.width)
                    }
                }
                .offset(x: selected == "FAQ" ? 0 : -geometry.size.width)
                .animation(.easeInOut, value: selected)
            }
        }
    }
    
    private var faqContent: some View {
            VStack {
                topTenQuestionSet
                categoryQna
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
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: -8){
                topTenQuestionTitle
                    .zIndex(1)
                    .padding([.top, .leading], 25)
                topTenQuestion
            }
        }
        .frame(maxHeight: 200)
        .padding(.bottom, 30)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray200),
            alignment: .bottom)
    }
    
    /// 고양이와 자주묻는 질문 Top10 텍스트
    private var topTenQuestionTitle: some View {
        HStack(spacing: 9){
            Icon.ProfileCat.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 67, height: 56)
            Text("자주 묻는 질문 Top 10")
                .font(.H4_bold)
        }
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
    
      /// 질문 LazyHgrid
      private var topTenQuestion: some View {
          let rows = [GridItem(.flexible(minimum: 160, maximum: 180))]
          return ScrollView(.horizontal, showsIndicators: false) {
              LazyHGrid(rows: rows, spacing: 16) {
                  ForEach(Array(viewModel.topTenQuestions.prefix(10).enumerated()), id: \.element.id) { index, question in
                      TopTenQuestion(data: question, index: index)
                          .foregroundStyle(Color.gray900)
                  }
              }
              .padding([.leading, .trailing], 14)
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
    private var filteredQnaItems: [QnaFaqData] {
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
