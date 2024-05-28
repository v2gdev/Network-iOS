//
//  BaseURL.swift
//  
//
//  Created by Jihee hwang on 4/23/24.
//

import Foundation

// MARK: - App마다 갖게 될 BaseURL
// MARK: - Ex. https://evs-chungguk-dev-api.autocrypt.io

public protocol BaseURL {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var baseURL: URL? { get }
}

extension BaseURL {
    
    func makeBaseURL() -> URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = path
        return urlComponent.url
    }
    
}
