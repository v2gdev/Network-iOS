//
//  File.swift
//  
//
//  Created by Jihee hwang on 5/2/24.
//

import Foundation

public protocol URLRequestConvertible {
    func asURLRequest<E: Encodable>(api: URL,
                                    method: HTTPMethod,
                                    headers: HTTPHeaders?,
                                    body: E?,
                                    timeout: TimeInterval
    ) async throws -> URLRequest
    
    func asImageURLRequest(imageURL: URL) async throws -> URLRequest
}
