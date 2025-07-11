//
//  TodoCircle.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

struct TodoCircle: View {
    
    // MARK: - Property
    var partItem: PartItem
    var isBefore: Bool
    
    // MARK: - Constants
    fileprivate enum TodoCircleConstants {
        static let iconSize: CGFloat = 51
    }
    
    // MARK: - Init
    init(partItem: PartItem, isBefore: Bool) {
        self.partItem = partItem
        self.isBefore = isBefore
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if isBefore {
                Circle()
                    .fill(partItem.toColor())
                    .frame(width: TodoCircleConstants.iconSize, height: TodoCircleConstants.iconSize)
            } else {
                Circle()
                    .fill(partItem.toAfterColor())
                    .frame(width: TodoCircleConstants.iconSize, height: TodoCircleConstants.iconSize)
            }
            partItem.toImage()
                .fixedSize()
        }
    }
}


struct TodoCircle_Preview: PreviewProvider {
    static var previews: some View {
        TodoCircle(partItem: .ear, isBefore: true)
    }
}
