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
                ForEach(viewModel.filteredVarieties, id: \.self) { item in
                    Button(action: {
                        viewModel.requestData.variety = item.rawValue
                        viewModel.isVarietyFieldFilled = true
                        viewModel.showingVarietySearch = false
                    }, label: {
                        Text(item.rawValue)
                    })
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("품종 검색")
            .searchable(
                text: $viewModel.searchVariety,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "검색어를 입력하세요."
            )
            .font(.Body2_medium)
        }
        .onAppear(perform: {
            UIApplication.shared.hideKeyboard()
        })
    }
}

struct VarietySearcView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iphone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            VarietySearchView(viewModel: MakeProfileViewModel())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
