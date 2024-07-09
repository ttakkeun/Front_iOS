//
//  ContentView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .foregroundStyle(Color.card001_Color)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
