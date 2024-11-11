//
//  JournalRegistImages.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct JournalRegistImages: View {
    
    @ObservedObject var viewModel: JournalRegistViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text("사진을 등록해주시면 \n따끈 AI 진단에서 더 정확한 결과를 받을 수 있어요")
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
                .frame(height: 36)
            
            Text("최대 5장")
                .font(.Body5_medium)
                .foregroundStyle(Color.gray400)
            
            Spacer().frame(height: 8)
            
            cameraAlbum
        })
        .frame(maxWidth: 355, alignment: .leading)
        .sheet(isPresented: $viewModel.isImagePickerPresented, content: {
            ImagePicker(imageHandler: viewModel, selectedLimit: (5 - viewModel.selectedImageCount))
        })
    }
    
    private var cameraAlbum: some View {
        HStack(alignment: .top, spacing: 4, content: {
            cameraButton
            showSelectedImage
        })
    }
    
    private var cameraButton: some View {
        Button(action: {
            if viewModel.selectedImageCount <= 4 {
                viewModel.showImagePicker()
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.answerBg)
                    .stroke(Color.gray200)
                    .frame(width: 80, height: 80)
                VStack(alignment: .center, spacing: 5, content: {
                    Icon.camera.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 47, height: 47)
                    
                    Text("\(viewModel.selectedImageCount) / 5")
                        .font(.Body5_medium)
                        .foregroundStyle(Color.gray400)
                })
            }
        })
    }
    
    private var showSelectedImage: some View {
        ScrollView(.horizontal, content: {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 75)), count: 3), content: {
                ForEach(0..<viewModel.getImages().count, id: \.self) { index in
                    imageAddAndRemove(for: index, image: viewModel.getImages()[index])
                }
            })
        })
    }
}

extension JournalRegistImages {
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
        .frame(width: 87, height: 86)
    }
}

struct JournalRegistImages_Preview: PreviewProvider {
    static var previews: some View {
        JournalRegistImages(viewModel: JournalRegistViewModel())
    }
}
