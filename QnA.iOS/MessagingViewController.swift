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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

extension MessagingViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isMyMessage = indexPath.row % 2 == 0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: isMyMessage ? "MyMessageCell" : "BotMessageCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath)"
        return cell
    }
    
}

extension MessagingViewController: UITableViewDelegate {
    
}
