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

    @IBOutlet weak var textFieldPasscode: TextField!
    @IBOutlet weak var textFieldUsername: TextField!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.title = "SIGN IN"
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard;
        
        if defaults.object(forKey: "userData") != nil {
            let tabController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_TAB)
           // self.navigationController?.pushViewController(tabController!, animated: true)
            
           // self.present(tabController!, animated: true, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController = tabController;
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func recoverPasswordBtnPressed(_ sender: AnyObject) {
        let forgotPassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as! ForgotPasswordController
       //self.presentViewController(forgotPassword, animated: true, completion: nil)
        self.navigationController?.pushViewController(forgotPassword, animated: true)
        
    }
    @IBAction func actionLogin(_ sender: AnyObject) {
        
        let tabController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_TAB)
        self.present(tabController!, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: AnyObject, forEvent event: UIEvent) {
        
        if (textFieldUsername.text!.isEmpty || textFieldPasscode.text!.isEmpty) {
            self.alert("Both fields required")
        }
        else {
            textFieldUsername.resignFirstResponder()
            textFieldPasscode.resignFirstResponder()
            if !self.isReachable() {
                return
            }
           // self.textFieldDummy.resignFirstResponder()
            self.showActivityIndicator()
            let params : Parameters = ["username": textFieldUsername.text!, "password": textFieldPasscode.text!];
            Alamofire.request(baseUrl + "login", parameters:params)
                .responseJSON { response in
                   
                    if let jsonResponse = response.result.value as? NSDictionary {
                       if (jsonResponse["status"] as! String == "SUCCESS") {
                            
                            let defaults = UserDefaults.standard;
                            defaults.set(jsonResponse.value(forKey: "data"), forKey: "userData");
                            defaults.synchronize();
                            self.textFieldUsername.text = ""
                            self.textFieldPasscode.text = ""
                            let tabController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_TAB); UIApplication.shared.keyWindow?.rootViewController = tabController
                            self.present(tabController!, animated: true, completion: nil)
                            //self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        else {
                            let str: String = jsonResponse["msg"] as! String
                            self.alert(str)
                        }
                    }
                    self.hideActivityIndicator()
                    
            }
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
