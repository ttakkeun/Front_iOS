//
//  LikeButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/25/24.
//

import SwiftUI

struct LikeButton: View {
    
    @Binding var data: ProductResponse
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    toggleLike()
                }
            }, label: {
                HStack(spacing: 4, content: {
                    Group {
                        Image(systemName: data.likeStatus ? "suit.heart.fill" : "suit.heart")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 18, height: 17)
                        
                        Text(countText(count: data.totalLike ?? 0))
                            .frame(maxWidth: 40, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .font(.Body3_medium)
                    }
                    .foregroundStyle(data.likeStatus ? Color.removeBtn : Color.gray600)
                })
                .border(Color.green)
            })
        }
        .frame(alignment: .leading)
    }
    
    func toggleLike() {
        data.likeStatus.toggle()
            if data.likeStatus {
                data.totalLike = (data.totalLike ?? 0) + 1
            } else {
                data.totalLike = max(0, (data.totalLike ?? 0) - 1)
            }
        }
    
    func countText(count: Int) -> String {
        if count > 999 {
            return "999+"
        } else {
            return String(count)
        }
    }
}
