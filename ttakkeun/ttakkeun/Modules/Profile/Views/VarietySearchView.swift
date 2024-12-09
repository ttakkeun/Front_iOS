//
//  VarietySearchView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/2/24.
//

import SwiftUI

struct VarietySearchView: View {
    
    @ObservedObject var viewModel: MakeProfileViewModel
    
    var body: some View {
        NavigationStack {
            
            List {
                Section(content: {
                    ForEach(viewModel.filteredDogVarieties, id: \.self) { item in
                        Button(action: {
                            viewModel.requestData.variety = item.rawValue
                            viewModel.isVarietyFieldFilled = true
                            viewModel.showingVarietySearch = false
                        }, label: {
                            Text(item.rawValue)
                        })
                    }
                }, header: {
                    Text("강아지")
                        .font(.suit(type: .extraBold, size: 30))
                        .foregroundStyle(Color.black)
                })
                
                Section(content: {
                    ForEach(viewModel.filteredCatVarieties, id: \.self) { item in
                        Button(action: {
                            viewModel.requestData.variety = item.rawValue
                            viewModel.isVarietyFieldFilled = true
                            viewModel.showingVarietySearch = false
                        }, label: {
                            Text(item.rawValue)
                        })
                    }
                }, header: {
                    Text("고양이")
                        .font(.suit(type: .extraBold, size: 30))
                        .foregroundStyle(Color.black)
                })
            }
            .listStyle(PlainListStyle())
            .navigationTitle("품종 검색")
            .searchable(
                text: $viewModel.searchVariety,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "검색어를 입력하세요."
            )
            .font(.Body2_medium)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                HStack {
                    Button(action: {
                        viewModel.showingVarietySearch = false
                    }, label: {
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .foregroundStyle(Color.black)
                            .fontWeight(.regular)
                            .frame(width: 14, height: 14)
                    })
                    
                    Spacer()
                }
            })
            .toolbarRole(.navigationStack)
        }
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, topTrailingRadius: 10))
        
        .onAppear(perform: {
            UIApplication.shared.hideKeyboard()
        })
    }
}
