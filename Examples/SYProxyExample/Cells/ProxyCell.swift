//
//  ProxyCell.swift
//  SYProxyExample
//
//  Created by Stan Chevallier on 03/10/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

import UIKit
import SYProxy

class ProxyCell: UITableViewCell {
    
    // MARK: Properties
    var proxy: Proxy? {
        didSet {
            updateContent()
        }
    }
    
    // MARK: Views
    @IBOutlet private var labelHostPort: UILabel!
    @IBOutlet private var labelUserPass: UILabel!
    @IBOutlet private var labelRules: UILabel!
    
    // MARK: Content
    private func updateContent() {
        guard let proxy else { return }

        labelHostPort.text = "\(proxy.host):\(proxy.port)"
        
        if let username = proxy.username, let password = proxy.password {
            labelUserPass.text = "\(username):\(password)"
        }
        else if let username = proxy.username {
            labelUserPass.text = username
        }
        else if let password = proxy.password {
            labelUserPass.text = "pw: \(password)"
        }
        else {
            labelUserPass.text = "No auth"
        }
        
        labelRules.text = proxy.urlWildcardRules.map { "• " + $0 }.joined(separator: "\n")
    }
}
