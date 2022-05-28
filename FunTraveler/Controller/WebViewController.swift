//
//  WebViewController.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/8.
//

import UIKit
import WebKit
import SwiftUI

class WebViewController: UIViewController {
    
    private var mWebView: WKWebView?
    var webUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL(urlString: webUrl)
        setupBackButton()
    }
    
    private func loadURL(urlString: String) {
        let url = URL(string: urlString)
        if let url = url {
            let request = URLRequest(url: url)
            mWebView = WKWebView(frame: self.view.frame)
            if let mWebView = mWebView {
                mWebView.navigationDelegate = self
                mWebView.load(request)
                self.view.addSubview(mWebView)
                self.view.sendSubviewToBack(mWebView)
            }
        }
    }
    
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}

extension WebViewController {
    private func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
