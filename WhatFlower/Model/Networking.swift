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
        "prop": "extracts",
        "exintro": "",
        "explaintext": "",
        "indexpageids": "",
        "redirects": "1"
    ]
    
    func getInfo(for flower: String, completition: @escaping (String) -> Void) {
        var parameters = baseParameters
        parameters["titles"] = flower
        
        AF.request(baseUrl, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseData { (response) in
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let dataFlower = try decoder.decode(DataFlowerBatch.self, from: data)
                        let description = dataFlower.query.pages[dataFlower.query.pageids.first!]!.extract
                        completition(description)
                    } catch {
                        print(error)
                    }
                }
        }
    }
}
