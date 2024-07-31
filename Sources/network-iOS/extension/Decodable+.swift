//
//  File.swift
//
//
//  Created by Jihee hwang on 5/2/24.
//

import Foundation

extension Decodable {
  
  public func decode<D>(
    _ type: D.Type,
    _ from: Data
  ) async throws -> D where D: Decodable {
    do {
      return try JSONDecoder().decode(D.self, from: from)
    } catch {
      throw NetworkError.jsonParsingFailed
    }
  }
  
}
