//
//  PocketBase.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

struct PocketBase<T: Codable>: Codable {
    let page: Int
    let perPage: Int
    let totalItems: Int
    let totalPages: Int
    let items: [T]
}
