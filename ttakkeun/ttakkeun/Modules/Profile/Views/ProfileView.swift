//
//  ProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlopwViewModel: AppFlowViewModel
    @StateObject var viewModel: ProfileViewModel
    
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destination) {
            VStack(alignment: .center, content: {
                
                Spacer()
                
                topTitle
                scollProfile
                
                Spacer()
            })
            .background(viewModel.backgroudColor)
            .task {
                viewModel.updateBackgroundColor()
            }
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
                    .environmentObject(container)
            }
        }
    }
    
    private var topTitle: some View {
        VStack(alignment: .center, spacing: 30, content: {
            Text("따끈")
                .font(.santokki(type: .regular, size: 40))
                .foregroundStyle(Color.gray900)
                .frame(height: 48)
            
            
            Text(viewModel.isLastedCard ? "새로운 가족을 등록해주세요" : "안녕하세요! \n저는 \(viewModel.titleName) 입니다.")
                .font(.H3_bold)
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.center)
        })
        .frame(maxHeight: 133, alignment: .top)
    }
    
    private var scollProfile: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 1, content: {
                        if let results = viewModel.petProfileResponse?.result {
                            ForEach(results, id: \.self) { data in
                                profileReadView(geometry: geometry, data: data)
                                    .id(data.petId)
                            }
                            createProfileView(geometry: geometry)
                                .id("createProfile")
                        } else {
                            createProfileView(geometry: geometry)
                                .id("createProfile")
                        }
                    })
                    .padding(.top, 32)
                    .padding(.horizontal, (geometry.size.width - 200) / 2)
                }
                .scrollIndicators(.hidden)
                .task {
                    if let firstId = self.viewModel.petProfileResponse?.result.first?.petId {
                        proxy.scrollTo(firstId, anchor: .center)
                    } else {
                        proxy.scrollTo("createProfile", anchor: .center)
                    }
                }
            }
        }
        .frame(height: 438)
    }
}

extension ProfileView {
    /// 커스텀 스크롤의 중심의 사이즈 조절
    /// - Parameters:
    ///   - geometry: 현재 화면의 사이즈
    ///   - itemGeometry: 스크롤 내부 사이즈
    /// - Returns: 중심 위치에 있을 경우 사이즈 업
    private func scaleValue(geometry: GeometryProxy, itemGeometry: GeometryProxy) -> CGFloat {
        let itemCenter = itemGeometry.frame(in: .global).midX
        let screenCenter = geometry.size.width / 2
        let distance = abs(screenCenter - itemCenter)
        let scale = 1 - (distance / (geometry.size.width * 0.8))
        return max(0.6, scale)
    }
    
    /// 커스텀 스크롤 중심 측정
    /// - Parameters:
    ///   - geometry: 현재 화면 사이즈
    ///   - itemGeometry: 스크롤 내부 사이즈
    /// - Returns: 중심 위치 자리
    private func isCentered(geometry: GeometryProxy, itemGeometry: GeometryProxy) -> Bool {
        let itermCenter = itemGeometry.frame(in: .global).midX
        let screenCenter = geometry.size.width / 2
        return abs(itermCenter - screenCenter) < 50
    }
    
    private func profileReadView(geometry: GeometryProxy, data: PetProfileDetail) -> some View {
        GeometryReader { item in
            ProfileCard(data: data)
                .scaleEffect(self.scaleValue(geometry: geometry, itemGeometry: item))
                .animation(.easeOut, value: scaleValue(geometry: geometry, itemGeometry: item))
                .environmentObject(appFlopwViewModel)
                .onChange(of: self.isCentered(geometry: geometry, itemGeometry: item)) {
                    if self.isCentered(geometry: geometry, itemGeometry: item) {
                        viewModel.titleName = data.name
                        viewModel.isLastedCard = false
                        self.viewModel.updateBackgroundColor()
                    }
                }
        }
        .frame(width: 200)
    }
    
    private func createProfileView(geometry: GeometryProxy) -> some View {
        GeometryReader { item in
            CreateProfileCard(viewModel: viewModel)
                .scaleEffect(self.scaleValue(geometry: geometry, itemGeometry: item))
                .animation(.easeOut, value: self.scaleValue(geometry: geometry, itemGeometry: item))
                .onChange(of: self.isCentered(geometry: geometry, itemGeometry: item)) {
                    if self.isCentered(geometry: geometry, itemGeometry: item) {
                        viewModel.isLastedCard = true
                        self.viewModel.updateBackgroundColor()
                    }
                }
        }
        .frame(width: 200)
    }
}

struct ProfileView_Preview: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(container: DIContainer()))
            .environmentObject(DIContainer())
            .environmentObject(AppFlowViewModel())
    }
}
