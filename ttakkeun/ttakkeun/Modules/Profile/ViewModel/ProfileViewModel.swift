//
//  ProfileViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    let colors: [Color] = [Color.card001, Color.card002, Color.card003, Color.card004, Color.card005, Color.mainPrimary]
    var usedColor: [Color] = []
    @Published var backgroudColor: Color = .white
    
    @Published var isLastedCard: Bool = true
    @Published var titleName: String = ""
    @Published var petProfileResponse: PetProfileResponse?
    
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func updateBackgroundColor() {
        if usedColor.count == colors.count {
            usedColor.removeAll()
        }
        
        var newColor: Color
        
        repeat {
            newColor = colors.randomElement()!
        } while usedColor.contains(newColor)
                    
        usedColor.append(newColor)
        withAnimation(.easeInOut(duration: 0.5)) {
        self.backgroudColor = newColor
        }
    }
}
