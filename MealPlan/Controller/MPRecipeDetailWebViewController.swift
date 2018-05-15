//
//  MPRecipeDetailWebViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/14.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit
import WebKit

class MPRecipeDetailWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
        
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(URLRequest(url: URL(string: "https://google.com.tw")!))
        progressBar.tintColor = UIColor.red
        progressBar.progress = 0.0
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressBar.isHidden = webView.estimatedProgress == 1
            progressBar.setProgress(Float(webView.estimatedProgress), animated: false)
        }
    }
    


    @IBAction func doneWebView(_ sender: Any) {
    }
    
    
    
    @IBAction func refreshWebView(_ sender: Any) {
        webView.reload()
    }
    
    
    
    @IBAction func backWebView(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
}
