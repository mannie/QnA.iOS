//
//  API.swift
//  QnA.iOS
//
//  Created by Mannie Tagarira on 4/14/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

internal struct API {
    
    internal let key: String
    internal let knowledgebase: String

    private static let info = Bundle.main.api
    internal static let bot = API(key: info["Key"] ?? "", knowledgebase: info["Knowledgebase"] ?? "")
    
}

fileprivate extension Bundle {
    
    fileprivate typealias APIInfoDictionary = [String:String]
    fileprivate var api: APIInfoDictionary {
        guard
            let url = url(forResource: "API", withExtension: "plist"),
            let apis = NSDictionary(contentsOf: url) as? APIInfoDictionary else {
                fatalError("Failed to load or parse API info")
        }
        return apis
    }
    
}
