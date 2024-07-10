//
//  ContentView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/7/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button(action: {
                viewModel.kakaoButton()
            }, label: {
                Text("테스트")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
