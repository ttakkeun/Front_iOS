//
//  MyInquireConfirmView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/20/24.
//

import SwiftUI
import Kingfisher

struct MyInquireConfirmView: View {
    
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: MyPageViewModel
    
    //TODO: - 뷰모델 필요
    var inquiryResponse: MyInquiryResponse
    
    init(container: DIContainer, inquiryResponse: MyInquiryResponse) {
        self._viewModel = .init(wrappedValue: .init(container: container))
        self.inquiryResponse = inquiryResponse
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
            
            //TODO: - 사진 선택하면 선택한 사진을 일렬로 배치할 수 있도록 해야 함, 오빠 코드 참고해서 하긴 했는데, 확인 부탁
            if !inquiryResponse.imageUrl.isEmpty {
                ScrollView(.horizontal, content: {
                    LazyHGrid(rows: Array(repeating: GridItem(.fixed(80)), count: 1), content: {
                        ForEach(inquiryResponse.imageUrl, id: \.self) { image in
                            if let url = URL(string: image) {
                                KFImage(url)
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
                .frame(maxWidth: 312, maxHeight: 80)
                .padding(.horizontal, 3)
            } else {
                EmptyView()
            }
        })
    }
    
    private var emailCheck: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            makeTitle(title: "연락 받을 이메일")
        
            CustomTextField(text: .constant(inquiryResponse.email), placeholder: "", cornerRadius: 10, maxWidth: 351, maxHeight: 56)
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
    
    private static let inquiryData = MyInquiryResponse(
        contents: "이러저러해서 이런저런점이 불만이에요",
        email: "alkfe@naver.com",
        inquiryType: "서비스 이용문의",
        imageUrl: [
            "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
            "https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMzExMDFfMTQg%2FMDAxNjk4ODA3NjI2MzA3.6qhR_i6-hxPfRDzIR7bWHOwJHaHT2TuWCAtPdr2hs5wg.QlJ16FQF5KoWbuzUeDqteoLYW2UgPm-YTLF700V-4fQg.JPEG.iansnap%2F%25BF%25F8%25BA%25BB_%2528276%2529.jpg&type=sc960_832"
        ],
        created_at: "24.07.15"
    )
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            MyInquireConfirmView(container: DIContainer(), inquiryResponse: inquiryData)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}



