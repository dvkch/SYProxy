//
//  AppDelegate.swift
//  SYProxyExample
//
//  Created by Stan Chevallier on 02/10/2015.
//  Copyright (c) 2015 Syan. All rights reserved.
//

import UIKit
import SYProxy

@main
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // MARK: AppDelegate
    static var obtain: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        proxies = readProxies()
        
        ProxyURLProtocol.dataSource = self
        ProxyURLProtocol.isLoggingEnabled = true
        ProxyURLProtocol.register()

        return true
    }

    // MARK: Proxies storage
    private var proxyStorageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("proxies", isDirectory: false)
    private func readProxies() -> [Proxy] {
        guard let data = try? Data(contentsOf: proxyStorageURL) else { return [] }
        return try! NSKeyedUnarchiver.unarchivedObject(ofClasses: .init([NSArray.self, Proxy.self]), from: data) as! [Proxy]
    }
    private func writeProxies(_ proxies: [Proxy]) {
        let data = try! NSKeyedArchiver.archivedData(withRootObject: proxies, requiringSecureCoding: true)
        try! data.write(to: proxyStorageURL)
    }

    // MARK: Proxies
    var proxies: [Proxy] = [] {
        didSet {
            writeProxies(proxies)
        }
    }

    func addProxy(_ proxy: Proxy) {
        if let index = proxies.firstIndex(of: proxy) {
            proxies.replaceSubrange(index..<(index + 1), with: [proxy])
        }
        else {
            proxies.append(proxy)
        }
    }

    func removeProxy(_ proxy: Proxy) {
        proxies.removeAll(where: { $0.identifier == proxy.identifier })
    }
}

extension AppDelegate: ProxyURLProtocolDataSource {
    func proxyURLProtocolRequiresFirstProxyMatching(url: URL) -> Proxy? {
        return proxies.first(matching: url)
    }
}
