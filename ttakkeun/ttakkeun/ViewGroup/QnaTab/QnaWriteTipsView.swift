//
//  QnaWriteTipsView.swift
//  ttakkeun
//
//  Created by 한지강 on 8/9/24.
//

import SwiftUI

/// 공유할 Tip 내용을 작성하는 뷰
struct QnaWriteTipsView: View {
    
//    @StateObject var viewModel : QnaWriteTipsViewModel
    var category: TipsCategorySegment  // 선택된 카테고리를 전달 받음
       @State private var title: String = ""
       @State private var content: String = ""
    @Environment(\.dismiss) private var dismiss
       
    
    //MARK: - Init
    /*초기화 할 것 넣어라*/
    
    
    //MARK: - Contents
       var body: some View {
           VStack(spacing: 29){
               writeSet
                   .padding(.top, 20)
               postPhotoSet
                   .padding(.leading, 20)
        
               Spacer()
               
               MainButton(btnText: "공유하기", width: 353, height: 56, action: { dismiss() }, color: .primaryColor_Main)
                     }
                    .navigationBarBackButtonHidden(true)
                     .navigationBarItems(trailing: Button(action: {
                         dismiss()
                     }) {
                         Image(systemName: "xmark")
                             .foregroundColor(.black)
                     })
                 }
 
    /// 카테고리와 제목, 내용 작성하는 필드 모음
    private var writeSet: some View {
        VStack(alignment: .leading ,spacing: 17) {
            Group{
                categorySet
                titleField
            }
            .padding(.leading,18)
            contentField
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.all)
    }
    
    /// 포토 제목과 사진 가져오는 버튼 모음
    private var postPhotoSet: some View {
        VStack(alignment: .leading, spacing: 16){
            postPhotoText
            postPhtoBtn
        }
    }
    
    /// 분류된 카테고리 표시
    private var categorySet: some View {
        Text(category.toKorean())
            .font(.Body2_semibold)
            .frame(width: 58, height: 28)
            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(categoryColor))
        
    }
    
       /// 선택된 카테고리에 따라 색 반환
       private var categoryColor: Color{
           switch category {
           case .ear:
               return Color.qnAEar
           case .eye:
               return Color.afterEye
           case .hair:
               return Color.afterClaw
           case .claw:
               return Color.afterEye
           case .tooth:
               return Color.afterTeeth
           default:
               return Color.clear
           }
       }
    
    /// 제목 필드
    private var titleField: some View {
        ZStack(alignment: .leading) {
            if title.isEmpty {
                Text("제목을 입력해주세요")
                    .font(.H3_semiBold)
                    .foregroundStyle(Color.gray200)
            }
            TextField("", text: $title)
                .font(.H3_semiBold)
                .foregroundStyle(Color.gray900)
        }
    }
    
    /// 내용 필드
    private var contentField: some View {
        TextField("나만의 TIP을 작성해주세요!" ,text: $content)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray200)
            .frame(maxWidth: .infinity, minHeight: 257,  alignment: .topLeading)
            .background(Color.scheduleCard)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.checkBg),
                alignment: .top)
    }
    
    /// 사진 등록 안내 타이틀과 제한사항
    private var postPhotoText: some View {
        VStack(alignment: .leading, spacing: 5){
            Text("사진 등록 (선택)")
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
            Text("최대 3장")
                .font(.Body5_medium)
                .foregroundStyle(Color.gray400)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// 사진 가져오는 버튼
    private var postPhtoBtn: some View {
        Icon.camera.image
            .resizable()
            .frame(width: 47, height: 47)
            .foregroundStyle(Color.gray300)
            .padding(28)
            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.scheduleCard_Color))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray200))
    }
}

//MARK: - Preview
struct QnaWriteTipsView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            QnaWriteTipsView(category: .hair)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
