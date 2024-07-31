//
//  File.swift
//
//
//  Created by Jihee hwang on 5/2/24.
//

import Foundation

extension Encodable {
  
  public func toJsonString() -> String? {
    guard let data = try? JSONEncoder().encode(self) else {
        return nil
    }
    
    return String(data: data, encoding: .utf8)
  }
  
  public func toJson<E>(_ value: E) async throws -> Data where E: Encodable {
    try JSONEncoder().encode(value)
  }
  
  public func toQueryParameters() -> [URLQueryItem]? {
    guard let data = try? JSONEncoder().encode(self),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else {
      return nil
    }
    
    return json.map { key, value in
      URLQueryItem(name: key, value: String(describing: value))
    }
  }
  
}
