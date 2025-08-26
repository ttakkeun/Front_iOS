//
//  NavigatiobnRoutingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/4/24.
//

import Foundation
import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject var container: DIContainer
    @Environment(\.appFlow) var appFlowViewModel
    
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .auth(let auth):
            authView(auth)
        case .profile(let profile):
            profileView(profile)
        case .diagnostic(let diagnostic):
            diagnosticView(diagnostic)
        case .recommend(let recommend):
            recommendView(recommend)
        case .tips(let tips):
            tipsView(tips)
        case .myPage(let myPage):
            myPageView(myPage)
        case .appInfo(let appInfo):
            appInfoView(appInfo)
        case .inquire(let inquire):
            inquireView(inquire)
        }
    }
}

private extension NavigationRoutingView {
    
    @ViewBuilder
    func authView(_ route: NavigationDestination.Auth) -> some View {
        switch route {
        case .signUp(let socialType, let signUpRequest):
            SignUpView(socialType: socialType, signup: signUpRequest, container: container, appFlowViewModel: appFlowViewModel)
        case .deleteAccount:
            DeleteAccountView(container: container, appFlowViewModel: appFlowViewModel)
        }
    }
    
    @ViewBuilder
    func profileView(_ route: NavigationDestination.Profile) -> some View {
        switch route {
        case .editPetProfile(let image, let petInfo):
            ProfileFormView(mode: .edit(image: image, petInfo: petInfo), container: container)
        }
    }
    
    @ViewBuilder
    func diagnosticView(_ route: NavigationDestination.Diagnostic) -> some View {
        switch route {
        case .makeJournalist:
            JournalRegistView(container: container)
        }
    }
    
    @ViewBuilder
    func recommendView(_ route: NavigationDestination.Recommend) -> some View {
        switch route {
        case .productSearch:
            RecommendSearchView(container: container)
        }
    }
    
    @ViewBuilder
    func tipsView(_ route: NavigationDestination.Tips) -> some View {
        switch route {
        case .writeTips(let category):
            WriteTipsView(category: category, container: container)
        case .tipsReport(let tipId):
            ReportView(tipId: tipId)
        case .tipsReportDetail(let selectedReportCategory, let tipId):
            ReportDetailView(container: container, selectedCategory: selectedReportCategory, tipId: tipId)
        case .tipsWriteReport(let tipId):
            ReportWriteView(container: container, tipId: tipId)
        }
    }
    
    @ViewBuilder
    func myPageView(_ route: NavigationDestination.MyPage) -> some View {
        switch route {
        case .myPage:
            MyPageView(container: container)
        case .myTips:
            MyTipsView(container: container)
        case .myScrapTips:
            MyScrapTipsView(container: container)
        }
    }
    
    @ViewBuilder
    func appInfoView(_ route: NavigationDestination.AppInfo) -> some View {
        switch route {
        case .privacyPolicy:
            PrivacyAndPoliciesView()
        case .privacyDetail(let selectedAgreementData):
            PrivacyDetailView(selectedAgreement: selectedAgreementData)
        }
    }
    
    @ViewBuilder
    func inquireView(_ route: NavigationDestination.Inquire) -> some View {
        switch route {
        case .inquireSelect:
            InquireView(container: container)
        case .writeInquire(let selectedInquiryCategory):
            InquireWriteView(container: container, type: selectedInquiryCategory)
        case .myInquire:
            MyInquireView(container: container)
        case .myInquiryConfirm(let selectedInquiryData):
            MyInquireDetailView(inquiryResponse: selectedInquiryData)
        }
    }
}
