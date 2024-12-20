//
//  MyInquireConfirmView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/20/24.
//

import SwiftUI

struct MyInquireConfirmView: View {
    
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: MyPageViewModel
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    //TODO: 임시변수! 뷰모델로 실제 데이터 불러와야 함
    @State private var content: String = "이러저러해서 이런저런점이 불만이에요"
    @State private var email: String = "alkfe@naver.com"
    
    var body: some View {
        VStack(alignment: .center, spacing: 25, content: {
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "문의하기",
                             currentPage: nil)
            
            reportContent
            
            emailCheck
            
            Spacer()
        })
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
    }
    
    //MARK: - Components
    ///정보 입력 필드
    private var reportContent: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            //TODO: - '>' 뒤에 카테고리는 앞에 뷰에서 어떤 버튼을 선택하느냐에 따라 달라져야함
            Text("문의하기 > 내가 문의한 내용 확인하기")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
            
            reportDetail
            
            imageAdd
        })
    }
    
    
    /// 신고 내용
    private var reportDetail: some View {
        VStack(alignment: .leading, spacing: 18,content: {
            makeTitle(title: "문의 내용")
            
            TextEditor(text: $content)
                .customStyleTipsEditor(text: $content, placeholder: "", maxTextCount: 300, backColor: Color.white)
                .disabled(true)
                .frame(width: 351, height: 200)
            
        })
    }
    
    private var imageAdd: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            makeTitle(title: "이미지 첨부")
            
            //TODO: - 사진 선택하면 선택한 사진을 일렬로 배치할 수 있도록 해야 함
        })
    }
    
    private var emailCheck: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            makeTitle(title: "연락 받을 이메일")
        
            CustomTextField(text: $email, placeholder: "", cornerRadius: 10, maxWidth: 351, maxHeight: 56)
                .disabled(true)
            
        })
    }
}

//MARK: - Data Structure
private struct FieldGroup {
    let title: String
    let text: Binding<String>
}

//MARK: - function
extension MyInquireConfirmView {
    private func makeTitle(title: String) -> some View {
        Text(title)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
}

//MARK: - Preview
struct MyInquireConfirmView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            MyInquireConfirmView(container: DIContainer())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}



