//
//  ResponseDTO.swift
//  Shook
//
//  Created by inye on 11/4/24.
//

import Foundation

struct ThumbnailDTO: Decodable {
    let content: [ThumbnailContentDTO]
}

struct ThumbnailContentDTO: Decodable {
    let name: String
    let url: String
    let resizedUrl: [ResizedUrl]
}

struct ResizedUrl: Decodable {
    let type: String
    let url: String
}
