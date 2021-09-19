//
//  ApiParser.swift
//  iOS_Assignment
//
//  Created by leo on 20/9/21.
//

import Foundation

struct APIElementList:Codable {
    let current_page: Int
    let total_pages: Int
    let feature: String
    let photos: [Photos]
}

struct Photos:Codable{
    let image_url: [String]
    let user_id: Int
    let votes_count: Int
    let name: String
    let description: String
}
