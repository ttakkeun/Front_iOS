//
//  TipsView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/4/24.
//

import SwiftUI

/// 팁스 게시글 뷰
struct TipsView: View {
    
    // MARK: - Property
    @State var viewModel: TipsViewModel
    @EnvironmentObject var container: DIContainer
    
    fileprivate enum TipsConstants {
        static let contentsVspacing: CGFloat = 16
        static let tipsLaztVspacing: CGFloat = 16
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: TipsConstants.contentsVspacing, content: {
            TipsSegment(viewModel: viewModel)
            middleContents
        })
        .onChange(of: viewModel.isSelectedCategory, {
            loadInitialTIps()
        })
        .task {
            loadInitialTIps()
        }
    }
    
    // MARK: - Top
    /// 상단 제목
    @ViewBuilder
    private var title: some View {
        if viewModel.isSelectedCategory == .all || viewModel.isSelectedCategory == .best {
            Text("🔥\(viewModel.isSelectedCategory.toKorean())")
                .font(.H2_bold)
                .foregroundStyle(Color.gray900)
        }
    }
    
    // MARK: - Middle
    private var middleContents: some View {
        ScrollView(.vertical, content: {
            if !viewModel.tipsResponse.isEmpty {
                tipsContentCards
            } else {
                progressView
            }
        })
        .refreshable {
            categoryAction(refresh: true)
        }
        .contentMargins(.horizontal, UIConstants.defaultSafeHorizon, for: .scrollContent)
        .contentMargins(.bottom, UIConstants.safeBottom, for: .scrollContent)
    }
    
    /// 팁스 내용들 존재할 경우 목록
    private var tipsContentCards: some View {
        LazyVStack(alignment: .leading, spacing: TipsConstants.tipsLaztVspacing, content: {
            title
            forEachTipContentCards
        })
    }
    
    /// 팁스 컨텐츠 카드 ForEach
    @ViewBuilder
    private var forEachTipContentCards: some View {
        ForEach($viewModel.tipsResponse, id: \.self) { $data in
            TipsContentsCard(
                data: $data, tipsType: .scrapTips,
                tipsButtonOption: .init(
                    heartAction: {
                        viewModel.toggleLike(for: data.tipId)
                }, scrapAction: {
                    viewModel.toggleBookMark(for: data.tipId)
                }),
                reportActoin: {
                    container.navigationRouter.push(to: .tips(.tipsReport(tipId: data.tipId)))
            })
            .onAppear {
                cardTaskActoin(data: data)
            }
        }
    }
    
    /// 프로그레스 뷰 컴포넌트
    private var progressView: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
    }
}

extension TipsView {
    /// 첫 로딩 시 카테고리 데이터 조회
    func loadInitialTIps() {
        switch viewModel.isSelectedCategory {
        case .all:
            viewModel.startNewAllTipsRequest()
        case .best:
            viewModel.startNewBestTipsRequest()
        case .part(let part):
            viewModel.startNewCategorTipsRequest(part: part)
        default:
            break
        }
    }
    
    /// 꿀팁카드 조회 시 무한 스크롤 액션
    /// - Parameter data: 꿀팁 카드 조회
    func cardTaskActoin(data: TipGenerateResponse) {
        guard data.id == viewModel.tipsResponse.last?.id, viewModel.canLoadMoreTips else { return }
        categoryAction()
    }
    
    /// 꿀팁 카드 카테고리 별 액션 정리
    /// - Parameter refresh: 리프레시 여부 표시
    private func categoryAction(refresh: Bool = false) {
        switch viewModel.isSelectedCategory {
        case .all:
            viewModel.getTipsAll(page: viewModel.tipsPage, refresh: refresh)
        case .best:
            viewModel.getTipsBest()
        case .part(let part):
            viewModel.getTipsCategory(category: part.rawValue, page: viewModel.tipsPage, refresh: refresh)
        default:
            break
        }
    }
}

#Preview {
    TipsView(container: DIContainer())
        .environmentObject(DIContainer())
}
