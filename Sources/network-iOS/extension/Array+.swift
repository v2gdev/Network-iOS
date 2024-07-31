//
//  File.swift
//  
//
//  Created by Jihee hwang on 5/7/24.
//

import Foundation

extension Array where Element == HTTPHeader {
  
  func index(of name: String) -> Int? {
    let lowercasedName = name.lowercased()
    return firstIndex { $0.name.lowercased() == lowercasedName }
  }
  
}
