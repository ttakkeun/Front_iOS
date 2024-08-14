//
//  QnaTipsView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/5/24.
//
import SwiftUI

/// Qna탭중 Tips에 대한 뷰
struct QnaTipsView: View {
    
    @StateObject private var viewModel = QnaTipsViewModel()
    
    //MARK: - Init
    init() {
        self._viewModel = StateObject(wrappedValue: QnaTipsViewModel())
    }
    
    //MARK: - Contents
    var body: some View {
            ZStack{
                VStack(alignment: .leading) {
                    categorySegment
                        .padding(.top, 16)
                    tipContents
                    Spacer()
                }
                FloatingWriteBtn()
            }
            .onAppear {
                Task {
                    await viewModel.getQnaTipsData()
                }
            }
    }
    
    /// 카테고리 별로 나눈 segmented Control
    private var categorySegment: some View {
           let categories = TipsCategorySegment.allCases
           return ScrollView(.horizontal, showsIndicators: false) {
               HStack(spacing: 8) {
                   ForEach(categories, id: \.self) { category in
                       Button(action: {
                           viewModel.selectedCategory = category
                       }) {
                           HStack{
                               Text(category.toKorean())
                                   .frame(width: 40, height: 20, alignment: .center)
                                   .font(.Body2_medium)
                                   .foregroundStyle(Color.gray900)
                                   .padding(.horizontal, 18.5)
                                   .padding(.vertical, 8)
                                   .background(
                                   RoundedRectangle(cornerRadius: 999)
                                    .stroke(Color.gray600, lineWidth: 2.5)
                                   .background(viewModel.selectedCategory == category ? Color.primarycolor_200 : Color.clear)
                                   )
                                   .clipShape(RoundedRectangle(cornerRadius:999))
                           }
                       }
                   }
               }
               .padding(.horizontal, 19)
           }
       }
    
    //TODO: - 전체랑 BEST에만 제목 넣어야함
    private var titleSet: some View {
        HStack{
            if viewModel.selectedCategory == .all || viewModel.selectedCategory == .best {
                title.padding(.leading,22)
                Spacer()
            }
        }
    }
    
    private var title: some View {
        Text("🔥\(viewModel.selectedCategory.toKorean())")
            .font(.H2_bold)
            .foregroundStyle(Color.gray900)
    }

    /// 공유한 팁 내용들
    private var tipContents: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                titleSet.frame(alignment: .leading)
                ForEach(viewModel.filteredTips) { tip in
                    TipContent(data: tip, isBestCategory: viewModel.selectedCategory == .best)
                }
            }
            .padding(.vertical, 27)
        }
    }
}
    
//MARK: - Preview
struct QnaTipsView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            QnaTipsView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
