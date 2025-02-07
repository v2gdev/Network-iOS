//
//  File.swift
//
//
//  Created by Jihee hwang on 5/7/24.
//

import Foundation

open class MultipartFormData {
  
  enum Constants {
    static let contentDisposition = "Content-Disposition: form-data;"
    static let crlf = "\r\n"
    static let dash = "--"
  }
  
  private(set) var data = Data()
  
  private let boundary: String
  
  public init() {
    self.boundary = UUID().uuidString
  }
  
  public func getHeader(_ boundary: String) -> String {
    "multipart/form-data; boundary=\(boundary)"
  }
  
  public func getBoundary() -> String {
    return boundary
  }
  
  public func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.data.append(data)
    }
  }
  
  // 일반 텍스트 필드용 메서드
  public func addFormField(
    name: String,
    value: String
  ) {
    append("\(Constants.dash)\(boundary)\(Constants.crlf)")
    append("\(Constants.contentDisposition) name=\"\(name)\"\(Constants.crlf)")
    append(Constants.crlf)
    append(value)
    append(Constants.crlf)
  }
  
  // 파일 데이터용 메서드
  public func addFileData(
    with data: Data,
    name: String,
    filename: String,
    mimeType: String
  ) {
    // Add boundary
    append("\(Constants.dash)\(boundary)\(Constants.crlf)")
    
    // Add content disposition with filename
    append("\(Constants.contentDisposition) name=\"\(name)\"; filename=\"\(filename)\"\(Constants.crlf)")
    
    // Add content type
    append("Content-Type: \(mimeType)\(Constants.crlf)")
    
    // Add line break before content
    append(Constants.crlf)
    
    // Add file data
    self.data.append(data)
    
    // Add line break after content
    append(Constants.crlf)
  }
  
  
  public func finalize() {
    // Add final boundary
    append("\(Constants.dash)\(boundary)\(Constants.dash)")
  }
}
