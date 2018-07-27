//
//  Kitten.swift
//  CoreDataApp1
//
//  Created by Denis Voronov on 27/07/2018.
//  Copyright © 2018 EvergreenBits. All rights reserved.
//

import Foundation

struct TumblrRoot : Codable {
    let meta: TumblrMeta
    let response: TumblrResponse
}

struct TumblrMeta : Codable {
    let msg: String
    let status: Int
}

struct TumblrResponse : Codable {
    let blog: TumblrBlog
    let posts: [TumblrPost]
}

struct TumblrBlog : Codable {
    let name: String
    let posts: Int
    let title: String
    let total_posts: Int
    let url: URL
}

enum TumblrPostType : String, Codable{
    case photo
}

struct TumblrPost : Codable {
    let id: Int64
    let type: TumblrPostType
    let blog_name: String
    let post_url: URL
    let slug: String
    let summary: String
    let post_author: String
    let source_url: URL
    let source_title: String
    let caption: String
    let image_permalink: URL
    let photos: [TumblrPhoto]
}

struct TumblrPhoto : Codable {
    let caption: String
    let original_size: TumblrPhotoSize
    let alt_sizes: [TumblrPhotoSize]
}

struct TumblrPhotoSize : Codable {
    let url: URL
    let width: Int
    let height: Int
}
