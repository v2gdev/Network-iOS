//
//  File.swift
//
//
//  Created by Jihee hwang on 4/22/24.
//

import Foundation

public extension String {
  
  func endPointFormatted(_ arguments: CVarArg...) -> Self {
    return String(format: self, arguments: arguments)
  }
  
}

// MARK: - URLConvertible

extension String: URLConvertible {
  
  public func asURL() throws -> URL {
    guard let url = URL(string: self) else {
      throw NetworkError.invalidURL(url: self)
    }
    
    return url
  }
  
}
