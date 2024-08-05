//
//  File.swift
//
//
//  Created by Jihee hwang on 4/22/24.
//

import Foundation

public struct HTTPHeader:
  Hashable,
  PropertyBuilderCompatible
{
  public var name: String = ""
  public var value: String = ""
  
  public init(name: String, value: String) {
    self.name = name
    self.value = value
  }
  
  public init () {}
}
