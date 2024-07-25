//
//  ProfileImageCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import SwiftUI
import Kingfisher

/// 홈탭 프로필 전면 혹은 후면 사진
struct ProfileImageCard: View {
    
    let profileImageUrl: String?
    let imageSize: CGFloat
    let canEdit: Bool
    
    init(
        imageUrl: String?,
        imageSize: CGFloat = 140,
        canEdit: Bool = true
    ) {
        self.profileImageUrl = imageUrl
        self.imageSize = imageSize
        self.canEdit = canEdit
    }
    
    var body: some View {
        profileImageGroup
    }
    
    
    // MARK: Contents
    
    /// 프로필 이미지
    @ViewBuilder
    private var profileImageGroup: some View {
        if canEdit {
            ZStack(alignment: .bottomTrailing, content: {
                profileImage
                editProfileImage
            })
        } else {
            profileImage
        }
    }
    
    /// 프로필 이미지 뷰 빌더
    @ViewBuilder
    private var profileImage: some View {
        if let imageUrl = profileImageUrl,
           let url = URL(string: imageUrl) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure { _ in
                    print("프로필 이미지 캐시 오류")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
                .shadow01()
        }
    }
    
    /// 프로필 사진 편집 버튼
    private var editProfileImage: some View {
        Button(action: {
            print("hello")
        }, label: {
            ZStack(alignment: .center, content: {
                Circle()
                    .fill(Color.productCard_Color)
                    .frame(width: 30, height: 30)
                Icon.editProfile.image
                    .resizable()
                    .frame(width: 14, height: 14)
            })
            .padding([.vertical, .horizontal], 5)
        })
    }
}
