//
//  File.swift
//  
//
//  Created by Jihee hwang on 5/2/24.
//

import Foundation

extension HTTPHeader {
  static let contentTypeHeader = HTTPHeader()
    .builder
    .set(\.name, to: "Content-Type")
    .set(\.value, to: "application/json")
    .build()
  
  static let acceptHeader = HTTPHeader()
    .builder
    .set(\.name, to: "Accept")
    .set(\.value, to: "*/*")
    .build()
  
  static let appInfoHeader = HTTPHeader()
    .builder
    .set(\.name, to: "App-Info")
    .set(\.value, to: "iOS")
    .build()
}
