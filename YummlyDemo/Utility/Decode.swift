//
//  Codable.swift
//  YummlyDemo
//
//  Created by Kevin Malek on 7/14/23 in Goldfish.
//

import Foundation

class Decode {
  public static func loadJSON<ParsedType: Codable>(name: String, decodingType: ParsedType.Type) -> ParsedType? {
    guard let path = Bundle.main.path(forResource: name, ofType: "json"),
    let jsonString = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue),
    let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue),
    let dictionaryData = try? JSONSerialization.jsonObject(with: jsonData),
    let serializedData = try? JSONSerialization.data(withJSONObject: dictionaryData, options: .fragmentsAllowed),
    let decodedObject = try? JSONDecoder().decode(decodingType, from: serializedData)
    else { return nil }
    return decodedObject
  }
}
