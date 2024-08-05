//
//  File.swift
//  
//
//  Created by Jihee hwang on 4/30/24.
//

import Foundation

@dynamicMemberLookup
public struct PropertyBuilder<Base> {
  private let base: Base
  
  public init(_ base: Base) {
    self.base = base
  }
  
  public subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> (Value) -> PropertyBuilder<Base> {
    { [base] value in
      var object = base
      object[keyPath: keyPath] = value
      return PropertyBuilder(object)
    }
  }
  
  public subscript<Value>(dynamicMember keyPath: WritableKeyPath<Base, Value>) -> (Value) -> Base {
    { [base] value in
      var object = base
      object[keyPath: keyPath] = value
      return object
    }
  }
  
  public func set<Value>(_ keyPath: WritableKeyPath<Base, Value>, to value: Value) -> PropertyBuilder<Base> {
    var object = self.base
    object[keyPath: keyPath] = value
    return PropertyBuilder(object)
  }
  
  public func build() -> Base {
    return self.base
  }
}

extension PropertyBuilder {
  func with(_ handler: (inout Base) -> Void) -> PropertyBuilder<Base> {
    PropertyBuilder(self.with(handler))
  }
  
  func with(_ handler: (inout Base) -> Void) -> Base {
    var object = self.base
    handler(&object)
    return object
  }
}

