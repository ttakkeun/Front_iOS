//
//  HomeProfileCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/15/24.
//

import SwiftUI
import Kingfisher

/// 홈 프론트 카드
struct HomeFrontCard: View {
    
    @StateObject var viewModel: HomeProfileCardViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: HomeProfileCardViewModel())
    }
    
    var body: some View {
        contents
    }
    
    // MARK: - Components
    
    private var contents: some View {
        VStack(alignment: .center, spacing: 5, content: {
            
            HStack(content: {
                Text("PET CARD")
                    .font(.suit(type: .extraBold, size: 12))
                    .foregroundStyle(Color.subTextColor_Color)
                
                Spacer()
            })
            .padding(.horizontal, 24)
            .padding(.top, 13)
           
            
            profileImageGroup
            
            profileInfor
            
            /* 프로필 카드 체인지 */
            HStack(content: {
                
                Spacer()
                
                Button(action: {
                    viewModel.isChangeCard = true
                }, label: {
                    Icon.changeCard.image
                        .fixedSize()
                })
            })
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        })
        .frame(width: 354, height: 240)
        .background(Color.white.opacity(0.5))
        .clipShape(.rect(cornerRadius: 20))
    }
    
    // MARK: - ProfileImage
    
    /// 프로필 이미지
    private var profileImageGroup: some View {
        ZStack(alignment: .bottomTrailing, content: {
            profileImage
            editProfileImage
        })
    }
    
    /// 프로필 이미지 뷰 빌더
    @ViewBuilder
    private var profileImage: some View {
        if let url = URL(string: viewModel.profileData?.imageUrl ?? "") {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure { _ in
                    print("프로필 이미지 캐시 오류")
                }
                .resizable()
                .frame(width: 140, height: 140)
                .clipShape(Circle())
        }
    }
    
    /// 프로필 사진 편집 버튼
    private var editProfileImage: some View {
        Button(action: {
            print("hello")
        }, label: {
            ZStack(alignment: .center, content: {
                Circle()
                    .fill(Color.editColor_Color)
                    .frame(width: 30, height: 30)
                Icon.editProfile.image
                    .resizable()
                    .frame(width: 14, height: 14)
            })
            .padding([.vertical, .horizontal], 5)
        })
    }
    
    
    // MARK: - ProfileInfo
    
    /// 프로필 정보
    private var profileInfor: some View {
        VStack(alignment: .center, spacing: 2, content: {
            Text(viewModel.profileData?.name ?? "")
                .frame(maxWidth: 190)
                .font(.suit(type: .medium, size: 14))
                .foregroundStyle(Color.black)
            
            Text(viewModel.profileData?.date ?? "")
                .font(.suit(type: .bold, size: 10))
                .foregroundStyle(Color.subProfileColor_Color)
        })
        .padding(.top, 10)
    }
}
