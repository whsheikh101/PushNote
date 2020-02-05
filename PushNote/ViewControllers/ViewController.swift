//
//  ViewController.swift
//  PushNote
//
//  Created by Rizwan on 11/6/14.
//  Copyright (c) 2014 com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var homeViewController: HomeViewController!
    var navController: UINavigationController!
    
    var is1st: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.is1st {
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.startLogin), userInfo: nil, repeats: false)
            self.is1st = false
        }
        else {
            startLogin()
        }
    }
    
    @objc func startLogin() {
        
        let defaults = UserDefaults.standard;
        
        if defaults.object(forKey: "userData") != nil {
            navController = self.storyboard?.instantiateViewController(withIdentifier: "NavC") as! UINavigationController
            //navController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            self.present(navController, animated: true, completion: nil);
        }
        else {
            homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            //homeViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            self.present(homeViewController, animated: true, completion: nil);
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


