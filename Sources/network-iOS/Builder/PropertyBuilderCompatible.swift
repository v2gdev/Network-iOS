//
//  PropertyBuilderCompatible.swift
//
//
//  Created by Jihee hwang on 4/30/24.
//

import Foundation

public protocol PropertyBuilderCompatible {
    associatedtype Base
    var builder: PropertyBuilder<Base> { get }
}

public extension PropertyBuilderCompatible {
    var builder: PropertyBuilder<Self> {
        PropertyBuilder(self)
    }
}

