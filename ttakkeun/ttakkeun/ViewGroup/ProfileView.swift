//
//  ProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/14/24.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileCardViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: ProfileCardViewModel())
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 32, content: {
            topTitle
            scrollProfile
            
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea(.all)
        .background(Color.green)
        .onAppear {
            viewModel.getPetProfile()
        }
    }
    
    private var scrollProfile: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(spacing: 1, content: {
                    ForEach(viewModel.petProfileData?.result ?? [], id: \.self) { data in
                        GeometryReader { item in
                            ProfileSelect(data: data)
                                .scaleEffect(self.scaleValue(geometry: geometry, itemGeometry: item))
                                .animation(.easeOut, value: scaleValue(geometry: geometry, itemGeometry: item))
                        }
                        .frame(width: 200)
                    }
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
            Text("새로운 가족을 등록해주세요!")
                .font(.suit(type: .bold, size: 20))
        })
    }
    
    private func scaleValue(geometry: GeometryProxy, itemGeometry: GeometryProxy) -> CGFloat {
            let itemCenter = itemGeometry.frame(in: .global).midX
            let screenCenter = geometry.size.width / 2
            let distance = abs(screenCenter - itemCenter)
            let scale = 1 - (distance / (geometry.size.width * 0.8))
            return max(0.6, scale)
        }
}

// MARK: - CreateProfileCardView

fileprivate struct ProfileCreateView: View {
    
    var body: some View {
        ZStack(alignment: .top, content: {
            createProfilie
                .padding(.top, 53)
            topImage
        })
    }
    
    private var topImage: some View {
        Icon.togetherPet.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 134, height: 56)
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
            .background(Color.card003_Color)
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
        }
    }
}
