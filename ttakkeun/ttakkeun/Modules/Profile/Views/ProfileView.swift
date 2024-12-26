//
//  ProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @StateObject var viewModel: ProfileViewModel
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    
    var body: some View {
            VStack(alignment: .center, content: {
                
                Spacer()
                
                if !viewModel.isLoading {
                    topTitle
                    scollProfile
                } else {
                    ProgressView(label: {
                        LoadingDotsText(text: "잠시 기다려 주세요!")
                    })
                    .controlSize(.large)
                }
                
                Spacer()
            })
            .frame(maxWidth: .infinity)
            .background(viewModel.backgroudColor)
            .onAppear {
                viewModel.updateBackgroundColor()
                viewModel.getPetProfile()
            }
            .fullScreenCover(isPresented: $viewModel.showFullScreen, onDismiss: {
                viewModel.updateBackgroundColor()
                viewModel.getPetProfile()
            },content: {
                MakeProfileView(container: container, showFullScreen: $viewModel.showFullScreen)
            })
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
                    .frame(maxWidth: .infinity)
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
                .animation(.bouncy, value: scaleValue(geometry: geometry, itemGeometry: item))
                .environmentObject(appFlowViewModel)
                .onChange(of: self.isCentered(geometry: geometry, itemGeometry: item)) {
                    changeProfileValue(geometry: geometry, item: item, data: data)
                }
                .onAppear {
                    changeProfileValue(geometry: geometry, item: item, data: data)
                }
                .position(x: item.size.width / 2, y: item.size.height / 2)
        }
        .frame(width: 213, alignment: .center)
    }
    
    private func createProfileView(geometry: GeometryProxy) -> some View {
        GeometryReader { item in
            CreateProfileCard(viewModel: viewModel)
                .scaleEffect(self.scaleValue(geometry: geometry, itemGeometry: item))
                .animation(.bouncy, value: self.scaleValue(geometry: geometry, itemGeometry: item))
                .onChange(of: self.isCentered(geometry: geometry, itemGeometry: item)) {
                    if self.isCentered(geometry: geometry, itemGeometry: item) {
                        viewModel.isLastedCard = true
                        self.viewModel.updateBackgroundColor()
                    }
                }
        }
        .frame(width: 213)
    }
    
    private func changeProfileValue(geometry: GeometryProxy, item: GeometryProxy, data: PetProfileDetail) {
        if self.isCentered(geometry: geometry, itemGeometry: item) {
            viewModel.titleName = data.name
            viewModel.isLastedCard = false
            self.viewModel.updateBackgroundColor()
        }
    }
}
