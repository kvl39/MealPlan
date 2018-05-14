//
//  MPRecipeDetailWebViewController.swift
//  MealPlan
//
//  Created by Liao Kevin on 2018/5/14.
//  Copyright © 2018年 Kevin Liao. All rights reserved.
//

import UIKit

class MPRecipeDetailWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string: "https://google.com.tw")!))
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
    
    
}
