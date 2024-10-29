//
//  SignUpView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/29/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @Environment(\.dismiss) var dismiss
    
    var signUpData: SignUpData
    
    init(
        signUpData: SignUpData
//        container: DIContainer
    ) {
        self.signUpData = signUpData
    }
    
    var body: some View {
        emailField
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text("이메일")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            CustomTextField(text: .constant(""), placeholder: signUpData.email)
                .disabled(true)
        })
        }
}

struct SignUpView_Preview: PreviewProvider {
    static var previews: some View {
        SignUpView(signUpData: SignUpData(token: "11", name: "google", email: "google.com"))
            .environmentObject(AppFlowViewModel())
    }
}
