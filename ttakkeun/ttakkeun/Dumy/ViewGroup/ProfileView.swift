//
//  ProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/14/24.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileCardViewModel
    @EnvironmentObject var petState: PetState
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    // MARK: - Contents
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            VStack(alignment: .center, spacing: 32, content: {
                topTitle
                scrollProfile
                
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea(.all)
            .background(viewModel.backgroundColor)
            .onAppear {
                Task {
                    await viewModel.getPetProfile()
                    await viewModel.updateBackgroundColor()
                }
            }
            .navigationDestination(for: NavigationDestination.self) {
                NavigationRoutingView(destination: $0)
            }
        }
    }
    
    private var scrollProfile: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 1, content: {
                        if let results = viewModel.petProfileData?.result {
                            ForEach(results, id: \.self) { data in
                                profileReadView(geometry: geometry, data: data)
                                    .id(data.pet_id)
                            }
                            profileCreateView(geometry: geometry)
                                .id("createProfile")
                        } else {
                            profileCreateView(geometry: geometry)
                                .id("createProfile")
                        }
                    })
                    .padding(.top, 32)
                    .padding(.horizontal, (geometry.size.width - 200) / 2)
                }
                .scrollIndicators(.hidden)
                .onAppear {
                    if let firstId = self.viewModel.petProfileData?.result.first?.pet_id {
                        proxy.scrollTo(firstId, anchor: .center)
                    } else {
                        proxy.scrollTo("createProfile", anchor: .center)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 446)
    }
    
    /// 프로필 뷰 상단 제목
    private var topTitle: some View {
        VStack(alignment: .center, spacing: 20, content: {
            Text("따끈")
                .font(.santokki(type: .regular, size: 40))
                .foregroundStyle(Color.gray_900)
                .frame(maxHeight: 80)
            Text(viewModel.isLastedCard ? "새로운 가족을 등록해주세요" : "안녕하세요! \n저는 \(viewModel.titleName)에요!")
                .font(.suit(type: .bold, size: 20))
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.center)
        })
        .frame(height: 145, alignment: .top)
    }
    
    // MARK: - Function
    
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
    
    /// 저장된 동물 프로필 리드
    /// - Parameters:
    ///   - geometry: 현재 화면 사이즈
    ///   - data: 카드에 입력되는 반려 동물 데이터
    /// - Returns: 커스텀 스크롤 뷰
    private func profileReadView(geometry: GeometryProxy, data: PetProfileResponseData) -> some View {
        GeometryReader { item in
            ProfileSelect(data: data)
                .scaleEffect(self.scaleValue(geometry: geometry, itemGeometry: item))
                .animation(.easeOut, value: scaleValue(geometry: geometry, itemGeometry: item))
                .environmentObject(petState)
                .environmentObject(appFlowViewModel)
                .onChange(of: self.isCentered(geometry: geometry, itemGeometry: item)) {
                    if self.isCentered(geometry: geometry, itemGeometry: item) {
                        viewModel.titleName = data.name
                        viewModel.isLastedCard = false
                        Task {
                            await viewModel.updateBackgroundColor()
                        }
                    }
                }
        }
        .frame(width: 200)
    }
    
    /// 프로필 생성
    /// - Parameter geometry: 현재 화면 사이즈
    /// - Returns: 스크롤 내부 사이즈
    private func profileCreateView(geometry: GeometryProxy) -> some View {
        GeometryReader { item in
            ProfileCreateView(viewModel: viewModel)
                .scaleEffect(self.scaleValue(geometry: geometry, itemGeometry: item))
                .animation(.easeOut, value: self.scaleValue(geometry: geometry, itemGeometry: item))
                .onChange(of: self.isCentered(geometry: geometry, itemGeometry: item)) {
                    if self.isCentered(geometry: geometry, itemGeometry: item) {
                        viewModel.isLastedCard = true
                        Task {
                            await viewModel.updateBackgroundColor()
                        }
                    }
                }
        }
        .frame(width: 210)
    }
    
}

// MARK: - CreateProfileCardView

/// 프로필 생성 카드 뷰
fileprivate struct ProfileCreateView: View {
    
    @ObservedObject var viewModel: ProfileCardViewModel
    
    var body: some View {
        Button(action: {
            Task {
                await viewModel.goToCreateProfile()
            }
        }, label: {
            ZStack(alignment: .top, content: {
                createProfilie
                    .padding(.top, 69)
                topImage
            })
            .padding(.top, 28)
        })
    }
        
               
        private var topImage: some View {
            Icon.togetherPet.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 134, height: 90)
        }
        /// 카드 생성하기
        private var createProfilie: some View {
            
            VStack(alignment: .center, spacing: 18, content: {
                Text("새로운 가족 추가하기")
                    .font(.suit(type: .bold, size: 16))
                    .foregroundStyle(Color.gray_900)
                Image(systemName: "plus")
                    .resizable()
                    .foregroundStyle(Color.black)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
            })
            .frame(width: 213, height: 286)
            .background(Color.primaryColor_Main)
            .clipShape(.rect(cornerRadius: 20))
            .shadow04()
        }
        
    }
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            
            let container = DIContainer()
            
            let petState = PetState()
            
            let viewModel = ProfileCardViewModel(container: container)
            
            ProfileView(viewModel: viewModel)
                .environmentObject(petState)
                .environmentObject(container)
        }
    }
