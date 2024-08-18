//
//  NavigationRoutingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/14/24.
//

import Foundation
import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .createProfile:
            CreateProfileView()
        case .myPage:
            Text("마이페이잊")
        }
    }
}
