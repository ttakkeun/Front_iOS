//
//  ttakeunTab.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/10/25.
//

import SwiftUI

struct TtakeunTab: View {
    
    // MARK: - Property
    @State var tabcase: TabCase = .home
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    fileprivate enum TtakeunTabConstants {
        static let labelVspacing: CGFloat = 4
    }
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destination, root: {
            TabView(selection: $tabcase, content: {
                ForEach(TabCase.allCases, id: \.rawValue) { tab in
                    Tab(value: tab, content: {
                        tabView(tab: tab)
                    }, label: {
                        tabLabel(tab)
                    })
                }
            })
            .tint(Color.gray900)
            .navigationDestination(for: NavigationDestination.self, destination: { destination in
                NavigationRoutingView(destination: destination)
                    .environmentObject(container)
                    .environmentObject(appFlowViewModel)
            })
        })
    }
    
    private func tabLabel(_ tab: TabCase) -> some View {
        VStack(spacing: TtakeunTabConstants.labelVspacing, content: {
            tab.icon
                .renderingMode(.template)
            
            Text(tab.toKorean())
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
        })
    }
    
    @ViewBuilder
    private func tabView(tab: TabCase) -> some View {
        Group {
            switch tabcase {
            case .home:
                HomeView(container: container)
            case .diagnosis:
                Text("1")
            case .schedule:
                Text("1")
            case .suggestion:
                Text("1")
            case .qna:
                Text("1")
            }
        }
        .environmentObject(container)
        .environmentObject(appFlowViewModel)
    }
}

#Preview {
    Text("11")
}
