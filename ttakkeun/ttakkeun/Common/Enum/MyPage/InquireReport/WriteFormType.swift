//
//  WriteFormType.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/9/25.
//

import Foundation

enum WriteFormType: Equatable {
    case myInquireDetail(inquireText: String, email: String, imageUrl: [String])
    case writeInquire(path: InquireType)
    case writeReport
    
    var config: WriteFormConfig {
        switch self {
        case .myInquireDetail(
            let inquireText,
            let email,
            _
        ):
            return .init(
                naviTitle: "문의하기",
                stepPath: "문의하기 > 내가 문의한 내용 확인하기",
                bodyTitle: nil,
                placeholder: nil,
                textValue: inquireText,
                showEmailField: true,
                emailValue: email,
                showConsent: false,
                isReadOnly: true
            )
        case .writeInquire(let path):
            return .init(
                naviTitle: "문의하기",
                stepPath: "문의하기 > \(path.text)",
                bodyTitle: "문의내용을 적어주세요",
                placeholder: "최대 300자 이내",
                showEmailField: true,
                buttonType: .inquire,
                showConsent: true,
                isReadOnly: false
            )
        case .writeReport:
            return .init(
                naviTitle: "신고하기",
                stepPath: "신고하기 > 기타 신고 내용 작성하기",
                bodyTitle: "신고 내용을 작성해주세요",
                placeholder: "신고 내용은 문제를 신속히 파악하고 해결하는 데 큰 도움이 됩니다.",
                showEmailField: false,
                buttonType: .report,
                showConsent: false,
                isReadOnly: false
            )
        }
    }
}
