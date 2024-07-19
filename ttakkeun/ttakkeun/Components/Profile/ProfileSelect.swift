//
//  ProfileSelect.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/14/24.
//

import SwiftUI
import Kingfisher

/// 프로필 스크롤 만드는데 있어 필요한 카드
struct ProfileSelect: View {
    
    let viewType: ProfileType
    let data: PetProfileData
    
    init(
        viewType: ProfileType,
        data: PetProfileData
    ) {
        self.viewType = viewType
        self.data = data
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            topImage
            bottomCard
        })
    }
    
    
    
    /// 상단 애니멀
    @ViewBuilder
    private var topImage: some View {
        switch viewType {
        case .cat:
            Icon.ProfileCat.image
                .fixedSize()
        case .dog:
            Icon.ProfileDog.image
                .fixedSize()
        case .create:
            Icon.ProfileCreate.image
                .fixedSize()
        }
    }
    
    @ViewBuilder
    private var bottomCard: some View {
        switch viewType {
        case .cat:
            havePet
        case .dog:
            havePet
        case .create:
            createProfilie
        }
    }
    
    /// 카드 생성하기
    private var createProfilie: some View {
        Button(action: {
            print("새로운 가족 추가하기 버튼")
        }, label: {
            VStack(alignment: .center, spacing: 18, content: {
                Text("새로운 가족 추가하기")
                    .font(.suit(type: .bold, size: 16))
                    .foregroundStyle(Color.mainTextColor_Color)
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
    
    /// 펫 프로필 카드 정보
    private var havePet: some View {
        Button(action: {
            print("어떤 펫 클릭")
        }, label: {
            VStack(alignment: .center, spacing: 28, content: {
                
                VStack(spacing: 10, content: {
                    Text(data.name)
                        .font(.suit(type: .bold, size: 18))
                        .foregroundStyle(Color.mainTextColor_Color)
                    Text(data.date)
                        .font(.suit(type: .medium, size: 12))
                        .foregroundStyle(Color.subProfileColor_Color)
                })

                petProfileImage
            })
            .frame(width: 213, height: 286)
            .background(Color.green)
            .clipShape(.rect(cornerRadius: 20))
            .shadow04()
        })
    }
    
    /// 펫 프로필 이미지
    @ViewBuilder
    private var petProfileImage: some View {
        if let url = URL(string: data.imageUrl) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure { _ in
                    print("펫 프로필 이미지 로딩 실패!")
                }
                .resizable()
                .frame(width: 112, height: 112)
                .clipShape(Circle())
                .shadow01()
        }
    }
}

struct ProfileSelect_Preview: PreviewProvider {
    static var previews: some View {
        ProfileSelect(viewType: .dog, data: PetProfileData(name: "애우", date: "2023", imageUrl: "https://i.namu.wiki/i/styQt4UHIdH8AWkdwEpz3miGu120evQmfhE7vs3nQP94qwpJsN3_UfCOfJ_AbrAuJJ6fV3rOHwTBW-tH7Fg0hU9KN7dx7t9U2sv7bn0KTXyx4s-iDZohchSfr13IFHe0ved9mU-nOIh1J8aT-kk6WQ.webp"))
            .previewLayout(.sizeThatFits)
    }
}
