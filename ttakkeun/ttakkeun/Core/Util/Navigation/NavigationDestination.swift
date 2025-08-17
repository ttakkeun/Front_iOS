//
//  NavigationDestination.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/23/24.
//

import Foundation
import SwiftUI

enum NavigationDestination: Hashable {
    /// 회원관련
    enum Auth: Hashable {
        /// 회원 가입 이동
        case signUp(socialType: SocialLoginType, signup: SignUpData)
        /// 회원 탈퇴 이동
        case deleteAccount
    }
    
    /// 애완 프로필 생성
    enum Profile: Hashable {
        /// 홈 화면 펫 프로필 수정 이동
        case editPetProfile(image: String, petInfo: PetInfo)
    }
    
    /// 진단 탭
    enum Diagnostic: Hashable {
        /// 일지 생성 이동
        case makeJournalist
    }
    
    /// 추천 탭
    enum Recommend: Hashable {
        /// 물품 검색 이동
        case productSearch
    }
    
    /// QnA 탭
    enum Tips: Hashable {
        /// 팁 작성 이동
        case writeTips(category: ExtendPartItem)
        /// 팁스 신고하기 이동
        case tipsReport
        /// 팁스 신고하기 상세 선택 이동
        case tipsReportDetail(selectedReportCategory: ReportType)
        /// 팁스 신고하기 작성 이동
        case tipsWriteReport
    }
    
    /// 마이 페이지 탭
    enum MyPage: Hashable {
        /// 마이 페이지 이동
        case myPage
        /// 내가 작성한 팁스 이동
        case myTips
        /// 내가 스크랩한 팁스 이동
        case myScrapTips
    }
    
    /// 앱 정보
    enum AppInfo: Hashable {
        /// 앱 이용 약관 이동
        case privacyPolicy
        /// 이용 약관 상세 이동
        case privacyDetail(selectedAgreementData: AgreementData)
    }
    
    /// 문의 관련
    enum Inquire: Hashable {
        /// 앱 문의하기 선택 이동
        case inquireSelect
        /// 앱 문의하기 작성 이동
        case writeInquire(selectedInquiryCategory: InquireType)
        /// 내가 문의한 목록 이동
        case myInquire
        /// 내가 문의한 상세 내용 이동
        case myInquiryConfirm(selectedInquiryData: MyInquiryResponse)
    }
    
    case auth(Auth)
    case profile(Profile)
    case diagnostic(Diagnostic)
    case recommend(Recommend)
    case tips(Tips)
    case myPage(MyPage)
    case appInfo(AppInfo)
    case inquire(Inquire)
}
