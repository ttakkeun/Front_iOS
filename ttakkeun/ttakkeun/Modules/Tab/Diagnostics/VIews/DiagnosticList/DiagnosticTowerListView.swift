//
//  DiagnosListView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/6/24.
//

import SwiftUI

/// 진단 결과 뼈 타워 뷰
struct DiagnosticTowerListView: View {
    
    // MARK: - Property
    @Bindable var viewModel: DiagnosticResultViewModel
    @Binding var selectedPartItem: PartItem
    @AppStorage(AppStorageKey.petType) var petType: ProfileType = .dog
    
    // MARK: - Constants
    fileprivate enum DiagnosListConstants {
        static let horizonPadding: CGFloat = 56
        static let emptyDiagVspacing: CGFloat = 19
        static let topPadding: CGFloat = 75
        
        static let topCatWidth: CGFloat = 114
        static let topCatHeigt: CGFloat = 102
            
        static let catTowerOffset: CGFloat = 10
        static let zIndex: Double = 1
        
        static let emptyDiagListTitle: String = "아직 생성된 진단 기록이 없어요!! \n 일지 작성 후, 진단을 해보세요!"
    }
  
    // MARK: - Body
    var body: some View {
        if viewModel.diagResultListResponse.isEmpty {
            emptyDiagList
        } else {
            diagnosticList
        }
    }
    
    // MARK: - DiagList
    /// 진단결과 리스트 뷰
    private var diagnosticList: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, content: {
                ZStack(alignment: .top, content: {
                    topCatDogImage
                    diagTower
                })
            })
            .task {
                guard viewModel.diagResultListResponse.isEmpty else { return }
                viewModel.getDiagResultList(category: selectedPartItem.rawValue, page: .zero)
                
                if let lastID = viewModel.diagResultListResponse.last?.id {
                    scrollProxy.scrollTo(lastID, anchor: .bottom)
                }
            }
            .fullScreenCover(isPresented: $viewModel.isShowDetailDiag, content: {
                if let id = viewModel.selectedDiagId {
                    DiagnosticResultView(viewModel: viewModel, showFullScreenAI: $viewModel.isShowDetailDiag, diagId: id)
                        .presentationCornerRadius(UIConstants.sheetCornerRadius)
                }
            })
            .contentMargins(.horizontal, DiagnosListConstants.horizonPadding, for: .scrollContent)
        }
    }
    
    /// 뼈타워 상단 고정 고양이
    private var topCatDogImage: some View {
        Image(topImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: DiagnosListConstants.topCatWidth, height: DiagnosListConstants.topCatHeigt)
            .zIndex(DiagnosListConstants.zIndex)
            .offset(y: DiagnosListConstants.catTowerOffset)
    }
    
    /// 상단 고양이 또는 강아지 사진
    /// - Returns: 이미지 리소스 반환
    private func topImage() -> ImageResource {
        petType == .cat ? .profileCat : .profileDog
    }
    
    /// 진단 기록 뼈 타워
    private var diagTower: some View {
        LazyVStack(spacing: .zero, content: {
            towerForEach
            diagLoading
        })
        .frame(alignment: .bottom)
        .padding(.bottom, UIConstants.safeBottom)
        .padding(.top, DiagnosListConstants.topPadding)
        .zIndex(.zero)
    }
    
    @ViewBuilder
    private var towerForEach: some View {
        ForEach(viewModel.diagResultListResponse, id: \.id) { data in
            DiagnosticTower(data: data) {
                viewModel.selectedDiagId = data.diagnoseID
                viewModel.isShowDetailDiag = true
            }
            .task(id: selectedPartItem) {
                guard !viewModel.diagResultListResponse.isEmpty else { return }
                if data == viewModel.diagResultListResponse.last && viewModel.canLoadMore {
                    viewModel.getDiagResultList(category: self.selectedPartItem.rawValue, page: viewModel.currentPage)
                }
            }
            .refreshable {
                viewModel.getDiagResultList(category: selectedPartItem.rawValue, page: .zero, refresh: true)
            }
        }
    }
    
    /// 뼈 타워 로딩
    @ViewBuilder
    private var diagLoading: some View {
        if viewModel.isFetching {
            ProgressView()
                .controlSize(.regular)
        }
    }
    
    // MARK: - Empty
    /// 진단 결과 비었을 경우
    private var emptyDiagList: some View {
        VStack(spacing: DiagnosListConstants.emptyDiagVspacing, content: {
            Spacer()
            
            Text(DiagnosListConstants.emptyDiagListTitle)
                .font(.Body2_medium)
                .foregroundStyle(Color.gray400)
                .multilineTextAlignment(.center)
            
            Spacer()
        })
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    DiagnosticTowerListView(viewModel: .init(container: DIContainer()), selectedPartItem: .constant(.ear))
}
