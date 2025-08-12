//
//  WriteFormView.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/9/25.
//

import SwiftUI
import Kingfisher
import PhotosUI

/// 문의 하기 및 신고하기 폼 뷰
struct WriteFormView: View {
    
    // MARK: - Property
    @Binding var textEidtor: String
    @Binding var emailText: String?
    @Binding var images: [UIImage]
    let type: WriteFormType
    let onSubmit: (@Sendable () async throws -> Void)?
    
    @State var showPhotoPicker: Bool = false
    @State var photoPickerItems: [PhotosPickerItem] = .init()
    @State var showAgreement: Bool = false
    @State var checkAgreement: Bool = false
    @FocusState var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Constants
    fileprivate enum WriteFormConstants {
        static let middleContentsVspacing: CGFloat = 17
        static let imageHspacing: CGFloat = 13
        static let imageSelectPadding: EdgeInsets = .init(top: 5, leading: 17, bottom: 5, trailing: 17)
        static let emailTextPadding: EdgeInsets = .init(top: 18, leading: 17, bottom: 18, trailing: 17)
        static let showAgreementPadding: EdgeInsets = .init(top: 6, leading: 21, bottom: 6, trailing: 21)
        
        static let textEditorHeight: CGFloat = 200
        static let readOnlyImageSize: CGSize = .init(width: 80, height: 80)
        static let showAgreementSize: CGSize = .init(width: 63, height: 28)
        
        static let spacerMinHeight: CGFloat = 20
        static let maxCount: Int = 300
        static let maxImageCount: Int = 2
        static let maxImageTime: TimeInterval = 2
        static let cornerRadius: CGFloat = 10
        static let imageSelectedCornerRadius: CGFloat = 40
        
        static let imageTitle: String = "이미지 첨부(최대 3장)"
        static let imageSelect: String = "이미지 선택하기"
        static let contactEmail: String = "연락 받을 이메일"
        static let notEmailText: String = "이메일 정보 없음"
        static let placeholder: String = "입력해주세요"
        static let showAgreementText: String = "보기"
        static let agreementTitle: String = "개인정보 수집 및 이용 약관 동의"
        static let agreementCheck: String = "개인정보 수집 및 이용 약관에 동의합니다."
        static let naviCloseImage: String = "xmark"
        static let scrollId: String = "bottom"
    }
    
