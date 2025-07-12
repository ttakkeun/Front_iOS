//
//  VarietySearchView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/2/24.
//

import SwiftUI

struct VarietySearchView: View {
    
    // MARK: - Property
    @Bindable var viewModel: ProfileFormViewModel
    
    // MARK: - Constants
    fileprivate enum VarietySearchConstants {
        static let navigationTitle: String = "품종 검색"
        static let dogTitle: String = "강아지"
        static let catTitle: String = "고양이"
        static let searchPlaceholder: String = "검색어를 입력하세요!"
        
        static let headerSize: CGFloat = 30
    }
    
    var body: some View {
        NavigationStack {
            List {
                makeSection(data: viewModel.filteredDogVarieties, text: VarietySearchConstants.dogTitle)
                makeSection(data: viewModel.filteredCatVarieties, text: VarietySearchConstants.catTitle)
            }
            .searchable(
                text: $viewModel.searchVariety,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: VarietySearchConstants.searchPlaceholder
            )
            .font(.Body2_medium)
            .navigationTitle(VarietySearchConstants.navigationTitle)
        }
    }
    
    /// 섹션 생성
    /// - Parameters:
    ///   - data: 동물품종 데이터
    ///   - text: 상단 타이틀 이름
    /// - Returns: 뷰 반환
    private func makeSection(data: [PetVarietyData], text: String) -> some View {
        Section(content: {
            ForEach(data, id: \.self) { item in
                Button(action: {
                    viewModel.requestData.variety = item.rawValue
                    viewModel.isVarietyFieldFilled = true
                    viewModel.showingVarietySearch = false
                }, label: {
                    Text(item.rawValue)
                        .foregroundStyle(Color.black)
                })
            }
        }, header: {
            Text(text)
                .font(.suit(type: .extraBold, size: VarietySearchConstants.headerSize))
                .foregroundStyle(Color.black)
        })
    }
}

#Preview {
    VarietySearchView(viewModel: .init(mode: .create, container: DIContainer()))
}
