//
//  Encodable+Multipart.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/14/25.
//

import Foundation
import Moya

extension Encodable {
    func multipartFormParts(
        jsonFieldName: String,
        images: [Data]?,
        imageFieldName: String = "multipartFile",
        fileNamePrefix: String = "image",
        jsonFileName: String = "request.json"
    ) -> [MultipartFormData] {
        var parts: [MultipartFormData] = []
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        // JSON 파트
        if let jsonData = try? encoder.encode(self) {
            let jsonPart = MultipartFormData(
                provider: .data(jsonData),
                name: jsonFieldName,
                fileName: jsonFileName,
                mimeType: "application/json"
            )
            parts.append(jsonPart)
        }
        
        // 이미지 파트
        if let images = images {
            for (index, data) in images.enumerated() {
                let part = MultipartFormData(
                    provider: .data(data),
                    name: imageFieldName,
                    fileName: "\(fileNamePrefix)\(index).jpg",
                    mimeType: "image/jpeg"
                )
                parts.append(part)
            }
        }
        return parts
    }
}