    // MARK: - Body
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, content: {
                VStack(alignment: .leading, spacing: WriteFormConstants.middleContentsVspacing, content: {
                    topContents
                    middleContents
                    Spacer().id(WriteFormConstants.scrollId)
                })
            })
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .customNavigation(title: type.config.naviTitle, leadingAction: {
                dismiss()
            }, naviIcon: Image(systemName: WriteFormConstants.naviCloseImage))
            .safeAreaInset(edge: .bottom, content: {
                bottomMainButton
            })
            .contentMargins(.top, UIConstants.topScrollPadding, for: .scrollContent)
            .contentMargins(.horizontal, UIConstants.defaultSafeHorizon, for: .scrollContent)
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
            .onChange(of: images, { _, _ in
                proxy.scrollTo(WriteFormConstants.scrollId, anchor: .bottom)
            })
            .sheet(isPresented: $showAgreement, content: {
                AgreementSheetView()
            })
            .keyboardToolbar {
                isFocused = false
            }
        }
    }
    
    //MARK: - TopContents
    /// 상단 카테고리 패스
    private var topContents: some View {
        Text(type.config.stepPath)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray400)
    }
    
    // MARK: - Title
    /// 중복되는 섹션 타이틀 생성
    /// - Parameter body: 타이틀 표시
    /// - Returns: 뷰 반환
    private func bodyTitle(_ body: String) -> some View {
        Text(body)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    // MARK: - MiddleContents
    /// 중간 문의 내용 + 이미지 첨부 + 연락 받을 이메일
    private var middleContents: some View {
        VStack(alignment: .leading, spacing: WriteFormConstants.middleContentsVspacing, content: {
            writeTextEditor
            imageContents
            emailContents
            Spacer(minLength: WriteFormConstants.spacerMinHeight)
            agreementContents
        })
    }
    
    /// 문의 내용 작성 부분
    private var writeTextEditor: some View {
        VStack(alignment: .leading, spacing: WriteFormConstants.middleContentsVspacing, content: {
            if let body = type.config.bodyTitle {
                bodyTitle(body)
            }
            TextEditor(text: $textEidtor)
                .customInquireStyleEditor(text: $textEidtor, placeholder: type.config.placeholder ?? "")
                .frame(height: WriteFormConstants.textEditorHeight)
                .disabled(type.config.isReadOnly)
                .focused($isFocused)
        })
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
        .disabled(!imageCondition)
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
    
    private var imageCondition: Bool {
        return images.count < 3
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
                .clipShape(RoundedRectangle(cornerRadius: WriteFormConstants.cornerRadius))
        }
    }
    
    // MARK: - Email
    /// 문의하기 및 내 문의하기 작성 시 사용하는 이메일 주소 입력
    @ViewBuilder
    private var emailContents: some View {
        if type.config.showEmailField {
            VStack(alignment: .leading, spacing: WriteFormConstants.middleContentsVspacing, content: {
                bodyTitle(WriteFormConstants.contactEmail)
                emailTextView
                    .font(.Body2_medium)
                    .foregroundStyle(Color.gray900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(WriteFormConstants.emailTextPadding)
                    .background {
                        RoundedRectangle(cornerRadius: WriteFormConstants.cornerRadius)
                            .fill(Color.clear)
                            .stroke(Color.gray200, style: .init())
                    }
            })
        }
    }
    
    /// 텍스트 입력 부분인지, 값을 보는 부분인지 구분
    @ViewBuilder
    private var emailTextView: some View {
        if type.config.isReadOnly {
            Text(type.config.emailValue ?? WriteFormConstants.notEmailText)
        } else {
            TextField("", text: Binding(
                get: { emailText ?? "" },
                set: { emailText = $0} ), prompt: placeholder
            )
                .keyboardType(.emailAddress)
                .focused($isFocused)
        }
    }
    
    /// 연락 받을 이메일 placeholder
    private var placeholder: Text {
        Text(WriteFormConstants.placeholder)
            .font(.Body2_medium)
            .foregroundStyle(Color.gray400)
    }
    
    // MARK: - Agreement
    /// 개인정보 수집 및 이용 약관 동의
    @ViewBuilder
    private var agreementContents: some View {
        if type.config.showConsent {
            VStack(alignment: .leading, spacing: WriteFormConstants.middleContentsVspacing, content: {
                agreementTitle
                checkAgreementContent
            })
        }
    }
    /// 개인정보 수집 동의 타이틀 및 보기
    private var agreementTitle: some View {
        HStack {
            bodyTitle(WriteFormConstants.agreementTitle)
            Spacer()
            showAgreementBtn
        }
    }
    /// 이용 약관 동의 보기 버튼
    private var showAgreementBtn: some View {
        Button(action: {
            showAgreement.toggle()
        }, label: {
            Text(WriteFormConstants.showAgreementText)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
                .padding(WriteFormConstants.showAgreementPadding)
                .background {
                    RoundedRectangle(cornerRadius: WriteFormConstants.cornerRadius)
                        .fill(Color.checkBg)
                        .frame(width: WriteFormConstants.showAgreementSize.width, height: WriteFormConstants.showAgreementSize.height)
                }
        })
    }
    
    /// 하단 개인정보 수집 및 허용 체크 사항
    private var checkAgreementContent: some View {
        HStack {
            Button(action: {
                checkAgreement.toggle()
            }, label: {
                checkAgreement ? Image(.check) : Image(.uncheck)
            })
            
            Text(WriteFormConstants.agreementCheck)
                .font(.Body2_medium)
                .foregroundStyle(Color.gray400)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - Bottom
    /// 하단 제출 관련 버튼
    @ViewBuilder
    private var bottomMainButton: some View {
        if let btnType = type.config.buttonType {
            MainButton(btnText: btnType.text, height: btnType.height, action: {
                if checkAgreement {
                    Task {
                        do {
                            try await onSubmit?()
                        } catch {
                            print("문의 및 신고하기 제출 실패: \(error)")
                        }
                    }
                }
            }, color: btnType.color)
            .padding(.horizontal, UIConstants.defaultSafeHorizon)
        }
    }
}
