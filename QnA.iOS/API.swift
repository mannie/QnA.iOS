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

    private static let info = Bundle.main.apiValues
    internal static let bot = API(key: info.key, knowledgebase: info.knowledgebase)
    
}

fileprivate extension Bundle {
    
    fileprivate var apiValues: (key: String, knowledgebase: String) {
        guard
            let url = url(forResource: "API", withExtension: "plist"),
            let info = NSDictionary(contentsOf: url) as? [String:String],
            let key = info["Key"],
            let knowledgebase = info["Knowledgebase"],
            !key.isEmpty, !knowledgebase.isEmpty else {
                fatalError("Failed to load or parse API info")
        }
        return (key: key, knowledgebase: knowledgebase)
    }
    
}
