//
//  Shadow.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/9/24.
//

import Foundation
import SwiftUI

struct Shadow01: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
    }
}

struct Shadow02: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
    }
}

struct Shadow03: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 4)

    }
}

struct Shadow04: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 10, y: 20)
    }
}


extension View {
    func shadow01() -> some View {
        self.modifier(Shadow01())
    }
    
    func shadow02() -> some View {
        self.modifier(Shadow02())
    }
    
    func shadow03() -> some View {
        self.modifier(Shadow03())
    }
    
    func shadow04() -> some View {
        self.modifier(Shadow04())
    }
}

