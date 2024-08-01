//
//  File.swift
//
//
//  Created by Jihee hwang on 5/8/24.
//

import Foundation

extension Data {
  
  mutating func append(_ value: String) {
    self.append(Data(value.utf8))
  }
  
}
