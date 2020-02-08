//
//  LoginViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 26/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit
import Alamofire
class LoginViewController: BaseViewController {
    
    @IBOutlet weak var textFieldPassword: TextField?
    @IBOutlet weak var textFieldUsername: TextField?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Login"
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "userData") != nil {
            let tabController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_TAB)
            UIApplication.shared.keyWindow?.rootViewController = tabController;
        }
    }
    
    @IBAction func recoverPasswordBtnPressed(_ sender: AnyObject) {
        let forgotPassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as! ForgotPasswordController
        navigationController?.pushViewController(forgotPassword, animated: true)
    }
    
    @IBAction func actionLogin(_ sender: AnyObject) {
        
        let tabController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_TAB)
        self.present(tabController!, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: AnyObject, forEvent event: UIEvent) {
        
        if textFieldUsername?.text?.isEmpty == true || textFieldPassword?.text?.isEmpty == true {
            alert("Both fields required")
        } else {
            textFieldUsername?.resignFirstResponder()
            textFieldPassword?.resignFirstResponder()
            if !isReachable() {
                return
            }
            showActivityIndicator()
            let params: Parameters = ["username": textFieldUsername?.text ?? "", "password": textFieldPassword?.text ?? ""]
            Alamofire.request(baseUrl + "login", parameters:params)
                .responseJSON { [weak self] response in
                    
                    if let jsonResponse = response.result.value as? NSDictionary {
                        if (jsonResponse["status"] as! String == "SUCCESS") {
                            
                            let defaults = UserDefaults.standard;
                            defaults.set(jsonResponse.value(forKey: "data"), forKey: "userData");
                            defaults.synchronize();
                            self?.textFieldUsername?.text = ""
                            self?.textFieldPassword?.text = ""
                            let tabController = self?.storyboard?.instantiateViewController(withIdentifier: SEGUE_TAB); UIApplication.shared.keyWindow?.rootViewController = tabController
                            self?.present(tabController!, animated: true, completion: nil)
                        }
                        else {
                            let str: String = jsonResponse["msg"] as! String
                            self?.alert(str)
                        }
                    }
                    self?.hideActivityIndicator()
            }
        }
    }
}
