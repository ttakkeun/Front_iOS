//
//  TipsView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/4/24.
//

import SwiftUI

struct TipsView: View {
    
    // MARK: - Property
    @State var viewModel: TipsViewModel
    @EnvironmentObject var container: DIContainer
    
    // MARK: - Init
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24, content: {
                TipsSegment(viewModel: viewModel)
                tipContents
            })
        }
        
    }
    
    @ViewBuilder
    private var title: some View {
        if viewModel.isSelectedCategory == .all || viewModel.isSelectedCategory == .best {
            Text("🔥\(viewModel.isSelectedCategory.toKorean())")
                .font(.H2_bold)
                .foregroundStyle(Color.gray900)
                .frame(width: 358, alignment: .leading)
        }
        
    }
    
    private var tipContents: some View {
        ScrollView(.vertical, content: {
            if !viewModel.tipsResponse.isEmpty {
                LazyVStack(alignment: .center, spacing: 16, content: {
                    title
                    ForEach($viewModel.tipsResponse, id: \.self) { $data in
                        TipsContentsCard(data: $data, tipsType: .scrapTips, tipsButtonOption: TipsButtonOption(heartAction: { viewModel.toggleLike(for: data.tipId) }, scrapAction: { viewModel.toggleBookMark(for: data.tipId) }))
                            .environmentObject(container)
                            .onAppear {
                                guard !viewModel.tipsResponse.isEmpty else { return }
                                
                                
                                if data == viewModel.tipsResponse.last && viewModel.canLoadMoreTips {
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
                .padding(.bottom, 180)
            } else {
                HStack {
                    Spacer()
                    
                    VStack(alignment: .center) {
                        Spacer()
                        
                        ProgressView()
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
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
        .onAppear {
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
