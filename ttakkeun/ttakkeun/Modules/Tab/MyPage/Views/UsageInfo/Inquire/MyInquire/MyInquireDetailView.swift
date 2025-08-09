//
//  MyInquireConfirmView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/20/24.
//

import SwiftUI
import Kingfisher

struct MyInquireDetailView: View {
    
    @EnvironmentObject var container: DIContainer
    var inquiryResponse: MyInquiryResponse
    
    init(inquiryResponse: MyInquiryResponse) {
        self.inquiryResponse = inquiryResponse
    }
    
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
            
            TextEditor(text: .constant(inquiryResponse.contents))
                .customStyleTipsEditor(text: .constant(inquiryResponse.contents), placeholder: "", maxTextCount: 300, backColor: Color.white)
                .disabled(true)
                .frame(width: 351, height: 200)
            
        })
    }
    
    private var imageAdd: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            makeTitle(title: "이미지 첨부")
            
            if !inquiryResponse.imageUrl.isEmpty {
                ScrollView(.horizontal, content: {
                    LazyHGrid(rows: Array(repeating: GridItem(.fixed(80)), count: 1), content: {
                        ForEach(inquiryResponse.imageUrl, id: \.self) { image in
                            if let url = URL(string: image) {
                                KFImage(url)
                                    .placeholder {
                                        ProgressView()
                                            .controlSize(.mini)
                                    }
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray200, lineWidth: 1)
                                    )
                            }
                        }
                    })
                })
                .frame(maxWidth: 351, maxHeight: 80)
                .padding(.horizontal, 3)
            } else {
                EmptyView()
            }
        })
    }
    
    private var emailCheck: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            makeTitle(title: "연락 받을 이메일")
        
            CustomTextField(text: .constant(""), placeholder: inquiryResponse.email, cornerRadius: 10, maxWidth: 351, maxHeight: 56)
                .disabled(true)
        })
    }
}

//MARK: - function
extension MyInquireDetailView {
    private func makeTitle(title: String) -> some View {
        Text(title)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
}
