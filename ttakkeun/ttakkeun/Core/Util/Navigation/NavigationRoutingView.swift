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
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .signUp(let type, let signUpRequest):
            SignUpView(socialType: type, singUpRequest: signUpRequest, container: container, appFlowViewModel: appFlowViewModel)
                .environmentObject(container)
            
        case .editPetProfile(let image, let petInfo):
            ProfileFormView(mode: .edit(image: image, petInfo: petInfo), container: container)
                .environmentObject(container)
            
        case .makeJournalist:
            JournalRegistView(container: container)
                .environmentObject(container)
            
        case .productSearch:
            RecommendSearchView(container: container)
                .environmentObject(container)
            
        case .writeTipsView(let category):
            WriteTipsView(category: category, container: container)
            
        case .myPage:
            MyPageView(container: container)
                .environmentObject(container)
            
        case .appInfo:
            PrivacyAndPoliciesView()
                .environmentObject(container)
            
        case .myTips:
            MyTipsView(container: container)
                .environmentObject(container)
            
        case .myScrapTips:
            MyScrapTipsView(container: container)
                .environmentObject(container)
            
        case .deleteAccount:
            DeleteAccountView(container: container)
                .environmentObject(container)
            
        case .inquireBtn:
            InquireView(container: container)
                .environmentObject(container)
            
        case .reportBtn:
            ReportView(container: container)
                .environmentObject(container)
            
        case .writeInquire(let selectedInquiryCategory):
            InquireWriteView(container: container, type: selectedInquiryCategory)
                .environmentObject(container)
            
        case .myInquire:
            InquireView(container: container)
                .environmentObject(container)
            
        case .reportDetailBtn(let selectedReportCategory):
            ReportDetailView(container: container, selectedCategory: selectedReportCategory)
                .environmentObject(container)
            
        case .writeReport:
            ReportWriteView(container: container)
                .environmentObject(container)
            
        case .agreementData(let selectedAgreementData):
            PrivacyDetailView(selectedAgreement: selectedAgreementData)
                .environmentObject(container)
            
        case .myInquiryConfirm(let selectedInquiryData):
            MyInquireDetailView(inquiryResponse: selectedInquiryData)
                .environmentObject(container)
        }
    }
}
