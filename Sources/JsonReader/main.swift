//
//  main.swift
//  JsonReader
//
//  Created by Arthur MASSON on 1/19/18.
//  Copyright © 2018 Arthur MASSON. All rights reserved.
//

import Foundation

print("Hello, World!")

let fileName = "/Users/acarotin/Swift/JsonReader/Sources/JsonReader/file.json"
let url = URL(fileURLWithPath: fileName)
let data = try! Data(contentsOf: url)

let fileContent = String(data: data, encoding: .utf8)

let jsonResult = try JSONSerialization.jsonObject(with: data,
                                                  options: .mutableContainers)

let object = JsonObject(json: jsonResult)

print(object["person"]![0]!["name"]!.stringValue!)
