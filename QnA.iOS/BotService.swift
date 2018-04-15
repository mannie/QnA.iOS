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
    private let newMessageHandler: NewMessageHandler?
    private let queue = DispatchQueue(label: "Messages")
    
    internal init(api: API, newMessageHandler: NewMessageHandler?) {
        self.newMessageHandler = newMessageHandler
    }
    
    internal func post(message body: String) {
        let message = Message(sender: .me, body: body)
        invokeNewMessageHandler(message: message)
        post(message: message)
    }
    
    private func post(message: Message) {
        DispatchQueue.global().async { [weak self] in
            Thread.sleep(forTimeInterval: 2)
            
            let message = Message(sender: .bot, body: "-> \(message.body)")
            self?.invokeNewMessageHandler(message: message)
        }
    }
    
    private func invokeNewMessageHandler(message: Message) {
        queue.sync {
            let index = messages.count
            messages.append(message)
            newMessageHandler?(index, message)
        }
    }
    
}
