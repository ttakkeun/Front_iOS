//
//  ProfileCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI
import Kingfisher

struct ProfileCard: View {
    
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    let data: PetProfileDetail
    let userState = UserState.shared
    
    init(data: PetProfileDetail) {
        self.data = data
    }
    
    var body: some View {
        ZStack(alignment: .top, content: {
            petInformation
                .padding(.top, 88)
            topImage
        })
    }
    
    @ViewBuilder
    private var topImage: some View {
        switch data.type {
        case .cat:
            makeProfileIcon(Icon.profileCat.image)
        case .dog:
            makeProfileIcon(Icon.profileDog.image)
        }
    }
    
    @ViewBuilder
    private var petProfileImage: some View {
        if let image = data.image,
           let url = URL(string: image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .frame(width: 120, height: 120)
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure { _ in
                    print("펫 프로필 이미지 로딩 실패")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 112, height: 112)
                .clipShape(Circle())
        }
    }
    
    private var profileName: some View {
        VStack(spacing: 10, content: {
            Text(data.name)
                .font(.Body1_bold)
                .foregroundStyle(Color.gray900)
            Text(DataFormatter.shared.formattedData(from: data.birth))
                .font(.Body4_medium)
                .foregroundStyle(Color.subProfile)
        })
    }
    
    private var petInformation: some View {
        Button(action: {
            self.userState.setPetId(data.petId)
            self.userState.setPetName(data.name)
            
            print("펫 아이디: \(userState.getPetId())")
            print("펫 이름: \(userState.getPetName())")
            
            withAnimation(.easeInOut(duration: 0.4), {
                self.appFlowViewModel.selectProfile()
            })
            
        }, label: {
            VStack(alignment: .center, spacing: 28, content: {
                
                profileName
                
                petProfileImage
            })
            .frame(width: 213, height: 286)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 20))
            .shadow04()
        })
    }
    
    private func makeProfileIcon(_ image: Image) -> some View {
        return image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 113, height: 95)
    }
}

struct ProfileCard_PreView: PreviewProvider {
    static var previews: some View {
        ProfileCard(data: PetProfileDetail(petId: 1, name: "zbzb", image: "https://i.namu.wiki/i/l1A4G8UguKz9EWMa3_Q7JWcWvKD9Y4XlzhVeZoHTq1iv4AGgnyFhfO83A9v--A4eTpway2j4vuLAAOO-7R0C1N91xDUM7YHO-2Nnzgg5HHcOdCRTAwbx39abqnUsA6lxbaUsN78mOXPFPbt_tJpCYg.webp", type: .dog, birth: "2021-02-01"))
    }
}
