//
//  MyInquireConfirmView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/20/24.
//

import SwiftUI
import Kingfisher

/// 나의 문의하기 읽기 뷰
struct MyInquireDetailView: View {
    
    @EnvironmentObject var container: DIContainer
    @State var inquiryResponse: MyPageMyInquireResponse
    
    init(inquiryResponse: MyPageMyInquireResponse) {
        self.inquiryResponse = inquiryResponse
    }
    
    var body: some View {
        WriteFormView(
            textEidtor: $inquiryResponse.contents,
            emailText: .constant(nil),
            images: .constant(.init()),
            type: .myInquireDetail(inquireText: inquiryResponse.contents, email: inquiryResponse.email, imageUrl: inquiryResponse.imageUrl),
            onSubmit: nil
        )
    }
}
