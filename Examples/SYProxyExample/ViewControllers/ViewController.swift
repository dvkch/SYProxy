//
//  ViewController.swift
//  SYProxyExample
//
//  Created by syan on 14/04/2024.
//  Copyright © 2024 Syan. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SYProxy"
        searchField.delegate = self
        searchField.tintColor = .gray
        searchField.searchTextField.rightView = UIActivityIndicatorView(style: .medium)
        webView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButtons()
    }
    
    // MARK: Properties
    @IBOutlet private var webView: UIWebView! // WKWebView doesn't support custom URLProtocol
    @IBOutlet private var buttonBack: UIBarButtonItem!
    @IBOutlet private var buttonNext: UIBarButtonItem!
    @IBOutlet private var buttonRefresh: UIBarButtonItem!
    @IBOutlet private var searchField: UISearchBar!

    private var isLoading: Bool = false
    private var lastLoadedURL: URL? = nil
    
    // MARK: Actions
    @IBAction private func buttonBackTap() {
        webView.goBack()
        updateButtons()
    }

    @IBAction private func buttonNextTap() {
        webView.goForward()
        updateButtons()
    }

    @IBAction private func buttonRefreshTap() {
        if webView.request?.url?.absoluteString != "about:blank" {
            webView.reload()
        }
        else if let lastLoadedURL {
            webView.loadRequest(URLRequest(url: lastLoadedURL))
        }
        updateButtons()
    }

    // MARK: Content
    private func updateButtons() {
        buttonBack.isEnabled = webView.canGoBack
        buttonNext.isEnabled = webView.canGoForward
        buttonRefresh.isEnabled = !webView.isLoading
        searchField.searchTextField.rightViewMode = webView.isLoading ? .always : .never
        (searchField.searchTextField.rightView as? UIActivityIndicatorView)?.startAnimating()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        let query = searchBar.text ?? ""
        let linkDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = linkDetector?.matches(in: query, options: .anchored, range: NSRange(location: 0, length: (query as NSString).length))
        
        if let match = matches?.first, let url = match.url {
            webView.loadRequest(URLRequest(url: url))
        }
        else {
            webView.loadRequest(URLRequest(url: .init(googleSearchQuery: query)))
        }
    }
}

extension ViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if let url = request.url, url.absoluteString != "about:blank" {
            lastLoadedURL = url

            if let proxy = AppDelegate.obtain.proxyURLProtocolRequiresFirstProxyMatching(url: url) {
                print("Should use proxy \(proxy.host):\(proxy.port) for \(url)")
            }
            else {
                print("No proxy configured for \(url)")
            }
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        isLoading = true
        updateButtons()
        title = "Loading..."
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        isLoading = false
        updateButtons()
        title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: any Error) {
        isLoading = false
        updateButtons()
        
        let htmlErrorURL = Bundle.main.url(forResource: "error", withExtension: "html")!
        let htmlError = try! String(contentsOf: htmlErrorURL).replacingOccurrences(of: "{ERROR}", with: error.localizedDescription)
        webView.loadHTMLString(htmlError, baseURL: nil)
    }
}
