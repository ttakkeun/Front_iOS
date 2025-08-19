//
//  ReportViewModel.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/11/25.
//

import Foundation
import SwiftUI
import Combine
import CombineMoya

@Observable
class ReportViewModel {
    // MARK: - StateProperty
    var isImagePickerPresented: Bool = false
    
    // MARK: - Property
    var contentsText: String = ""
    var selectedImageCount: Int = .zero
    var selectedImage: [UIImage] = .init()
    
    // MARK: - Dependency
    var container: DIContainer
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - ReportAPI
    /// 팁 신고하기
    /// - Parameter report: 팁 데이터
    public func report(report: TipReportRequest) {
        container.useCaseProvider.tipUseCase.executePostTipReportData(report: report, images: convertImageToData())
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Tip Report Completed")
                case .failure(let failure):
                    print("Tip Report Failed: \(failure)")
                }
            }, receiveValue: { responseData in
                #if DEBUG
                print("Tip Response: \(responseData)")
                
                #endif
            })
            .store(in: &cancellables)
    }
}

extension ReportViewModel: PhotoPickerHandle {
    
    func addImage(_ images: [UIImage]) {
        self.selectedImage = images
    }
    
    func removeImage(at index: Int) {
        self.selectedImage.remove(at: index)
    }
    
    func getImages() -> [UIImage] {
        return selectedImage
    }
    
    func convertImageToData() -> [Data]? {
        guard !selectedImage.isEmpty else { return nil }
        let result = selectedImage.compactMap { $0.jpegData(compressionQuality: 0.8) }
        return result.isEmpty ? nil : result
    }
}
