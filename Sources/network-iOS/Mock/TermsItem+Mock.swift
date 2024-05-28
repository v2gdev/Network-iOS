//
//  File.swift
//  
//
//  Created by Jihee hwang on 5/13/24.
//

import Foundation

struct Terms_API: Codable {
    
    struct Request: Codable {
        /// 약관 종류 (default: account_terms)
        let usingType: String
    }
    
    struct Response: Codable {
        var msg: String
        var code: Int
        /// 약관 목록
        let termsList: [TermsItem]
    }
    
    struct Path: Codable {
        
    }
    
}

struct TermsItem: Codable {
    var content: String
    var isNeeded: Bool
    var termsId: String
    var title: String
}
