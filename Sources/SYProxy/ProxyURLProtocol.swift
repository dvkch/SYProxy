//
//  SYProxyURLProtocol.h
//  Proxy
//
//  Created by Stanislas Chevallier on 02/06/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

import Foundation

/**
 *  http://eng.kifi.com/customizing-uiwebview-requests-with-nsurlprotocol/
 *  http://stackoverflow.com/questions/16847858/ios-any-body-knows-how-to-add-a-proxy-to-nsurlrequest
 */

public protocol ProxyURLProtocolDataSource: NSObjectProtocol {
    func proxyURLProtocolRequiresFirstProxyMatching(url: URL) -> Proxy?
}

public class ProxyURLProtocol: URLProtocol {
    
    // MARK: Init
    public static func register() {
        URLProtocol.registerClass(Self.self)
    }
    
    // MARK: Properties
    public static weak var dataSource: ProxyURLProtocolDataSource?
    public static var isLoggingEnabled: Bool = false
    private var currentTask: URLSessionDataTask?
    
    // MARK: Overrides
    public override class func canInit(with request: URLRequest) -> Bool {
        if let url = request.url, let proxy = dataSource?.proxyURLProtocolRequiresFirstProxyMatching(url: url) {
            return true
        }
        return false
    }
    
    public override func startLoading() {
        guard let url = request.url, let proxy = type(of: self).dataSource?.proxyURLProtocolRequiresFirstProxyMatching(url: url) else {
            fatalError("Cannot find proxy for URL \(request.url?.absoluteString ?? "<nil>"). Be sure to set ProxyURLProtocol.dataSource")
        }
        
        if type(of: self).isLoggingEnabled {
            print("Using proxy \(proxy.host):\(proxy.port) to load \(url.absoluteString)")
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.connectionProxyDictionary = [
            kCFNetworkProxiesHTTPEnable: true,
            kCFNetworkProxiesHTTPProxy: proxy.host,
            kCFNetworkProxiesHTTPPort: proxy.port
        ]
        
        #if os(macOS)
        configuration.connectionProxyDictionary?[kCFNetworkProxiesHTTPSEnable] = true
        configuration.connectionProxyDictionary?[kCFNetworkProxiesHTTPSProxy] = proxy.host
        configuration.connectionProxyDictionary?[kCFNetworkProxiesHTTPSPort] = proxy.port
        #endif
        
        if let username = proxy.username, !username.isEmpty {
            configuration.connectionProxyDictionary?[kCFProxyUsernameKey] = username
            if let password = proxy.password, !password.isEmpty {
                configuration.connectionProxyDictionary?[kCFProxyPasswordKey] = password
            }
        }
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        currentTask = session.dataTask(with: request)
        currentTask?.resume()
    }
    
    public override func stopLoading() {
        currentTask?.cancel()
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}

extension ProxyURLProtocol: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let sender = ProxySessionChallengeSender(sessionCompletionHandler: completionHandler)
        client?.urlProtocol(self, didReceive: .init(authenticationChallenge: challenge, sender: sender))
    }
}
