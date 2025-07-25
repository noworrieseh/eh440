//
//  WKViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-26.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit
import WebKit

class WKViewController: ContentViewController, UIWebViewDelegate, WKNavigationDelegate {
    
//    var webView: WKWebView!
// Switched to UIWebView as Universal links don't work with WKWebView
    var webView: UIWebView!
    var backButton: UIBarButtonItem!
    var url: String = ""
    var html: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.target = self
        backButton.action = #selector(WKViewController.rightButtonPress)
        self.navigationItem.setRightBarButton(backButton, animated: false)
        
//        self.webView = WKWebView()
//        self.webView.navigationDelegate = self
        self.webView = UIWebView()
        self.view = self.webView
        
        if url.isEmpty {
            self.webView!.loadHTMLString(html, baseURL: nil)
        } else {
            let requestURL = URL(string:url)
            let request = URLRequest(url: requestURL!)
            self.webView!.loadRequest(request)
        } // if

    } // viewDidLoad()
    
    @objc func rightButtonPress(sender: AnyObject?) {
        print("Button pressed")
        webView.goBack()
    } // rightButtonPress()

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    } // Web: Start load
////    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("decide")
        decisionHandler(.allow)
    } // Web: Navigation action policy
    
} // WKViewController()

