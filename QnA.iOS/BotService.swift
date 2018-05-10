//
//  BotService.swift
//  QnA.iOS
//
//  Created by Mannie Tagarira on 4/14/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

internal final class BotService {
    
    internal struct Message {
        internal enum Participant {
            case me, bot
        }
        internal let sender: Participant
        internal let body: String
    }
    
    internal typealias NewMessageHandler = (Int, Message)->Void
    
    internal private(set) var messages: [Message] = []
    private let queue = DispatchQueue(label: "Messages")

    private let api: API
    private let newMessageHandler: NewMessageHandler?
    
    internal init(api: API, newMessageHandler: NewMessageHandler?) {
        self.api = api
        self.newMessageHandler = newMessageHandler

        DispatchQueue.main.async {
            let intro = Message(sender: .bot, body: "Hi, I'm \(api.name). How may I be of assistance?")
            self.thread(message: intro)
        }
    }
    
    internal func post(message body: String) {
        let message = Message(sender: .me, body: body)
        thread(message: message)
        post(message: message)
    }
    
    private func request(post message: Message) -> URLRequest {
        guard let url = URL(string: "\(api.host)/knowledgebases/\(api.knowledgeBase)/generateAnswer") else {
            fatalError("Invalid knowledgebase identifier found")
        }

        let body = [ "question" : message.body ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("EndpointKey \(api.authKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func post(message: Message) {
        let task = URLSession.shared.dataTask(with: request(post: message)) { (data, response, error) in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:[Any]],
                let answers = json?["answers"] as? [[String:Any]],
                let first = answers.first,
                let answer = first["answer"] as? String else {
                    return
            }
            
            let message = Message(sender: .bot, body: answer)
            self.thread(message: message)
        }
        task.resume()
    }
    
    private func thread(message: Message) {
        queue.sync {
            let index = messages.count
            messages.append(message)
            newMessageHandler?(index, message)
        }
    }
    
}
