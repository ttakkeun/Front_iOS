//
//  Diagnostic images.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/6/24.
//

import SwiftUI

/// 일지 생성 시 사용하는 이미지 추가 버튼
struct DiagnosticImages: View {
    
    @ObservedObject var viewModel: RegistJournalViewModel
    
    var body: some View {
        imageTitle
            .sheet(isPresented: $viewModel.isImagePickerPresented, content: {
                PetImagePicker(imageHandler: viewModel)
                    .ignoresSafeArea(.all)
            })
    }
    
    // MARK: - ImageContents
    
    private var imageTitle: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("사진을 등록해주사면 \n따끈 AI 진단에서 더 정확한 결과를 받을 수 있어요")
                .font(.Body3_medium)
                .foregroundStyle(Color.gray_900)
            
            Text("최대 5장")
                .font(.Body5_medium)
                .foregroundStyle(Color.gray_400)
            
            Spacer().frame(height: 11)
            
            cameraBtn
        }
        .frame(maxWidth: 277)
    }
    
    /// 사진 등록 카메라 버튼
    private var cameraBtn: some View {
        Button(action: {
            viewModel.showImagePicker()
        }, label: {
            HStack(alignment: .top, spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.scheduleCard_Color)
                        .stroke(Color.gray_200)
                        .frame(width: 80, height: 80)
                    VStack(alignment: .center, spacing: 5, content: {
                        Icon.petCamera.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 47, height: 47)
                        
                        Text("\(viewModel.selectedImageCount) / 5")
                            .font(.Body3_regular)
                            .foregroundStyle(Color.gray_400)
                    })
                   
                }
                showSelectedImage
            }
            .frame(height: 180)
        })
    }
    
    private func imageAddAndRemove(for index: Int, image: UIImage) -> some View {
        ZStack(alignment: .topLeading, content: {
            Image(uiImage: image)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color.gray_200, lineWidth: 1)
                )
            
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
        .frame(width: 86, height: 86)
    }
    
    private var showSelectedImage: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(80)), count: 2), content: {
                ForEach(0..<viewModel.getImages().count, id: \.self) { index in
                    imageAddAndRemove(for: index, image: viewModel.getImages()[index])
                }
            })
            .padding(.horizontal, 5)
        })
    }
}

struct DiagnosticImages_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosticImages(viewModel: RegistJournalViewModel(petId: 0))
            .previewLayout(.sizeThatFits)
    }
}
