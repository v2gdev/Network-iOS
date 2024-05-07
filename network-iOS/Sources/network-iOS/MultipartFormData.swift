//
//  File.swift
//  
//
//  Created by Jihee hwang on 5/7/24.
//

import Foundation

open class MultipartFormData {
    
    public let boundary: String
    // request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    public lazy var contentType: String = "multipart/form-data; boundary=\(boundary)"
    
    public var data = Data()
    
    public init(boundary: String = UUID().uuidString,
                imageData: Data,
                filename: String,
                mimeType: String
    ) {
        self.boundary = boundary
        self.data = postImage(imageData: imageData, filename: filename, mimeType: mimeType)
    }
    
    // mimeType: image/png, text text/plain 와 같은 타입
    public func postImage(
        imageData: Data,
        filename: String,
        mimeType: String
    ) -> Data {
        var body = Data()
        body.append(Data("\(EncodingCharacters.dash)\(boundary)\(EncodingCharacters.crlf)".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\(EncodingCharacters.crlf)".utf8))
        body.append(Data("Content-Type: \(mimeType)\(EncodingCharacters.crlf)\(EncodingCharacters.crlf)".utf8))
        body.append(imageData)
        body.append(Data(EncodingCharacters.crlf.utf8))
        body.append(Data("\(EncodingCharacters.dash)\(boundary)\(EncodingCharacters.dash)".utf8))
        return body
    }
    
}

// MARK: - EncodingCharacters

extension MultipartFormData {
    
    enum EncodingCharacters {
        static let crlf = "\r\n"
        static let dash = "--"
    }
    
}
