//
//  HomeProfileCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/15/24.
//

import SwiftUI
import Kingfisher

struct HomeProfileCard: View {
    
    let data: HomeProfileData
    
    init(data: HomeProfileData) {
        self.data = data
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    // MARK: - Components
    
    
    /// 프로필
    private var profileInfor: some View {
        VStack(alignment: .center, spacing: 2, content: {
            Text(data.name)
                .frame(maxWidth: 190)
                .font(.suit(type: .medium, size: 14))
                .foregroundStyle(Color.black)
            
            Text(data.date)
                .font(.suit(type: .bold, size: 10))
                .foregroundStyle(Color.subProfileColor_Color)
        })
    }
    
    /// 프로필 이미지 뷰 빌더
    @ViewBuilder
    private var profileImage: some View {
        if let url = URL(string: data.imageUrl) {
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
        ZStack(alignment: .center, content: {
            Circle()
                .background(Color.editColor_Color)
                .frame(width: 30, height: 30)
            Icon.editProfile.image
                .resizable()
                .frame(width: 14, height: 14)
        })
    }
}
