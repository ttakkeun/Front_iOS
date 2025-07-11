//
//  ProfileImageCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI
import Kingfisher

struct ProfileImage: View {
    
    // MARK: - Property
    let profileImageUrl: String?
    let imageSize: CGFloat
    
    @State var imageLoadFalse = false
    
    // MARK: - Constants
    fileprivate enum ProfileImageConstants {
        static let imageMaxCount: Int = 2
        static let imageInterval: TimeInterval = 2
        static let imageOverlayOpacity: Double = 0.7
        
        static let systemImage: String = "person.circle.fill"
    }
    
    // MARK: - Init
    init(
        profileImageUrl: String?,
        imageSize: CGFloat = 120
    ) {
        self.profileImageUrl = profileImageUrl
        self.imageSize = imageSize
    }
    
    // MARK: - Body
    var body: some View {
        if let imageUrl = profileImageUrl,
           let url = URL(string: imageUrl), !imageLoadFalse {
            KFImage(url)
                .placeholder {
                    loadingImage
                }.retry(maxCount: ProfileImageConstants.imageMaxCount, interval: .seconds(ProfileImageConstants.imageInterval))
                .onFailure { _ in
                    imageLoadFalse = true
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
                .shadow05()
        }
    }
    
    /// 이미지 로딩
    private var loadingImage: some View {
        ZStack {
            noDataImage
            
            ProgressView()
                .controlSize(.regular)
                .tint(Color.white)
        }
    }
    
    /// 이미지 없을 경우
    private var noDataImage: some View {
        Image(systemName: ProfileImageConstants.systemImage)
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .tint(Color.gray400)
            .overlay(content: {
                Circle()
                    .fill(Color.black).opacity(ProfileImageConstants.imageOverlayOpacity)
                    .frame(width: imageSize, height: imageSize)
            })
            .shadow05()
    }
}

struct ProfileImageCard_Preview: PreviewProvider {
    static var previews: some View {
        ProfileImage(profileImageUrl: "xx")
    }
}
