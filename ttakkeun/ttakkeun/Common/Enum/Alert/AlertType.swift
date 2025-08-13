//
//  AlertType.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/19/24.
//

import Foundation
import SwiftUI

/// Alert 유형
enum AlertType {
    case aiAlert(count: Int, aiCount: Int)
    case noAiCountAlert
    case editNicknameAlert(currentNickname: String)
    case deleteProfileAlert
    case logoutProfileAlert
    case deleteAccountAlert
    case receivingInquiryAlert
    case receivingReportAlert
    
    var title: String {
        switch self {
        case .aiAlert(let count, _):
            return "선택된 \(count)개의 일지로 \n따끈 AI 진단을 진행하시겠습니까?"
        case .noAiCountAlert:
            return "현재 AI 진단 횟수가 없습니다."
        case .editNicknameAlert:
            return "닉네임 수정하기"
        case .deleteProfileAlert:
            return "해당 프로필을 삭제하시겠습니까?"
        case .logoutProfileAlert:
            return "로그아웃 하시겠습니까?"
        case .deleteAccountAlert:
            return "정말로 따끈을 떠나시겠습니까?"
        case .receivingInquiryAlert:
            return "문의내용이 접수되었습니다."
        case .receivingReportAlert:
            return "신고내용이 접수되었습니다."
        }
    }
    
    var subtitle: String {
        switch self {
        case .aiAlert(_, let aiCount):
            return "현재 남은 AI 진단 횟수는 \(aiCount)개 입니다."
        case .noAiCountAlert:
            return "오늘의 AI 사용 횟수를 모두 사용하셨어요! 내일 다시 이용해 주세요!"
        case .editNicknameAlert(let currentNickname):
            return currentNickname
        case .deleteProfileAlert:
            return "해당 프로필에 저장된 데이터는 모두 삭제됩니다. \n삭제된 데이터는 다시 복원할 수 없습니다."
        case .logoutProfileAlert:
            return "회원님의 소중한 정보는 이용약관에 따라 처리됩니다. \n이대로 탈퇴를 누르신다면 탈퇴를 취소하실 수 없습니다."
        case .deleteAccountAlert:
            return "회원님의 소중한 정보는 이용약관에 따라 처리됩니다.\n이대로 탈퇴를 누르신다면 탈퇴를 취소하실 수 없습니다.?"
        case .receivingInquiryAlert:
            return "회원님의 소중한 의견을 잘 반영하도록 하겠습니다. \n영업시간 2~3일 이내에 이메일로 답변을 받아보실 수 있습니다."
        case .receivingReportAlert:
            return "회원님의 소중한 의견을 잘 반영하도록 하겠습니다. \n검토 후 신고내용을 반영하여 조치를 취하겠습니다."
        }
    }
    
    var font: [Font] {
        return [.Body3_semibold, .Body4_semibold]
    }
    
    var fontColor: [Color] {
        return [.gray900, .gray400]
    }
    
    var lineSpacing: Int {
        return 2
    }
}
