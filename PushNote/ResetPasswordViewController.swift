//
//  EditAccountViewController.swift
//  PushNote
//
//  Created by Rizwan on 11/6/14.
//  Copyright (c) 2014 com. All rights reserved.
//

import UIKit
import Alamofire

class ResetPasswordViewController: BaseViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var textFieldCurrentPasscode: UITextField!
    @IBOutlet weak var textFieldNewPasscode: UITextField!
    @IBOutlet weak var textFieldVerifyPasscode: UITextField!
    
    @IBOutlet weak var viewEdit: UIView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.addBackBtn()
        self.title = "RESET PASSWORD"
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44));
        let itemDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(ResetPasswordViewController.doneBtnPressed(_:)));
        toolbar.setItems([itemDone], animated: true);
        
        textFieldCurrentPasscode.inputAccessoryView = toolbar;
        textFieldNewPasscode.inputAccessoryView = toolbar;
        textFieldVerifyPasscode.inputAccessoryView = toolbar;
    }
    
    @objc func doneBtnPressed(_ sender: AnyObject) {
        textFieldCurrentPasscode.resignFirstResponder();
        textFieldNewPasscode.resignFirstResponder();
        textFieldVerifyPasscode.resignFirstResponder();
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder();
    }
    
   
    
 
    
    @IBAction func saveBtnPressed(_ sender: AnyObject) {
        
        doneBtnPressed(self)
        
        if textFieldCurrentPasscode.text!.isEmpty || textFieldNewPasscode.text!.isEmpty || textFieldVerifyPasscode.text!.isEmpty {
            
            let alert :UIAlertView = UIAlertView(title: "", message: "One or more field is empty", delegate: nil, cancelButtonTitle: "OK")
            alert.show();
        }
        else {
            
            if textFieldNewPasscode.text != textFieldVerifyPasscode.text {
                
                let alert :UIAlertView = UIAlertView(title: "", message: "Passcode mismatch", delegate: nil, cancelButtonTitle: "OK")
                alert.show();
            }
            else {
                
                let defaults = UserDefaults.standard;
                let userPass = defaults.value(forKeyPath: "userData.password") as! String
                
                if textFieldCurrentPasscode.text != userPass {
                    let alert :UIAlertView = UIAlertView(title: "", message: "Current Passcode is Invalid", delegate: nil, cancelButtonTitle: "OK")
                    alert.show();
                }
                else {
                    
                    if !self.isReachable() {
                        return
                    }
                    
                    self.view.isUserInteractionEnabled = false
                    self.showActivityIndicator()
                    
                    let userId = defaults.value(forKeyPath: "userData.user_id") as! String
                    var arrParam : Parameters = ["userID" : userId]
                    arrParam["passcode"] = textFieldNewPasscode.text
                  
                    Alamofire.request(baseUrl + "editAccount", parameters: arrParam)
                        .responseJSON { response in
                            
                            if let jsonResponse = response.result.value as? NSDictionary {
                                if (jsonResponse["status"] as! String == "SUCCESS") {
                                    
                                    let defaults = UserDefaults.standard;
                                    defaults.set(jsonResponse.value(forKey: "data"), forKey: "userData");
                                    defaults.synchronize();
                                    
                                    self.navigationController?.popViewController(animated: true)
                                }
                                else {
                                    let alert :UIAlertView = UIAlertView(title: "", message: jsonResponse["msg"] as? String, delegate: nil, cancelButtonTitle: "OK")
                                    alert.show();
                                }
                            }
                            self.view.isUserInteractionEnabled = true
                            self.hideActivityIndicator()
                    }
                }
            }
        }
    }
}

