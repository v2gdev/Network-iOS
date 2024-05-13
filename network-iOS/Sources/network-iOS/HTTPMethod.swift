//
//  HTTPMethod.swift
//
//
//  Created by Jihee hwang on 4/22/24.
//

import Foundation

public struct HTTPMethod:
    RawRepresentable,
    Equatable,
    Hashable
{

    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let patch = HTTPMethod(rawValue: "PATCH")
    public static let delete = HTTPMethod(rawValue: "DELETE")

    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
}
