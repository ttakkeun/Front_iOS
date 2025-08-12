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
    @State var inquiryResponse: MyInquiryResponse
    
    init(inquiryResponse: MyInquiryResponse) {
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

#Preview {
    MyInquireDetailView(inquiryResponse: .init(contents: "이 사람 이상해요", email: "eui@com", inquiryType: "11", imageUrl: [
        "https://i.namu.wiki/i/cusLffdONLphUHKfYy-UclkoCER49OYM6SW96csASHewLpoQtigXVU8__1d_Nm97MuVoNHZ382GPm8gqim_gVI0e8aqzgNECEFNhTHNowe9ItibQynXg7q6NU78kDZGFD1Y0V5k9Oeql15OQo45Qjw.webp"
    ], created_at: "111"))
}
