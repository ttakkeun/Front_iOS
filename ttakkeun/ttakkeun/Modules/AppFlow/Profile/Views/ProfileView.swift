//
//  ProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI

/// 반려 동물 선택 프로필 선택
struct ProfileView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @State var viewModel: ProfileViewModel
    
    // MARK: - Constants
    fileprivate enum ProfileConstants {
        static let profileViewWidth: CGFloat = 213
        static let geometryHeight: CGFloat = 438
        static let profileContentsTopPadding: CGFloat = 32
        
        static let topTitleVspacing: CGFloat = 30
        static let topTitleSize: CGFloat = 40
        static let topTitleMaxHeight: CGFloat = 133
        static let topTitleHeight: CGFloat = 48
        
        static let topTitleText: String = "따끈"
        static let loadingText: String = "잠시 기다려 주세요!"
        static let createProfileId: String = "createProfile"
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, content: {
            Spacer()
            
            if !viewModel.isLoading {
                topTitle
                middleContents
            } else {
                ProgressView(label: {
                    LoadingDotsText(text: ProfileConstants.loadingText)
                })
                .controlSize(.large)
            }
            
            Spacer()
        })
        .frame(maxWidth: .infinity)
        .background(viewModel.backgroudColor)
        .task {
            await viewModel.updateBackgroundColor()
            viewModel.getPetProfile()
        }
        .fullScreenCover(isPresented: $viewModel.showFullScreen, onDismiss: {
            Task {
                await viewModel.updateBackgroundColor()
                viewModel.getPetProfile()
            }
        },content: {
            ProfileFormView(mode: .create, container: container)
        })
    }
    
    // MARK: - TopContents
    private var topTitle: some View {
        VStack(alignment: .center, spacing: ProfileConstants.topTitleVspacing, content: {
            Text(ProfileConstants.topTitleText)
                .font(.santokki(type: .regular, size: ProfileConstants.topTitleSize))
                .foregroundStyle(Color.gray900)
                .frame(height: ProfileConstants.topTitleHeight)
            
            
            Text(viewModel.isLastedCard ? "새로운 가족을 등록해주세요" : "안녕하세요! \n저는 \(viewModel.titleName) 입니다.")
                .font(.H3_bold)
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.center)
        })
        .frame(maxHeight: ProfileConstants.topTitleMaxHeight, alignment: .top)
    }
    
    private var middleContents: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    profileContent(geometry: geometry)
                }
                .scrollIndicators(.hidden)
                .task {
                    if let firstId = self.viewModel.petProfileResponse?.result.first?.petId {
                        proxy.scrollTo(firstId, anchor: .center)
                    } else {
                        proxy.scrollTo(ProfileConstants.createProfileId, anchor: .center)
                    }
                }
            }
        }
        .frame(height: ProfileConstants.geometryHeight)
    }
    
    private func profileContent(geometry: GeometryProxy) -> some View {
        HStack(spacing: .zero, content: {
            
            if let results = viewModel.petProfileResponse?.result {
                ForEach(results, id: \.self) { data in
                    profileReadView(geometry: geometry, data: data)
                        .id(data.petId)
                }
                createProfileView(geometry: geometry)
                    .id(ProfileConstants.createProfileId)
            } else {
                createProfileView(geometry: geometry)
                    .id(ProfileConstants.createProfileId)
            }
            
        })
        .frame(maxWidth: .infinity)
        .padding(.top, ProfileConstants.profileContentsTopPadding)
        .padding(.horizontal, (geometry.size.width - 200) / 2)
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
                .animation(.bouncy, value: scaleValue(geometry: geometry, itemGeometry: item))
                .environmentObject(appFlowViewModel)
                .onChange(of: self.isCentered(geometry: geometry, itemGeometry: item)) {
                    changeProfileValue(geometry: geometry, item: item, data: data)
                }
                .task {
                    changeProfileValue(geometry: geometry, item: item, data: data)
                }
                .position(x: item.size.width / 2, y: item.size.height / 2)
        }
        .frame(width: ProfileConstants.profileViewWidth, alignment: .center)
    }
    
    private func createProfileView(geometry: GeometryProxy) -> some View {
        GeometryReader { item in
            CreateProfileCard(showFullScreen: $viewModel.showFullScreen)
                .scaleEffect(self.scaleValue(geometry: geometry, itemGeometry: item))
                .animation(.bouncy, value: self.scaleValue(geometry: geometry, itemGeometry: item))
                .onChange(of: self.isCentered(geometry: geometry, itemGeometry: item)) {
                    if self.isCentered(geometry: geometry, itemGeometry: item) {
                        Task {
                            viewModel.isLastedCard = true
                            await viewModel.updateBackgroundColor()
                        }
                    }
                }
        }
        .frame(width: ProfileConstants.profileViewWidth)
    }
    
    private func changeProfileValue(geometry: GeometryProxy, item: GeometryProxy, data: PetProfileDetail) {
        if self.isCentered(geometry: geometry, itemGeometry: item) {
            Task {
                viewModel.titleName = data.name
                viewModel.isLastedCard = false
                await viewModel.updateBackgroundColor()
            }
        }
    }
}

#Preview {
    ProfileView(container: DIContainer())
        .environmentObject(DIContainer())
        .environmentObject(AppFlowViewModel())
}
