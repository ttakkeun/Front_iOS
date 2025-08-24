//
//  ProfileCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI
import Kingfisher

/// 프로필 뷰 사용 프로필 카드
struct ProfileCard: View {
    
    // MARK: - Property
    @AppStorage(AppStorageKey.petId) var petId: Int?
    @AppStorage(AppStorageKey.petName) var petName: String?
    @AppStorage(AppStorageKey.petType) var petType: ProfileType?
    @Environment(\.appFlow) var appFlowViewModel
    
    /// 펫 프로필 데이터
    let data: PetProfileDetail
    
    // MARK: - Constants
    fileprivate enum ProfileCardConstants {
        static let petInfoSpacing: CGFloat = 28
        static let petInforWidth: CGFloat = 213
        static let petInfoHeight: CGFloat = 286
        
        static let profileNameVspacing: CGFloat = 10
        static let profileImageSize: CGSize = .init(width: 112, height: 112)
        
        static let profileIconWidth: CGFloat = 113
        static let profileIconHeight: CGFloat = 95
    
        static let topContentsOffset: CGFloat = 88
        
        static let cornerRadius: CGFloat = 20
        static let animationDuration: TimeInterval = 0.4
        static let imageRetryCount: Int = 2
    }
    
    // MARK: - Init
    init(data: PetProfileDetail) {
        self.data = data
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top, content: {
            topContents
            topContentsImage
        })
    }
    
    // MARK: - TopContents
    /// 프로필 카드 컨텐츠
    private var topContents: some View {
        Button(action: {
            Task {
                await setAppStoreage()
                withAnimation(.easeInOut(duration: ProfileCardConstants.animationDuration), {
                    self.appFlowViewModel.selectProfile()
                })
            }
        }, label: {
            VStack(alignment: .center, spacing: ProfileCardConstants.petInfoSpacing, content: {
                profileName
                petProfileImage
            })
            .frame(width: ProfileCardConstants.petInforWidth, height: ProfileCardConstants.petInfoHeight)
            .background {
                RoundedRectangle(cornerRadius: ProfileCardConstants.cornerRadius)
                    .fill(Color.white)
                    .shadow04()
            }
            .padding(.top, ProfileCardConstants.topContentsOffset)
        })
    }
    
    // MARK: - TopContentsImage
    /// 강아지 및 고양이 상단 이미지
    @ViewBuilder
    private var topContentsImage: some View {
        switch data.type {
        case .cat:
            makeProfileIcon(Image(.profileCat))
        case .dog:
            makeProfileIcon(Image(.profileDog))
        }
    }
    
    /// 프로필 이미지(반려동물 이미지)
    @ViewBuilder
    private var petProfileImage: some View {
        if let image = data.image,
           let url = URL(string: image) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: ProfileCardConstants.imageRetryCount, interval: .seconds(2))
                .onFailure { _ in
                    print("펫 프로필 이미지 로딩 실패")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: ProfileCardConstants.profileImageSize.width, height: ProfileCardConstants.profileImageSize.height)
                .clipShape(Circle())
        } else {
            NotProfileURLImage(size: ProfileCardConstants.profileImageSize)
        }
    }
    
    /// 프로필 이름(반려동물 이름)
    private var profileName: some View {
        VStack(spacing: ProfileCardConstants.profileNameVspacing, content: {
            Text(data.name)
                .font(.Body1_bold)
                .foregroundStyle(Color.gray900)
            Text(data.birth.formattedDate())
                .font(.Body4_medium)
                .foregroundStyle(Color.subProfile)
        })
    }
    
    private func makeProfileIcon(_ image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: ProfileCardConstants.profileIconWidth, height: ProfileCardConstants.profileIconHeight)
    }
    
    private func setAppStoreage() async {
        petId = data.petId
        petName = data.name
        petType = data.type
    }
}

struct ProfileCard_PreView: PreviewProvider {
    static var previews: some View {
        ProfileCard(data: PetProfileDetail(petId: 1, name: "zbzb", image: "", type: .dog, birth: "2021-02-01"))
            .environment(AppFlowViewModel())
    }
}
