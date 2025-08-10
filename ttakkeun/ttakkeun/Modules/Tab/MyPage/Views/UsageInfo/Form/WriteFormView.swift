//
//  WriteFormView.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/9/25.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct WriteFormView: View {
    
    // MARK: - Property
    @Binding var textEidtor: String
    let type: WriteFormType
    let onSubmit: (@Sendable () async throws -> Void)?
    
    
    @State var showPhotoPicker: Bool = false
    @State var photoPickerItems: [PhotosPickerItem] = .init()
    @Binding var images: [UIImage]
    
    // MARK: - Constants
    fileprivate enum WriteFormConstants {
        static let middleContentsVspacing: CGFloat = 17
        static let imageHspacing: CGFloat = 13
        static let imageSelectPadding: EdgeInsets = .init(top: 5, leading: 17, bottom: 5, trailing: 17)
        
        static let textEditorHeight: CGFloat = 200
        static let readOnlyImageSize: CGSize = .init(width: 80, height: 80)
        
        static let maxCount: Int = 300
        static let maxImageCount: Int = 2
        static let maxImageTime: TimeInterval = 2
        static let cornerRadius: CGFloat = 10
        static let imageSelectedCornerRadius: CGFloat = 40
        
        static let imageTitle: String = "이미지 첨부"
        static let imageSelect: String = "이미지 선택하기"
    }
    
    // MARK: - Body
    var body: some View {
        imageContents
            .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItems, maxSelectionCount: type.config.maxImageCount ,matching: .images)
            .onChange(of: photoPickerItems, { old, new in
                Task {
                    for item in new {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            images.append(image)
                        }
                    }
                    photoPickerItems.removeAll()
                }
            })
    }
    
    //MARK: - TopContents
    /// 상단 카테고리 패스
    private var topContents: some View {
        Text(type.config.naviTitle)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray400)
    }
    
    // MARK: - MiddleContents
    private var middleContents: some View {
        VStack(alignment: .leading, spacing: WriteFormConstants.middleContentsVspacing, content: {
            
        })
    }
    
    /// 텍스트 내용 작성 구간
    private var writeTextEditor: some View {
        VStack(alignment: .leading, spacing: WriteFormConstants.middleContentsVspacing, content: {
            firstBodyTitle
            TextEditor(text: $textEidtor)
                .customInquireStyleEditor(text: $textEidtor, placeholder: type.config.placeholder ?? "")
                .frame(height: WriteFormConstants.textEditorHeight)
                .disabled(type.config.isReadOnly)
        })
    }
    
    // MARK: - Title
    /// 텍스트 입력 바디 타이틀
    @ViewBuilder
    private var firstBodyTitle: some View {
        if let body = type.config.bodyTitle {
            bodyTitle(body)
        }
    }
    
    /// 중복되는 섹션 타이틀 생성
    /// - Parameter body: 타이틀 표시
    /// - Returns: 뷰 반환
    private func bodyTitle(_ body: String) -> some View {
        Text(body)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    // MARK: - Image
    /// 중간 이미지 컨텐츠
    @ViewBuilder
    private var imageContents: some View {
        VStack(alignment: .leading, spacing: WriteFormConstants.middleContentsVspacing, content: {
            bodyTitle(WriteFormConstants.imageTitle)
            
            if type.config.isReadOnly {
                readOnlyImage
            } else {
                showImagePickerButton
                photoGrid
            }
        })
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// 이미지 선택하기 버튼
    private var showImagePickerButton: some View {
        Button(action: {
            showPhotoPicker.toggle()
        }, label: {
            Text(WriteFormConstants.imageSelect)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
                .padding(WriteFormConstants.imageSelectPadding)
                .background {
                    RoundedRectangle(cornerRadius: WriteFormConstants.imageSelectedCornerRadius)
                        .fill(Color.clear)
                        .stroke(Color.gray400, style: .init())
                }
        })
    }
    
    /// 선택한 이미지 스택으로 생성하기
    private var photoGrid: some View {
        HStack(spacing: WriteFormConstants.imageHspacing, content: {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: WriteFormConstants.readOnlyImageSize.width, height: WriteFormConstants.readOnlyImageSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: WriteFormConstants.cornerRadius))
            }
        })
    }
    
    /// 내 문의 보기 시, 이미지 불러오기
    @ViewBuilder
    private var readOnlyImage: some View {
        if case let .myInquireDetail(_, _, imageUrl) = type {
            HStack(spacing: WriteFormConstants.imageHspacing, content: {
                ForEach(imageUrl, id: \.self) { image in
                    kingfisherImage(url: image)
                }
            })
        }
    }
    
    /// kingFisher로 가져오는 이미지 사용
    /// - Parameter url: kingFisher 이미지 URL
    /// - Returns: 이미지 반환
    @ViewBuilder
    private func kingfisherImage(url: String) -> some View {
        if let url = URL(string: url) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                }.retry(maxCount: WriteFormConstants.maxImageCount, interval: .seconds(WriteFormConstants.maxImageTime))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: WriteFormConstants.readOnlyImageSize.width, height: WriteFormConstants.readOnlyImageSize.height)
                .background {
                    RoundedRectangle(cornerRadius: WriteFormConstants.cornerRadius)
                        .fill(Color.clear)
                        .stroke(Color.gray500, style: .init())
                }
        }
    }
}

#Preview {
    @Previewable @State var text: String = "hello"
    @Previewable @State var images: [UIImage] = .init()
    WriteFormView(
                    textEidtor: $text,
                    type: .writeReport,
                    onSubmit: {
                        print("submit inquiry: \(text)")
                    },
                    images: $images
                )
}
