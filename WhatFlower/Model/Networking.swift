//
//  Networking.swift
//  WhatFlower
//
//  Created by Saul Rivera on 10/05/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

import Foundation
import Alamofire

struct Networking {
    
    private let baseUrl = "https://en.wikipedia.org/w/api.php"
    private let baseParameters = [
        "format": "json",
        "action": "query",
        "prop": "extracts|pageimages",
        "exintro": "",
        "explaintext": "",
        "indexpageids": "",
        "redirects": "1",
        "pithumbsize": "500"
    ]
    
    func getInfo(for flower: String, completition: @escaping (String, String) -> Void) {
        var parameters = baseParameters
        parameters["titles"] = flower
        
        AF.request(baseUrl, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseData { (response) in
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let dataFlower = try decoder.decode(DataFlowerBatch.self, from: data)
                        
                        let pageId = dataFlower.query.pageids.first!
                        let pages = dataFlower.query.pages
                        
                        let description = pages[pageId]!.extract
                        let flowerImageUrl = pages[pageId]!.thumbnail.source
                        completition(description, flowerImageUrl)
                    } catch {
                        print(error)
                    }
                }
        }
    }
}
