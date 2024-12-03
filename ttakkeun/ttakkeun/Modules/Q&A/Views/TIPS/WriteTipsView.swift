//
//  WriteTips.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/3/24.
//

import SwiftUI

struct WriteTipsView: View {
    
    @StateObject var viewModel: TipsWriteViewModel
    
    let placeholder: String = "최대 230자까지 입력 가능합니다. \n욕설, 비방, 혐오 표현 등 부적절한 내용은 신고 대상이 될 수 있으며, 계정 제제 등의 불이익을 받을 수 있습니다. \n모두가 즐길 수 있는 커뮤니티를 위해 예의 있는 표현을 사용해주세요!"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28, content: {
            CustomNavigation(action: {
                viewModel.changeIsShowTipsWriteView()
            }, title: "TIP 작성", currentPage: nil)
            
            categoryTitle
            
            inputTextString
            
            RegistAlbumImageView(viewModel: viewModel, maxImageCount: 3, titleText: "사진 등록(선택 사항)", subTitleText: "최대 3장")
            
            Spacer()
            
            MainButton(btnText: "공유하기", width: 353, height: 56, action: {
                //TODO: - 공유하기 버튼 API
                viewModel.changeIsShowTipsWriteView()
            }, color: Color.mainPrimary)
        })
        .safeAreaPadding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
    }
    
    private var categoryTitle: some View {
        Text(viewModel.category?.toKorean() ?? "기타")
            .frame(width: 30, height: 20)
            .font(.Body2_semibold)
            .foregroundStyle(Color.gray900)
            .padding(.vertical, 4)
            .padding(.horizontal, 22)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(viewModel.category?.toAfterColor() ?? Color.clear)
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
                .frame(height: 257)
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
        WriteTipsView(viewModel: TipsWriteViewModel(category: .hair))
    }
}
