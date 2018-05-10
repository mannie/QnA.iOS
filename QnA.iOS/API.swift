//
//  API.swift
//  QnA.iOS
//
//  Created by Mannie Tagarira on 4/14/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

internal struct API {
    
    internal let name: String
    internal let authKey: String
    internal let knowledgeBase: String
    internal let host: String

    private static let info = Bundle.main.apiValues
    internal static let bot = API(name: info.name, authKey: info.authKey, knowledgeBase: info.knowledgeBase, host: info.host)
    
}

fileprivate extension Bundle {
    
    fileprivate var apiValues: (name: String, authKey: String, knowledgeBase: String, host: String) {
        guard
            let url = url(forResource: "API", withExtension: "plist"),
            let info = NSDictionary(contentsOf: url) as? [String:String],
            let name = info["Name"],
            let authKey = info["AuthKey"],
            let knowledgeBase = info["KnowledgeBase"],
            let host = info["Host"],
            !name.isEmpty, !authKey.isEmpty, !knowledgeBase.isEmpty, !host.isEmpty else {
                fatalError("Failed to load or parse API info")
        }
        return (name: name, authKey: authKey, knowledgeBase: knowledgeBase, host: host)
    }
    
}
