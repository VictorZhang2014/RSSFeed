//
//  RFWebViewViewController.swift
//  RSSFeed
//
//  Created by victor on 28/03/2018.
//  Copyright © 2018 victor. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

public class RFWebViewViewController: UIViewController {

    public var artistName: String?
    public var artistUrl: String?
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.artistName

        let webViewConfig = WKWebViewConfiguration()
        let webView = WKWebView(frame: CGRect(), configuration: webViewConfig)
        self.view.addSubview(webView)
        if  let _artistUrl = artistUrl,
            let url = URL(string: _artistUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        webView.snp.makeConstraints {
            $0.edges.equalTo(self.view)
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeVC))
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
