//
//  VarietySearch 2.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/6/24.
//


import SwiftUI

/// 반려동물 품종 검색을 위한 뷰 구현
struct VarietySearch: View {
    
    @State private var searchText = ""
    @ObservedObject var viewModel: CreateProfileViewModel
    @Binding var showingVarietySearch: Bool
    
    /// 입력 텍스트 필터링('푸'검색하면 푸들 나오도록)
    private var filteredVarieties: [PetVarietyData] {
        if searchText.isEmpty {
            return PetVarietyData.allCases
        } else {
            return PetVarietyData.allCases.filter { $0.rawValue.contains(searchText) }
        }
    }
    
    //MARK: - Contents
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredVarieties, id: \.self) { item in
                    Button(action: {
                        viewModel.requestData?.variety = item.rawValue
                        viewModel.isVarietyFilled = true
                        showingVarietySearch = false
                    }, label: {
                        Text(item.rawValue)
                    })
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("품종 검색")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "검색어를 입력하세요"
            )
        }
        .onAppear(perform: {
            UIApplication.shared.hideKeyboard()
        })
        .font(.Body2_medium)
    }
}
