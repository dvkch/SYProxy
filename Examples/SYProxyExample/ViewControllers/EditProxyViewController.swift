//
//  EditProxyViewController.swift
//  SYProxyExample
//
//  Created by syan on 14/04/2024.
//  Copyright © 2024 Syan. All rights reserved.
//

import UIKit
import SYProxy

class EditProxyViewController: UIViewController {
    
    // MARK: UIViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let proxy {
            title = "Edit Proxy"
            fieldHost.text = proxy.host
            fieldPort.text = String(proxy.port)
            fieldUser.text = proxy.username
            fieldPass.text = proxy.password
            fieldRule.text = proxy.urlWildcardRules.first
        }
        else {
            title = "New Proxy"
        }
    }
    
    // MARK: Properties
    var proxy: Proxy?
    
    // MARK: Views
    @IBOutlet private var fieldHost: UITextField!
    @IBOutlet private var fieldPort: UITextField!
    @IBOutlet private var fieldUser: UITextField!
    @IBOutlet private var fieldPass: UITextField!
    @IBOutlet private var fieldRule: UITextField!
    
    // MARK: Actions
    @IBAction private func buttonSaveTap() {
        guard
            let host = fieldHost.text, !host.isEmpty,
            let portString = fieldPort.text, let port = UInt16(portString, radix: 10), port > 0,
            let rule = fieldRule.text, !rule.isEmpty
        else {
            let alert = UIAlertController(title: "Incomplete data", message: "Mandatory fields are: host, port and rule", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        let proxy = self.proxy ?? .init(host: host, port: port)
        proxy.host = host
        proxy.port = port
        proxy.username = fieldUser.text?.isEmpty == true ? nil : fieldUser.text
        proxy.password = fieldPass.text?.isEmpty == true ? nil : fieldPass.text
        proxy.urlWildcardRules = [rule]
        
        AppDelegate.obtain.addProxy(proxy)
        navigationController?.popViewController(animated: true)
    }
}

extension EditProxyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let fields = [fieldHost, fieldPort, fieldUser, fieldPass, fieldRule]
        if let index = fields.firstIndex(of: textField), index + 1 < fields.count {
            fields[index + 1]?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
}
