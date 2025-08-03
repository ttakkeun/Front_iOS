//
//  WriteTips.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/3/24.
//

import SwiftUI
import PhotosUI

struct WriteTipsView: View {
    
    // MARK: - Property
    @State var viewModel: TipsWriteViewModel
    @FocusState var writeTipstype: WriteTipsTextType?
    
    // MARK: - Constants
    fileprivate enum WriteTipsConstants {
        static let mainContentsVspacing: CGFloat = 17
        static let middleTextInputVspacing: CGFloat = 10
        static let middleContetnsVspacing: CGFloat = 20
        
        static let downKeyboardSize: CGSize = .init(width: 18, height: 18)
        static let categoryBgSize: CGSize = .init(width: 58, height: 28)
        static let textEditorHeight: CGFloat = 210
        static let mainBtnHeight: CGFloat = 56
        
        static let cornerRadius: CGFloat = 10
        static let maxTextCount: Int = 230
        static let maxImageCount: Int = 3
        
        static let downKeyboardImage: String = "chevron.down"
        static let titleText: String = "사진 등록(선택 사항)"
        static let subTitleText: String = "최대 3장"
        static let closeBtn: String = "xmark"
        static let naviTitle: String = "TIP 작성"
        static let mainBtnText: String = "공유하기"
        static let textFieldTitle: String = "제목을 입력해주세요"
        static let placeholder: String = "최대 230자까지 입력 가능합니다. \n욕설, 비방, 혐오 표현 등 부적절한 내용은 신고 대상이 될 수 있으며, 계정 제제 등의 불이익을 받을 수 있습니다. \n모두가 즐길 수 있는 커뮤니티를 위해 예의 있는 표현을 사용해주세요!"
    }
    
    // MARK: - Init
    init(category: ExtendPartItem, container: DIContainer) {
        self.viewModel = .init(category: category, container: container)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: WriteTipsConstants.mainContentsVspacing, content: {
                topContents
                middleContents
                Spacer()
                bottomContents
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .customNavigation(title: WriteTipsConstants.naviTitle, leadingAction: {
                viewModel.container.navigationRouter.pop()
            }, naviIcon: Image(systemName: WriteTipsConstants.closeBtn))
            .keyboardToolbar(downAction: {
                writeTipstype = nil
            })
            .ignoresSafeArea(.keyboard)
            .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
            .loadingOverlay(isLoading: viewModel.registTipsLoading, loadingTextType: .createTips)
            .photosPicker(
                isPresented: $viewModel.isImagePickerPresented,
                selection: $viewModel.imageItems,
                maxSelectionCount: WriteTipsConstants.maxImageCount,
                matching: .images
            )
            .onChange(of: viewModel.imageItems, { old, new in
                viewModel.convertPickerItemsToUIImages(items: new)
            })
            .task {
                UIApplication.shared.hideKeyboard()
            }
        }
    }
    
    // MARK: - TopContents
    /// 카테고리 타이틀 태그
    private var topContents: some View {
        ZStack {
            RoundedRectangle(cornerRadius: WriteTipsConstants.cornerRadius)
                .fill(viewModel.category.afterToColor())
                .frame(width: WriteTipsConstants.categoryBgSize.width, height: WriteTipsConstants.categoryBgSize.height)
            
            Text(viewModel.category.toKorean())
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
        }
    }
    
    // MARK: - MiddleContents
    /// 텍스트 입력 및 사진 추가 컨텐츠
    private var middleContents: some View {
        VStack(alignment: .leading, spacing: WriteTipsConstants.middleContetnsVspacing, content: {
            middleTextInputView
            RegistAlbumImageView(viewModel: viewModel, titleText: WriteTipsConstants.titleText, subTitleText: WriteTipsConstants.subTitleText, maxImageCount: WriteTipsConstants.maxImageCount)
        })
    }
    
    /// 중간 텍스트 입력 컨텐츠
    private var middleTextInputView: some View {
        VStack(spacing: WriteTipsConstants.middleTextInputVspacing, content: {
            TextField("", text: $viewModel.title, prompt: createTitleText())
                .font(.H3_semiBold)
                .foregroundStyle(Color.gray900)
                .background(Color.clear)
                .submitLabel(.continue)
                .focused($writeTipstype, equals: .title)
                .onSubmit {
                    writeTipstype = .subContents
                }
            
            TextEditor(text: $viewModel.textContents)
                .customStyleTipsEditor(text: $viewModel.textContents, placeholder: WriteTipsConstants.placeholder, maxTextCount: WriteTipsConstants.maxTextCount, border: Color.clear)
                .frame(maxHeight: WriteTipsConstants.textEditorHeight)
                .focused($writeTipstype, equals: .subContents)
        })
    }
    
    // MARK: - BottomContents
    /// 하단 공유하기 버튼
    private var bottomContents: some View {
        MainButton(btnText: WriteTipsConstants.mainBtnText, height: WriteTipsConstants.mainBtnHeight, action: {
            if !viewModel.title.isEmpty && !viewModel.textContents.isEmpty {
                viewModel.writeTips()
            }
        }, color: Color.mainPrimary)
        .ignoresSafeArea(.keyboard)
    }
}

extension WriteTipsView {
    func createTitleText() -> Text {
        Text(WriteTipsConstants.textFieldTitle)
            .font(.H3_semiBold)
            .foregroundStyle(Color.gray200)
    }
}

#Preview {
    WriteTipsView(category: .part(.claw), container: DIContainer())
}
