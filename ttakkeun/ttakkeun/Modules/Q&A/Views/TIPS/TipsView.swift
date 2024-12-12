//
//  TipsView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/4/24.
//

import SwiftUI

struct TipsView: View {
    
    @StateObject var viewModel: TipsViewModel
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24, content: {
                TipsSegment(viewModel: viewModel)
                
                tipContents
            })
        }
        .safeAreaPadding(EdgeInsets(top: 0, leading: 19, bottom: 0, trailing: 19))
        
    }
    
    @ViewBuilder
    private var title: some View {
        if viewModel.isSelectedCategory == .all || viewModel.isSelectedCategory == .best {
            Text("🔥\(viewModel.isSelectedCategory.toKorean())")
                .font(.H2_bold)
                .foregroundStyle(Color.gray900)
        }
    }
    
    private var tipContents: some View {
        ScrollView(.vertical, content: {
            if !viewModel.tipsResponse.isEmpty {
                LazyVStack(alignment: .leading, spacing: 16, content: {
                    title
                    ForEach($viewModel.tipsResponse, id: \.self) { $data in
                        TipsContentsCard(data: $data, tipsType: .scrapTips, tipsButtonOption: TipsButtonOption(heartAction: { viewModel.toggleLike(for: data.tipId) }, scrapAction: { viewModel.toggleBookMark(for: data.tipId) }))
                            .task {
                                if data == viewModel.tipsResponse.last {
                                    switch viewModel.isSelectedCategory {
                                    case .all:
                                        viewModel.getTipsAll(page: viewModel.tipsPage)
                                    case .best:
                                        viewModel.getTipsBest()
                                    case .part(let part):
                                        viewModel.getTipsCategory(category: part.rawValue, page: viewModel.tipsPage)
                                        
                                    default:
                                        break
                                    }
                                }
                            }
                    }
                    
                    if viewModel.fetchingTips {
                        ProgressView()
                            .controlSize(.regular)
                    }
                })
                .padding(.bottom, 100)
            }
        })
        .refreshable {
            switch viewModel.isSelectedCategory {
            case .all:
                viewModel.getTipsAll(page: viewModel.tipsPage, refresh: true)
            case .best:
                viewModel.getTipsBest()
            case .part(let part):
                viewModel.getTipsCategory(category: part.rawValue, page: viewModel.tipsPage, refresh: true)
            default:
                break
            }
        }
        .onChange(of: viewModel.isSelectedCategory, {
            loadInitialTIps()
        })
        .task {
            loadInitialTIps()
        }
    }
}

extension TipsView {
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
}
