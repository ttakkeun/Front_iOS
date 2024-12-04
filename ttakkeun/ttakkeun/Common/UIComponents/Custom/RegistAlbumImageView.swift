//
//  RegistAlbumImageView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct RegistAlbumImageView<ViewModel: ImageHandling & ObservableObject>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    let maxImageCount: Int
    let titleText: String
    let subTitleText: String
    
    init(
        viewModel: ViewModel,
        maxImageCount: Int = 5,
        titleText: String,
        subTitleText: String
    ) {
        self.viewModel = viewModel
        self.maxImageCount = maxImageCount
        self.titleText = titleText
        self.subTitleText = subTitleText
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8, content: {
            Text(titleText)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
                .lineSpacing(2)
            
            Text(subTitleText)
                .font(.Body5_medium)
                .foregroundStyle(Color.gray400)
            
            Spacer().frame(height: 2)
            
            cameraAlbum
        })
        .frame(maxWidth: 355, alignment: .leading)
        .sheet(isPresented: $viewModel.isImagePickerPresented, content: {
            ImagePicker(imageHandler: viewModel, selectedLimit: (maxImageCount - viewModel.selectedImageCount))
        })
    }
    
    private var cameraAlbum: some View {
        HStack(alignment: .top, spacing: 4, content: {
            CameraButton(cameraText: Text("\(viewModel.selectedImageCount) / \(maxImageCount)"), action: {
                if viewModel.selectedImageCount <= maxImageCount - 1 {
                    viewModel.showImagePicker()
                }
            })
            showSelectedImage
        })
    }
    
    private var showSelectedImage: some View {
        ScrollView(.horizontal, content: {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(80), spacing: 10) ,count: 3), spacing: 10, content: {
                ForEach(0..<viewModel.getImages().count, id: \.self) { index in
                    imageAddAndRemove(for: index, image: viewModel.getImages()[index])
                }
            })
            .frame(alignment: .topLeading)
            .padding(.top, 5)
            .padding(.bottom, 8)
            .padding(.horizontal, 3)
        })
    }
}

extension RegistAlbumImageView {
    func imageAddAndRemove(for index: Int, image: UIImage) -> some View {
        ZStack(alignment: .topLeading, content: {
            Image(uiImage: image)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color.gray200, lineWidth: 1)
                })
            
            Button(action: {
                viewModel.removeImage(at: index)
            }, label: {
                Icon.imageRemove.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding([.horizontal, .vertical], -3)
            })
        })
        .frame(width: 80, height: 80)
    }
}
