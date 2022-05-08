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
    var mWebView: WKWebView? = nil
    
//    enum WebURL {
//        static let privacyPolicy: String = "https://www.privacypolicies.com/live/6de37506-6a29-4eeb-b813-f150e4ca0610"
//        static let eula: String = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
//    }
    
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadURL(urlString: url)
        setupBackButton()
        
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
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
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}
