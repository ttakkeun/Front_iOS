//
//  WriteFormConfig.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/9/25.
//

import Foundation

struct WriteFormConfig {
    var naviTitle: String
    var stepPath: String
    var bodyTitle: String?
    var placeholder: String?
    var textValue: String?
    var showEmailField: Bool
    var emailValue: String?
    var buttonType: InquireReportBtnType?
    var showConsent: Bool
    var isReadOnly: Bool
    var maxImageCount: Int = 3
}
