//
//  MoreViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 28/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI
class MoreViewController: BaseViewController,UIAlertViewDelegate , MFMailComposeViewControllerDelegate {
   
    var alertType : String = "Logout"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Dashboard"
    }
    
    
    func deleteNumberBtnPressed() {
        self.alertType = "DeletePhone"
        let defaults = UserDefaults.standard;
        let userNum = defaults.value(forKeyPath: "userData.phoneNumber") as! String
        
        if userNum.isEmpty {
            let alert :UIAlertView = UIAlertView(title: "", message: "No number is saved", delegate: nil, cancelButtonTitle: "OK")
            alert.show();
        }
        else {
            //UIAlertView(title: "", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK", nil)
//            let alert :UIAlertView = UIAlertView(title: "Are you sure", message: "Want to delete your Number?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
//            alert.show();
            
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DeleteViewController") as? DeleteViewController{
                
                
                controller.yesButtonPressed = {[unowned self] in
                    self.deletePhone()
                }
                controller.cancelButtonPressed = {
                    controller.dismiss(animated: true, completion: nil)
                }
                self.present(controller, animated: true, completion: nil)
            }
        }
        
    }
    func deletePhone(){
        if !self.isReachable() {
            return
        }
        self.view.isUserInteractionEnabled = false
        self.showActivityIndicator()
        
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        let arrParam : Parameters = ["userId" : userId]
        
        Alamofire.request(baseUrl + "deletePhone", parameters: arrParam)
            .responseJSON { response in
                
                if let jsonResponse = response.result.value as? NSDictionary{
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        let defaults = UserDefaults.standard;
                        defaults.set(jsonResponse.value(forKey: "data"), forKey: "userData");
                        defaults.synchronize();
                        self.alert("Number Deleted Successfully")
                        // self.navigationController?.popViewControllerAnimated(true)
                    }
                    else {
                        self.alert(jsonResponse["msg"] as! String)
                    }
                }
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
        }
    }
    
    
    
    
    func openPrivacy() {
        
        let privacyController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_PRIVACY)
        
        self.navigationController?.pushViewController(privacyController!, animated: true)
    }
    
    func openTerms() {
        
        let termsController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_TERMS)
        
        self.navigationController?.pushViewController(termsController!, animated: true)
    }
    @IBAction func logoutBtnPressed(_ sender: AnyObject) {
        
        self.alertType = "Logout"
        let alert :UIAlertView = UIAlertView(title: "", message: "Are you sure?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Logout")
        alert.show();
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1 {
            
            if(self.alertType == "DeletePhone"){
                self.deletePhone()
                return
            }
            
            let defaults = UserDefaults.standard;
            let userId = defaults.value(forKeyPath: "userData.user_id") as! String
            self.view.isUserInteractionEnabled = false
            
            self.showActivityIndicator()
            let param : Parameters = ["userId" : userId]
            Alamofire.request(baseUrl + "logout", parameters: param)
                .responseJSON { response in
                    
                    if let jsonResponse = response.result.value  as? NSDictionary{
                        
                        if (jsonResponse["status"] as! String == "SUCCESS") {
                            
                            defaults.removeObject(forKey: "userData")
                            defaults.synchronize();
                            let loginController = self.storyboard!.instantiateViewController(withIdentifier: SEGUE_LOGIN); UIApplication.shared.keyWindow?.rootViewController = loginController;
                            self.dismiss(animated: true, completion: { () -> Void in
                                
                            });
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
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch (result.rawValue) {
        case MFMailComposeResult.sent.rawValue:
            //let alert = UIAlertView.alloc()
            break;
        default:
            break;
        }
        controller.dismiss(animated: true, completion: nil);
    }
    
    private func pushController(identifier:String){
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: identifier){
            self.navigationController?.pushViewController(controller, animated:true)
        }
    }
    @IBAction func notification(_ sender: Any) {
        self.pushController(identifier: "HomeViewController")
    }
    
    @IBAction func index(_ sender: Any) {
        self.pushController(identifier: "IndexViewController")
    }
    @IBAction func friends(_ sender: Any) {
        self.pushController(identifier: "FriendsViewController")
    }
    @IBAction func profile(_ sender: Any) {
        self.pushController(identifier: "ProfileViewController")
    }
    
    @IBAction func deleteNumber(_ sender: Any) {
        self.deleteNumberBtnPressed()
    }
    
    @IBAction func blocked(_ sender: Any) {
        
        let unblockController = self.storyboard?.instantiateViewController(withIdentifier: "UnblockViewController") as? UnblockViewController
        print("HERe")
        self.navigationController?.pushViewController(unblockController!, animated: true)
    }
    
    @IBAction func share(_ sender: Any) {
        let shareContent: String = "Just got a PushWosh. Subscribe here https://itunes.apple.com/gb/app/push-note/id962393538?mt=8"
        print(shareContent)
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func rate(_ sender: Any) {
        
        let urlStr: String = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=962393538&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        UIApplication.shared.openURL(URL(string: urlStr)!)
        
    }
    
    @IBAction func feedback(_ sender: Any) {
        
        if (MFMailComposeViewController.canSendMail()) {
            
            let mailComposer = MFMailComposeViewController();
            mailComposer.mailComposeDelegate = self;
            mailComposer.setToRecipients(["feedback@ipushnote.com"]);
            mailComposer.setSubject("PushWosh Feeback");
            //mailComposer.setMessageBody("", isHTML: false);
            self.present(mailComposer, animated: true, completion: nil);
        }
    }
    
    @IBAction func weather(_ sender: Any) {
        
        let weatherController = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
        self.navigationController?.pushViewController(weatherController!, animated: true)
    }
    
    @IBAction func settings(_ sender: Any) {
        self.pushController(identifier: "SettingViewController")
    }
    @IBAction func logout(_ sender: Any) {
        self.alertType = "Logout"
        let alert  = UIAlertView(title: "", message: "Are you sure?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Logout")
        alert.show();
    }
}

extension MoreViewController{
    
}
