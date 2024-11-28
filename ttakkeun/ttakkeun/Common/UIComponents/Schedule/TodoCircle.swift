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
                    .fill(partItem.toColor())
                    .frame(width: 51, height: 51)
            } else {
                Circle()
                    .fill(partItem.toAfterColor())
                    .frame(width: 51, height: 51)
            }
            setIcon(partItem: self.partItem)
                .fixedSize()
        }
    }
}

extension TodoCircle {
    
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
