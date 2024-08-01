//
//  File.swift
//
//
//  Created by Jihee hwang on 4/22/24.
//

import Foundation

public struct HTTPHeaders: PropertyBuilderCompatible {
  
  private var headers: [HTTPHeader] = []
  
  public init() {}
  
  public init(_ headers: [HTTPHeader]) {
    headers.forEach { update($0) }
  }
  
  public init(_ dictionary: [String: String]) {
    dictionary.forEach {
      update(HTTPHeader(
        name: $0.key,
        value: $0.value
      ))
    }
  }
  
  public subscript(_ name: String) -> String? {
    get {
      value(for: name)
    } set {
      guard let newValue else {
        return
      }
      
      update(name: name, value: newValue)
    }
  }
  
}

extension HTTPHeaders {
  
  // MARK: - Property
  
  public var dictionary: [String: String] {
    let namesAndValues = headers.map { ($0.name, $0.value) }
    
    return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
  }
  
  // MARK: - Mutating
  
  public mutating func add(name: String, value: String) {
    update(HTTPHeader(name: name, value: value))
  }
  
  public mutating func add(_ header: HTTPHeader) {
    update(header)
  }
  
  public mutating func update(name: String, value: String) {
    update(HTTPHeader(name: name, value: value))
  }
  
  public mutating func update(_ header: HTTPHeader) {
    guard let index = headers.index(of: header.name) else {
      headers.append(header)
      return
    }
    
    headers.replaceSubrange(index...index, with: [header])
  }
  
  public mutating func sort() {
    headers.sort { $0.name.lowercased() < $1.name.lowercased() }
  }
  
  // MARK: - Not mutating
  
  public func sorted() -> HTTPHeaders {
    var headers = self
    headers.sort()
    
    return headers
  }
  
  public func value(for name: String) -> String? {
    guard let index = headers.index(of: name) else { return nil }
    
    return headers[index].value
  }
  
}
