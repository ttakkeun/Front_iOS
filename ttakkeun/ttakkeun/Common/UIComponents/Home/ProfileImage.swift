//
//  ProfileImageCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI
import Kingfisher

struct ProfileImage: View {
    
    let profileImageUrl: String?
    let imageSize: CGFloat
    
    @State var imageLoadFalse = false
    
    init(
        profileImageUrl: String?,
        imageSize: CGFloat = 120
    ) {
        self.profileImageUrl = profileImageUrl
        self.imageSize = imageSize
    }
    
    var body: some View {
        if let imageUrl = profileImageUrl,
           let url = URL(string: imageUrl), !imageLoadFalse {
            KFImage(url)
                .placeholder {
                    loadingImage
                }.retry(maxCount: 2, interval: .seconds(2))
                .onFailure { _ in
                    imageLoadFalse = true
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
                .shadow05()
        } else {
            loadingFaieldImage
        }
    }
    
    private var loadingImage: some View {
        ZStack {
            makeImage()
            
            ProgressView()
                .controlSize(.regular)
                .tint(Color.white)
        }
    }
    
    private var loadingFaieldImage: some View {
        ZStack {
            
            makeImage()
            
            Text("이미지를 \n불러오지 못했습니다.")
                .font(.Body5_medium)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
        }
    }
    
    private func makeImage() -> some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .tint(Color.gray400)
            .overlay(content: {
                Circle()
                    .fill(Color.black).opacity(0.7)
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
