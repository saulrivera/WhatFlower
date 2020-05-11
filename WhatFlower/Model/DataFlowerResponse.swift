//
//  DataFlowerResponse.swift
//  WhatFlower
//
//  Created by Saul Rivera on 10/05/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

import Foundation

struct DataFlowerBatch: Decodable {
    let query: DataFlowerResponse
}

struct DataFlowerResponse: Decodable {
    let pageids: [String]
    let pages: [String: DataFlower]
}

struct DataFlower: Decodable {
    let pageid: Int
    let title: String
    let extract: String
}
