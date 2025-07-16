//
//  RegistAlbumImageView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI
import PhotosUI

/// 사진 앨범 선택 뷰
struct RegistAlbumImageView<ViewModel: PhotoPickerHandle>: View {
    
    var viewModel: ViewModel
    
    let titleText: String
    let subTitleText: String
    
    let maxImageCount: Int = 5
    var maxWidth: CGFloat = 355
    var maxHeight: CGFloat = 300
    let lineSpacing: CGFloat = 2
    let titleVSpacing: CGFloat = 5
    let contentsVspacing: CGFloat = 16
    let cameraHspacing: CGFloat = 5
    let imageSize: CGFloat = 80
    let cornerRadius: CGFloat = 10
    let removeSize: CGFloat = 20
    let buttonPadding: CGFloat = -3
    let imageSpacing: CGFloat = 10
    let horizonPadding: CGFloat = 3
    
    // MARK: - Init
    init(
        viewModel: ViewModel,
        titleText: String,
        subTitleText: String
    ) {
        self.viewModel = viewModel
        self.titleText = titleText
        self.subTitleText = subTitleText
    }
    
    init(
        viewModel: ViewModel,
        titleText: String,
        subTitleText: String,
        maxWidth: CGFloat,
        maxHeight: CGFloat
    ) {
        self.viewModel = viewModel
        self.titleText = titleText
        self.subTitleText = subTitleText
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: contentsVspacing, content: {
            topContents
            cameraAlbum
        })
    }
    
    /// 상단 타이틀
    private var topContents: some View {
        VStack(alignment: .leading, spacing: titleVSpacing, content: {
            Text(titleText)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .lineSpacing(lineSpacing)
            
            Text(subTitleText)
                .font(.Body5_medium)
                .foregroundStyle(Color.gray400)
        })
    }
    
    /// 카메라 앨범 선택 버튼
    private var cameraAlbum: some View {
        HStack(alignment: .top, spacing: cameraHspacing, content: {
            CameraButton(cameraText: Text("\(viewModel.selectedImageCount) / \(maxImageCount)"), action: {
                if viewModel.selectedImageCount <= maxImageCount - 1 {
                    viewModel.isImagePickerPresented.toggle()
                }
            })
            
            showSelectedImage
        })
    }
    
    /// 선택된 이미지 보이기
    private var showSelectedImage: some View {
        ScrollView(.horizontal, content: {
            LazyHStack(spacing: imageSpacing, content: {
                ForEach(0..<viewModel.getImages().count, id: \.self) { index in
                    imageAddAndRemove(for: index, image: viewModel.getImages()[index])
                }
            })
        })
        .contentMargins(.bottom, UIConstants.horizonScrollBottomPadding, for: .scrollContent)
        .contentMargins([.horizontal, .top], horizonPadding, for: .scrollContent)
    }
}

extension RegistAlbumImageView {
    func imageAddAndRemove(for index: Int, image: UIImage) -> some View {
        ZStack(alignment: .topLeading, content: {
            Image(uiImage: image)
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.clear)
                        .stroke(Color.gray200, style: .init())
                })
            
            Button(action: {
                viewModel.removeImage(at: index)
            }, label: {
                Image(.imageRemove)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: removeSize, height: removeSize)
                    .padding([.horizontal, .vertical], buttonPadding)
            })
        })
    }
}
