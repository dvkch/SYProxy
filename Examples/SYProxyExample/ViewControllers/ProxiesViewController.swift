//
//  ProxiesViewController.swift
//  SYProxyExample
//
//  Created by syan on 14/04/2024.
//  Copyright © 2024 Syan. All rights reserved.
//

import UIKit
import SYProxy

class ProxiesViewController: UIViewController {
    
    // MARK: init
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Views
    @IBOutlet private var tableView: UITableView!
    
    // MARK: Actions
    @IBAction private func buttonCloseTap() {
        dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToEdit", let vc = segue.destination as? EditProxyViewController, let indexPath = tableView.indexPathForSelectedRow {
            vc.proxy = AppDelegate.obtain.proxies[indexPath.row]
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


extension ProxiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.obtain.proxies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellProxy", for: indexPath) as! ProxyCell
        cell.proxy = AppDelegate.obtain.proxies[indexPath.row]
        return cell
    }
}

extension ProxiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToEdit", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            AppDelegate.obtain.removeProxy(AppDelegate.obtain.proxies[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
