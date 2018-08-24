//  DetailViewController.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-14.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var link: URL? {
        get {
            return self.link
        }
        set(url) {
            if let url = url {
                if Reachability.isConnectedToNetwork() == true {
                    self.request = URLRequest(url: url,
                                              cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                              timeoutInterval: 10.0)
                }
                else {
                    self.navigationController?.popViewController(animated: true)
                    //Reachability.showNoConnectionAlert()
                }
            }
        }
    }
    
    var request: URLRequest?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        spinner.stopAnimating()
        if let webview = webview,
            let request = request {
            webview.delegate = self
            webview.loadRequest(request)
            spinner.isHidden = false
            spinner.startAnimating()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        request = URLRequest(url: URL(string: "about:blank")!)
        webview.loadRequest(request!)
        URLCache.shared.removeAllCachedResponses()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.stopAnimating()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        spinner.stopAnimating()
    }
    
}

