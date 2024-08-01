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
  
  private(set) var data: Data?
  
  public var boundary: String {
    return UUID().uuidString
  }
  
  public func getHeader(_ boundary: String) -> String {
    "multipart/form-data; boundary=\(boundary)"
  }
  
  // mimeType: image/png, text text/plain 와 같은 타입
  public func addMultipartFormData(
    with: Data,
    name: String,
    filename: String,
    key: String,
    mimeType: String,
    at boundary: String
  ) {
    let startString = Constants.dash + boundary + Constants.crlf
    let endString = Constants.dash + boundary + Constants.dash
    
    var body = Data()
    body.append(startString)
    body.append("\(Constants.contentDisposition) name=\"\(name)\"; filename=\"\(filename)\"\(Constants.crlf)")
    body.append("Content-Type: \(mimeType)\(Constants.crlf)\(Constants.crlf)")
    body.append(with)
    body.append(Constants.crlf)
    body.append(endString)
    
    self.data?.append(body)
  }
  
}
