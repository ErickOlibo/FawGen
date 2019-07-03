//
//  AboutViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 07/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {
    
    // MARK: - Properties
    var aboutURL: URL?
    
    
    // MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    // MARK: - ViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = FawGenColors.primary.color
        loadURL()
    }
    
    /// Loads the content of the URL to the Webview
    /// - Note: aboutURL must be set to see the page
    private func loadURL() {
        guard let url = aboutURL else { return }
        spinner.startAnimating()
        webView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
}



extension AboutViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        spinner.stopAnimating()
        webView.backgroundColor = .white
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
        webView.backgroundColor = .white
    }
}
