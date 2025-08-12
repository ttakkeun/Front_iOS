//
//  NavigationDestination.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/23/24.
//

import Foundation
import SwiftUI

enum NavigationDestination: Hashable {
    case signUp(socialType: SocialLoginType, singUpRequest: SignUpRequest) // 회원가입 페이지 이동
    case editPetProfile(image: String, petInfo: PetInfo) // 홈 화면 펫 프로파일의 수정 버트
    case makeJournalist // 일지 생성 네비게이션
    case productSearch
    case writeTipsView(category: ExtendPartItem)
    case myPage
    case appInfo
    case myTips
    case myScrapTips
    case deleteAccount
    case inquireBtn
    case reportBtn
    case writeInquire(selectedInquiryCategory: InquireType)
    case myInquire
    case reportDetailBtn(selectedReportCategory: ReportType)
    case writeReport
    case agreementData(selectedAgreementData: AgreementData)
    case myInquiryConfirm(selectedInquiryData: MyInquiryResponse)
}
