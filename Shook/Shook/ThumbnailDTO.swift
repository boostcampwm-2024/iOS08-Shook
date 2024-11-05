//
//  ResponseDTO.swift
//  Shook
//
//  Created by inye on 11/4/24.
//

import Foundation

struct ServiceURLDTO: Decodable {
    let content: [Content]
}

struct Content: Decodable {
    let name: String
    let url: String
    let resolution, videoBitrate, audioBitrate: String?
    let resizedUrl: [ResizedUrl]?
}

struct ResizedUrl: Decodable {
    let type: String
    let url: String
}
