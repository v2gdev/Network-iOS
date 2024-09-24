//
//  ReissueResponse.swift
//
//
//  Created by Jihee hwang on 8/1/24.
//

import Foundation

/// Result Code로 Reissue 상황을 파악하기 위한, Decoding Model 객체
struct ReissueResponse: Decodable {
  let resultCode: Int
}
