//
//  AboutTextViewController.swift
//  PushNote
//
//  Created by Rizwan on 1/19/15.
//  Copyright (c) 2015 com. All rights reserved.
//

import UIKit

class AboutTextViewController: BaseViewController {
    
    var myTitle: String = ""
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackBtn()
        self.navigationItem.title = myTitle 
        
        var path: String

        if self.myTitle == "About" {
            path = Bundle.main.path(forResource: "about", ofType: "html")!
        }
        else if self.myTitle == "Privacy Policy" {
            path = Bundle.main.path(forResource: "privacy", ofType: "html")!
        }
        else {
            path = Bundle.main.path(forResource: "terms", ofType: "html")!
        }
        let request: URLRequest = URLRequest(url: URL(fileURLWithPath: path))
        self.webView.loadRequest(request)
    }
    
}
