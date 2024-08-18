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
    
    let data: PetProfileResponseData
    @EnvironmentObject var petState: PetState
    
    init(
        data: PetProfileResponseData
    ) {
        self.data = data
    }
    
    var body: some View {
        ZStack(alignment: .top, content: {
            bottomCard
                .padding(.top, 86)
            topImage
        })
    }
    
    /// 상단 애니멀
    @ViewBuilder
    private var topImage: some View {
        switch data.type {
        case .cat:
            Icon.ProfileCat.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 113, height: 95)
        case .dog:
            Icon.ProfileDog.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 113, height: 95)
        }
    }
    
    @ViewBuilder
    private var bottomCard: some View {
        switch data.type {
        case .cat:
            havePet
        case .dog:
            havePet
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
    
    /// 펫 프로필 카드 정보
    private var havePet: some View {
        Button(action: {
            petState.petId = data.pet_id
            petState.petName = data.name
            print("펫 아이디 : \(petState.petId)")
            print("펫 이름 : \(petState.petName)")
        }, label: {
            VStack(alignment: .center, spacing: 28, content: {
                
                VStack(spacing: 10, content: {
                    Text(data.name)
                        .font(.suit(type: .bold, size: 18))
                        .foregroundStyle(Color.gray_900)
                    Text(formattedData(from: data.birth))
                        .font(.suit(type: .medium, size: 12))
                        .foregroundStyle(Color.subProfileColor)
                })
                
                petProfileImage
            })
            .frame(width: 213, height: 286)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 20))
            .shadow04()
        })
    }
    
    /// 펫 프로필 이미지
    @ViewBuilder
    private var petProfileImage: some View {
        if let url = URL(string: data.image) {
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
    
    // MARK: Function
    
    /// 날짜 형식 변환
    /// - Parameter dateString: 입력 받은 날짜 넣기
    /// - Returns: xxx.xxx.xxx 형식으로 넣어서 변환
    private func formattedData(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd"
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
}

struct ProfileSelect_Preview: PreviewProvider {
    static var previews: some View {
        ProfileSelect(data: PetProfileResponseData(pet_id: 1, name: "zbzb", image: "https://i.namu.wiki/i/lSIXWXTbk5GRjQRov2qaIaOR7HzJMGN08i2RIwc9bJhIycmGF3UG4Jw0S6_BSu95y90-o5iOXK98R3p1G1ih9ggdJiGJ84dY2j8kYnsg2nznFmLI3BibM-q_dEhabV8YgMQYTxZTMS55AgyNIcrGqQ.webp", type: .cat, birth: "2021-02-01"))
    }
}
