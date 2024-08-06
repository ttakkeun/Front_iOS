//
//  VarietySearch 2.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/6/24.
//


import SwiftUI

struct VarietySearch: View {
    
    @State private var searchText = ""
    @ObservedObject var viewModel: CreateProfileViewModel
    @Binding var showingVarietySearch: Bool
    
    var filteredVarieties: [PetVarietyData] {
        if searchText.isEmpty {
            return PetVarietyData.allCases
        } else {
            return PetVarietyData.allCases.filter { $0.rawValue.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
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
        .font(.Body2_medium)
    }
}
