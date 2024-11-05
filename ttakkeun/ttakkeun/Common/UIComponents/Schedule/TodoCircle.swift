//
//  TodoCircle.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct TodoCircle: View {
    
    var partItem: PartItem
    var isBefore: Bool
    
    init(partItem: PartItem, isBefore: Bool) {
        self.partItem = partItem
        self.isBefore = isBefore
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if isBefore {
                Circle()
                    .fill(beforeSetColor(partItem: self.partItem))
                    .frame(width: 51, height: 51)
            } else {
                Circle()
                    .fill(afterSetColor(partItem: self.partItem))
                    .frame(width: 51, height: 51)
            }
            setIcon(partItem: self.partItem)
                .fixedSize()
        }
    }
}

extension TodoCircle {
    func beforeSetColor(partItem: PartItem) -> Color {
        switch partItem {
        case .ear:
            return Color.beforeEar
        case .eye:
            return Color.beforeEye
        case .hair:
            return Color.beforeHair
        case .claw:
            return Color.beforeClaw
        case .teeth:
            return Color.beforeTeeth
        }
    }
    
    func afterSetColor(partItem: PartItem) -> Color {
        switch partItem {
        case .ear:
            return Color.afterEar
        case .eye:
            return Color.afterEye
        case .hair:
            return Color.afterHair
        case .claw:
            return Color.afterClaw
        case .teeth:
            return Color.afterTeeth
        }
    }
    
    func setIcon(partItem: PartItem) -> Image {
        switch partItem {
        case .ear:
            return Icon.homeEar.image
        case .eye:
            return Icon.homeEye.image
        case .hair:
            return Icon.homeHair.image
        case .claw:
            return Icon.homeClaw.image
        case .teeth:
            return Icon.homeTeeth.image
        }
    }
}


struct TodoCircle_Preview: PreviewProvider {
    static var previews: some View {
        TodoCircle(partItem: .ear, isBefore: true)
    }
}
