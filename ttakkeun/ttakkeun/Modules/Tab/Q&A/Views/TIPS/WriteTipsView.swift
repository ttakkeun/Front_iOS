//
//  WriteTips.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/3/24.
//

import SwiftUI

struct WriteTipsView: View {
    
    @StateObject var viewModel: TipsWriteViewModel
    
    init(category: ExtendPartItem,
         container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(category: category, container: container))
    }
    
    let placeholder: String = "최대 230자까지 입력 가능합니다. \n욕설, 비방, 혐오 표현 등 부적절한 내용은 신고 대상이 될 수 있으며, 계정 제제 등의 불이익을 받을 수 있습니다. \n모두가 즐길 수 있는 커뮤니티를 위해 예의 있는 표현을 사용해주세요!"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28, content: {
            CustomNavigation(action: {
                viewModel.goToBeforePage()
            }, title: "TIP 작성", currentPage: nil)
            categoryTitle
            
            inputTextString
            
//            RegistAlbumImageView(viewModel: viewModel, maxImageCount: 3, titleText: "사진 등록(선택 사항)", subTitleText: "최대 3장", maxWidth: 353, maxHeight: 152)
            
            Spacer()
            
            MainButton(btnText: "공유하기", height: 56, action: {
                if !viewModel.title.isEmpty && !viewModel.textContents.isEmpty {
                    viewModel.writeTips()
                }
            }, color: Color.mainPrimary)
        })
        .frame(width: 353)
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .center, content: {
            if viewModel.registTipsLoading {
                    ZStack {
                        Color.black
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea(.all)
                        
                        VStack {
                            ProgressView(label: {
                                LoadingDotsText(text: "작성한 Tips를 생성 중입니다.")
                            })
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .controlSize(.large)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.8))
                    }
                }
        })
        .ignoresSafeArea(.keyboard)
        .onAppear {
            UIApplication.shared.hideKeyboard()
        }
    }
    
    private var categoryTitle: some View {
        Text(viewModel.category.toKorean())
            .frame(width: 30, height: 20)
            .font(.Body2_semibold)
            .foregroundStyle(Color.gray900)
            .padding(.vertical, 4)
            .padding(.horizontal, 22)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(viewModel.category.afterToColor())
            }
    }
    
    private var inputTextString: some View {
        VStack(spacing: 10, content: {
            TextField("tipTitle", text: $viewModel.title, prompt: createTitleText())
                .foregroundStyle(Color.gray900)
            
            Divider()
                .foregroundStyle(Color.gray200)
            
            TextEditor(text: $viewModel.textContents)
                .customStyleTipsEditor(text: $viewModel.textContents, placeholder: placeholder, maxTextCount: 230, border: Color.clear)
                .frame(maxHeight: 257)
        })
    }
}

extension WriteTipsView {
    func createTitleText() -> Text {
        Text("제목을 입력해주세요")
            .font(.H3_semiBold)
            .foregroundStyle(Color.gray200)
    }
}

struct WriteTipsView_Preview: PreviewProvider {
    static var previews: some View {
        WriteTipsView(category: .part(.claw), container: DIContainer())
    }
}
