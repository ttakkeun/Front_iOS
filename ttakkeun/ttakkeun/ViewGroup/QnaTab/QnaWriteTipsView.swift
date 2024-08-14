import SwiftUI
import Combine

struct QnaWriteTipsView: View {
    
    @StateObject var viewModel: QnaWriteTipsViewModel
    var category: TipsCategorySegment  // 선택된 카테고리를 전달 받음
    @Environment(\.dismiss) private var dismiss
    private let placeholder: String = "나만의 Tip을 작성해주세요!"
    
    var body: some View {
        VStack(spacing: 29) {
            backBtn
            writeSet
            postPhotoSet
                .padding(.leading, 20)
            
            Spacer()
            
            MainButton(btnText: "공유하기", width: 353, height: 56, action: {
                Task {
                    await viewModel.postTipsData()
                    dismiss()
                }
            }, color: viewModel.isTipsinputCompleted ? .primaryColor_Main : .gray200)
            .disabled(!viewModel.isTipsinputCompleted)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private var backBtn: some View {
        HStack {
            Spacer()
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.gray900)
            }
            .padding(.trailing, 20)
        }
    }
    
    private var writeSet: some View {
        VStack(alignment: .leading, spacing: 17) {
            Group {
                categorySet
                titleField
            }
            .padding(.leading, 18)
            contentField
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.all)
    }
    
    private var postPhotoSet: some View {
        VStack(alignment: .leading, spacing: 16) {
            postPhotoText
            cameraBtn
        }
    }
   
    private var categorySet: some View {
        Text(category.toKorean())
            .font(.Body2_semibold)
            .frame(width: 58, height: 28)
            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(categoryColor))
    }

    private var categoryColor: Color {
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

    private var titleField: some View {
        ZStack(alignment: .leading) {
            if viewModel.requestData?.title.isEmpty ?? true {
                Text("제목을 입력해주세요")
                    .font(.H3_semiBold)
                    .foregroundStyle(Color.gray200)
            }
            TextField("", text: Binding(
                get: { viewModel.requestData?.title ?? "" },
                set: {
                    viewModel.requestData?.title = $0
                    viewModel.Title = !$0.isEmpty
                    viewModel.checkFilledStates()
                }
            ))
            .font(.H3_semiBold)
            .foregroundStyle(Color.gray900)
        }
        .onAppear {
            UIApplication.shared.hideKeyboard()
        }
    }

    private var contentField: some View {
        TextEditor(text: Binding(
            get: { viewModel.requestData?.content ?? "" },
            set: {
                viewModel.requestData?.content = $0
                viewModel.Content = !$0.isEmpty
                viewModel.checkFilledStates()
            }
        ))
        .padding(15)
        .background(alignment: .topLeading) {
            if viewModel.requestData?.content.isEmpty ?? true {
                Text(placeholder)
                    .lineSpacing(10)
                    .padding(20)
                    .padding(.top, 2)
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray200)
            }
        }
        .textInputAutocapitalization(.none)
        .autocorrectionDisabled()
        .background(Color.scheduleCard)
        .scrollContentBackground(.hidden)
        .font(.system(size: 14))
        .overlay(alignment: .bottomTrailing) {
            Text("\(viewModel.requestData?.content.count ?? 0) / 200")
                .font(.Body4_medium)
                .foregroundColor(Color.gray400)
                .padding(.trailing, 15)
                .padding(.bottom, 15)
        }
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.checkBg),
            alignment: .top)
        .onReceive(Just(viewModel.requestData?.content ?? "")) { newValue in
            if newValue.count > 200 {
                viewModel.requestData?.content = String(newValue.prefix(200))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 260)
        .onAppear {
            UIApplication.shared.hideKeyboard()
        }
    }

    private var postPhotoText: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("사진 등록 (선택)")
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
            Text("최대 3장")
                .font(.Body5_medium)
                .foregroundStyle(Color.gray400)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var cameraBtn: some View {
        Button(action: {
            viewModel.showImagePicker()
        }, label: {
            HStack(alignment: .top, spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.scheduleCard_Color)
                        .stroke(Color.gray_200)
                        .frame(width: 80, height: 80)
                    VStack(alignment: .center, spacing: 5, content: {
                        Icon.petCamera.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 47, height: 47)
                        
                        Text("\(viewModel.selectedImageCount) / 3")
                            .font(.Body3_regular)
                            .foregroundStyle(Color.gray_400)
                    })
                }
                showSelectedImage
            }
            .sheet(isPresented: $viewModel.isImagePickerPresented, content: {
                        QnaImagePicker(imageHandler: viewModel as ImageHandling)})
        })
    }

    private func imageAddAndRemove(for index: Int, image: UIImage) -> some View {
        ZStack(alignment: .topLeading, content: {
            Image(uiImage: image)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color.gray_200, lineWidth: 1)
                )
            
            Button(action: {
                viewModel.removeImage(at: index)
            }, label: {
                Icon.imageRemove.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding([.horizontal, .vertical], -3)
            })
        })
        .frame(width: 86, height: 86)
    }
    
    private var showSelectedImage: some View {
        HStack {
            ForEach(0..<viewModel.getImages().count, id: \.self) { index in
                imageAddAndRemove(for: index, image: viewModel.getImages()[index])
            }
        }
    }
}

// MARK: - Preview
struct QnaWriteTipsView_Preview: PreviewProvider {

    static let devices = ["iPhone 11", "iPhone 15 Pro"]

    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            QnaWriteTipsView(viewModel: QnaWriteTipsViewModel(), category: .hair)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
