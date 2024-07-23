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
    
    @State var titleName: String = ""
    @State var isLastedCard: Bool = false
    
    init() {
        self._viewModel = StateObject(wrappedValue: ProfileCardViewModel())
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 32, content: {
            topTitle
            scrollProfile
            
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea(.all)
        .background(viewModel.backgroundColor)
        .onAppear {
            viewModel.getPetProfile()
        }
    }
    
    private var scrollProfile: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(spacing: 1, content: {
                    if let results = viewModel.petProfileData?.result {
                        ForEach(results, id: \.self) { data in
                            GeometryReader { item in
                                ProfileSelect(data: data)
                                    .scaleEffect(self.scaleValue(geometry: geometry, itemGeometry: item))
                                    .animation(.easeOut, value: scaleValue(geometry: geometry, itemGeometry: item))
                                    .environmentObject(petState)
                                    .onAppear {
                                        self.titleName = data.name
                                        Task {
                                            await viewModel.updateBackgroundColor()
                                        }
                                    }
                                    .onChange(of: self.isCentered(geometry: geometry, itemGeometry: item)) {
                                        if self.isCentered(geometry: geometry, itemGeometry: item) {
                                            self.titleName = data.name
                                            self.isLastedCard = false
                                            Task {
                                                await viewModel.updateBackgroundColor()
                                            }
                                        }
                                    }
                            }
                            .frame(width: 200)
                        }
                    }
                    
                    GeometryReader { item in
                        ProfileCreateView()
                            .scaleEffect(self.scaleValue(geometry: geometry, itemGeometry: item))
                            .animation(.easeOut, value: self.scaleValue(geometry: geometry, itemGeometry: item))
                            .onAppear {
                                self.isLastedCard = true
                                Task {
                                    await viewModel.updateBackgroundColor()
                                }
                            }
                            .onChange(of: self.isCentered(geometry: geometry, itemGeometry: item)) {
                                if self.isCentered(geometry: geometry, itemGeometry: item) {
                                    self.isLastedCard = true
                                    Task {
                                        await viewModel.updateBackgroundColor()
                                    }
                                }
                            }
                    }
                    .frame(width: 210)
                })
                .padding(.top, 30)
                .padding(.horizontal, (geometry.size.width - 200) / 2)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: 446)
    }
    
    private var topTitle: some View {
        VStack(alignment: .center, spacing: 20, content: {
            Text("따끈")
                .font(.santokki(type: .regular, size: 40))
                .foregroundStyle(Color.gray_900)
                .frame(maxHeight: 80)
            Text(isLastedCard ? "새로운 가족을 등록해주세요" : "안녕허세요! \n저는 \(titleName)에요!")
                .font(.suit(type: .bold, size: 20))
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.center)
        })
    }
    
    private func scaleValue(geometry: GeometryProxy, itemGeometry: GeometryProxy) -> CGFloat {
        let itemCenter = itemGeometry.frame(in: .global).midX
        let screenCenter = geometry.size.width / 2
        let distance = abs(screenCenter - itemCenter)
        let scale = 1 - (distance / (geometry.size.width * 0.8))
        return max(0.6, scale)
    }
    
    private func isCentered(geometry: GeometryProxy, itemGeometry: GeometryProxy) -> Bool {
        let itermCenter = itemGeometry.frame(in: .global).midX
        let screenCenter = geometry.size.width / 2
        return abs(itermCenter - screenCenter) < 50
    }
}

// MARK: - CreateProfileCardView

fileprivate struct ProfileCreateView: View {
    
    var body: some View {
        ZStack(alignment: .top, content: {
            createProfilie
                .padding(.top, 70)
            topImage
        })
        .padding(.top, 28)
    }
    
    private var topImage: some View {
        Icon.togetherPet.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 134, height: 90)
    }
    /// 카드 생성하기
    private var createProfilie: some View {
        Button(action: {
            print("새로운 가족 추가하기 버튼")
        }, label: {
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
        })
        
    }
    
}

struct ProfielView_Preview: PreviewProvider {
    
    static let devices: [String] = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices , id: \.self) { device in
            ProfileView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(PetState())
        }
    }
}
