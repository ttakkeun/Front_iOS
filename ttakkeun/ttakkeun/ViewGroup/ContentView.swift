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
                .onAppear {
                    UIFont.familyNames.sorted().forEach { familyName in
                        print("*** \(familyName) ***")
                        UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                            print("\(fontName)")
                        }
                        print("---------------------")
                    }
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
