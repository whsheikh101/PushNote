//
//  ViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 25/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    
    var homeViewController: HomeViewController!
    var is1st: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(SplashViewController.startLogin), userInfo: nil, repeats: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.is1st {
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(SplashViewController.startLogin), userInfo: nil, repeats: false)
            self.is1st = false
        }
        else {
            startLogin()
        }
    }
    
    func openLogin() {
        
        
    }

    @objc func startLogin() {
        
        let defaults = UserDefaults.standard;
        
        if defaults.object(forKey: "userData") != nil {
            let tabController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_TAB)
            self.present(tabController!, animated: true, completion: nil)
        }
        else {
            let loginController = self.storyboard!.instantiateViewController(withIdentifier: SEGUE_LOGIN)
            [self .present(loginController, animated: true, completion: nil)]
            
        }
    }


}

