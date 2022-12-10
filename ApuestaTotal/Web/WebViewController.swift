//
//  WebViewController.swift
//  Bet3
//
//  Created by mac on 27.10.2022.
//

import UIKit
import WebKit

class WebViewController: BaseVC {
    
    let url: URL
    
    private let webView = WKWebView()
    
    init(url: URL, coordinator: Coordinator? = nil) {
        self.url = url
        super.init(coordinator: coordinator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clay
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        webView.load(URLRequest(url: url))
    }
    
}
