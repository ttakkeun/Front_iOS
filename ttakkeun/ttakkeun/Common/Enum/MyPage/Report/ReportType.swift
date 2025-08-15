//
//  ReportBtn.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/12/25.
//

import Foundation

enum ReportType: CaseIterable, Codable {
    case spam
    case inappropriate
    case falseInformation
    case animalAbuse
    case copyRight
    case exposureInformation
    case defamation
    case cheating
    case etcReport
    
    var text: String {
        switch self {
        case .spam:
            return "스팸/광고"
        case .inappropriate:
            return "부적절한 컨텐츠"
        case .falseInformation:
            return "허위 정보"
        case .animalAbuse:
            return "반려동물 학대"
        case .copyRight:
            return "저작권 침해"
        case .exposureInformation:
            return "개인 정보 노출"
        case .defamation:
            return "비방 및 혐오 표현"
        case .cheating:
            return "부정 행위"
        case .etcReport:
            return "기타 신고 내용 작성하기"
        }
    }
    
    var param: ReportType {
        switch self {
        case .spam:
            return .spam
        case .inappropriate:
            return .inappropriate
        case .falseInformation:
            return .falseInformation
        case .animalAbuse:
            return .animalAbuse
        case .copyRight:
            return .copyRight
        case .exposureInformation:
            return .exposureInformation
        case .defamation:
            return .defamation
        case .cheating:
            return .cheating
        case .etcReport:
            return .etcReport
        }
    }
    
    var subItems: [Any]? {
        switch self {
        case .spam:
            return SpamItems.allCases
        case .inappropriate:
            return InappropriateItems.allCases
        case .falseInformation:
            return FalseInformationItems.allCases
        case .animalAbuse:
            return AnimalAbuseItems.allCases
        case .copyRight:
            return CopyRightItems.allCases
        case .exposureInformation:
            return ExposureInformationItems.allCases
        case .defamation:
            return DefamationItems.allCases
        case .cheating:
            return CheatingItems.allCases
        case .etcReport:
            return nil
        }
    }
}
