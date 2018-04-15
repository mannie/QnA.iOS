//
//  MessagingViewController.swift
//  QnA.iOS
//
//  Created by Mannie Tagarira on 4/14/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

internal final class MessagingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageEntry: UITextField!
    @IBOutlet weak var composer: UIView!
    
    fileprivate private(set) var bot: BotService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil, using: handle)
        notificationCenter.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: handle)
        
        bot = BotService(api: .bot, newMessageHandler: { (index, message) in
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: 0)
                let tableView = self.tableView
                tableView?.beginUpdates()
                tableView?.insertRows(at: [indexPath], with: .bottom)
                tableView?.endUpdates()
                tableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        })
    }
    
    private func handle(keyboard notification: Notification) {
        guard let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        
        var delta = composer.frame.origin.y
        composer.frame.origin.y = frame.origin.y - composer.frame.height
        delta -= composer.frame.origin.y
        view.frame.size.height -= delta
        
        view.setNeedsLayout()
        
        if let indexPath = tableView.indexPathsForVisibleRows?.last {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    @IBAction func postMessage() {
        guard let text = messageEntry.text else {
            return
        }
        messageEntry.text = nil
        bot.post(message: text)
    }
    
}


extension MessagingViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bot.messages.count
    }
    
    private func cellReuseID(for message: BotService.Message) -> String {
        switch message.sender {
        case .me: return "MyMessageCell"
        case .bot: return "BotMessageCell"
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = bot.messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID(for: message), for: indexPath)
        cell.textLabel?.text = message.body
        return cell
    }
    
}

extension MessagingViewController: UITableViewDelegate {
    
}
