//
//  AppInfoType.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/9/25.
//

import Foundation

enum AppInfoType: CaseIterable {
    case service
    case privacy
    case marketing
    
    var title: String {
        switch self {
        case .service:
            return "서비스 이용 약관"
        case .privacy:
            return  "개인정보 수집 및 이용 동의서"
        case .marketing:
            return  "마케팅 정보 수신 동의서"
        }
    }
    
    var param: AgreementData {
        switch self {
        case .service:
            return AgreementDetailData.loadAgreements()[0]
        case .privacy:
            return AgreementDetailData.loadAgreements()[1]
        case .marketing:
            return AgreementDetailData.loadAgreements()[2]
        }
    }
}
