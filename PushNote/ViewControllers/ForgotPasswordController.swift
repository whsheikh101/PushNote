//
//  LoginViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 26/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit
import Alamofire
class ForgotPasswordController: BaseViewController {
    
  
    @IBOutlet weak var textFieldUsername: TextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "RECOVER PASSWORD"
        self.addBackBtn()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
   
    @IBAction func forgotPasscodeBtnPressed(_ sender: AnyObject, forEvent event: UIEvent) {
        
       
        if (textFieldUsername.text!.isEmpty) {
            
            self.alert("Email is required")
        }
        else {
            
            if !self.isReachable() {
                return
            }
           self.textFieldUsername.resignFirstResponder()
            self.showActivityIndicator(); let params : Parameters = ["username": textFieldUsername.text!]
            Alamofire.request(baseUrl + "forgotpassword", parameters:params)
                .responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let jsonResponse = response.result.value as? NSDictionary{
                        if (jsonResponse["status"] as! String == "SUCCESS") {
                            
                           self.alert((jsonResponse["msg"] as! String))
                           self.textFieldUsername.text = ""
                        }else{
                            if let respMsg = jsonResponse["msg"] as? String{
                                self.alert(respMsg)
                            }
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
