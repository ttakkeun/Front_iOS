//
//  ReportItem.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/12/25.
//

import Foundation

protocol ItemsText {
    var text: String { get }
}

enum SpamItems: CaseIterable, ItemsText {
    case commercialAd // 상업적인 광고글
    case promotionalPost // 홍보성 게시글
    case repeatedSpam // 반복적인 스팸
    case harmfulLink //유해 링크
    
    var text: String {
        switch self {
        case .commercialAd:
            return "상업적인 광고글"
        case .promotionalPost:
            return "홍보성 게시글"
        case .repeatedSpam:
            return "반복적인 스팸"
        case .harmfulLink:
            return "유해 링크"
        }
    }
}

enum InappropriateItems: CaseIterable, ItemsText {
    case abusiveLanguage // 욕설 및 폭언
    case unrelatedContent // 반려동물과 무관한 부적절한 내용
    case explicitOrOffensiveImage // 선정적/불쾌한 이미지
    
    var text: String {
        switch self {
        case .abusiveLanguage:
            return "욕설 및 폭언"
        case .unrelatedContent:
            return "반려동물과 무관한 부적절한 내용"
        case .explicitOrOffensiveImage:
            return "선정적/불쾌한 이미지"
        }
    }
}

enum FalseInformationItems: CaseIterable, ItemsText {
    case baselessInfo // 근거가 없는 잘못된 정보
    case unprofessionalAndHarmful // 반려동물에게 해가 될 수 있는 비전문적 정보
    case exaggeratedOrManipulated // 과장되거나 조작된 정보
    
    var text: String {
        switch self {
        case .baselessInfo:
            return "근거가 없는 잘못된 정보"
        case .unprofessionalAndHarmful:
            return "반려동물에게 해가 될 수 있는 비전문적 정보"
        case .exaggeratedOrManipulated:
            return "과장되거나 조작된 정보"
        }
    }
}

enum AnimalAbuseItems: CaseIterable, ItemsText {
    case abuseScene // 학대 장면 포함
    case encouragementOrAiding // 학대 조장 또는 방조
    case neglectOrIllegalAct // 방치 또는 불법 행위
    
    var text: String {
        switch self {
        case .abuseScene:
            return "학대 장면 포함"
        case .encouragementOrAiding:
            return "학대 조장 또는 방조"
        case .neglectOrIllegalAct:
            return "방치 또는 불법 행위"
        }
    }
}

enum CopyRightItems: CaseIterable, ItemsText {
    case unauthorizedImageUse // 무단 이미지 사용
    case unauthorizedCopyOrPlagiarism // 무단 복제 및 도용
    
    var text: String {
        switch self {
        case .unauthorizedImageUse:
            return "무단 이미지 사용"
        case .unauthorizedCopyOrPlagiarism:
            return "무단 복제 및 도용"
        }
    }
}

enum ExposureInformationItems: CaseIterable, ItemsText {
    case contactExposure // 연락처 공개
    case addressExposure // 주소 노출
    case otherPersonalExposure // 기타 개인 정보 노출
    
    var text: String {
        switch self {
        case .contactExposure:
            return "연락처 공개"
        case .addressExposure:
            return "주소 노출"
        case .otherPersonalExposure:
            return "기타 개인 정보 노출"
        }
    }
}

enum DefamationItems: CaseIterable, ItemsText {
    case userDefamation // 사용자 비방
    case groupHate // 특정 집단 혐오
    case animalDefamationOrHate // 동물에 대한 비방 및 혐오
    case aggressiveExpression // 공격적 표현
    
    var text: String {
        switch self {
        case .userDefamation:
            return "사용자 비방"
        case .groupHate:
            return "특정 집단 혐오"
        case .animalDefamationOrHate:
            return "동물에 대한 비방 및 혐오"
        case .aggressiveExpression:
            return "공격적 표현"
        }
    }
}

enum CheatingItems: CaseIterable, ItemsText {
    case voteManipulation // 추천수 조작
    case groupIntervention // 특정 단체가 개입한 조작
    case otherCheating // 기타 부정행위
    
    var text: String {
        switch self {
        case .voteManipulation:
            return "추천수 조작"
        case .groupIntervention:
            return "특정 단체가 개입한 조작"
        case .otherCheating:
            return "기타 부정행위"
        }
    }
}
