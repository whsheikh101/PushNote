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
class MoreViewController: BaseViewController,UIAlertViewDelegate , MFMailComposeViewControllerDelegate,
UITableViewDelegate,
UITableViewDataSource{
    var alertType : String = "Logout"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTabbar()
        self.navigationItem.title = "MORE"
        
        // Do any additional setup after loading the view.
    }

    func setTabbar() {
       
        self.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "moreTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "more-activeTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal));
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //UITableView integration
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        
        if(section == 0){
            return 2
        }
        else if(section == 1){
            return 4
        }
        else if(section == 2){
            return 4
        }
        else if(section == 3){
            return 1
        }
        
        return 0;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if(indexPath.section == 3){
            cell = tableView.dequeueReusableCell(withIdentifier: "LogoutCell")
        }else {
            let identifier:String = "Cell\(indexPath.section)\(indexPath.row)"
            cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as! UITableViewCell)
        }
        cell?.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // let arrayOfKeys = Array(locationDataDictionary.keys).sort{ $0 > $1 }
        let  headerCell:UITableViewCell?
        headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")

        
        return headerCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section == 3){
            return 15.0
        }
        return 5.0
        
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if(indexPath.section == 2){
             print(indexPath.row)
            switch(indexPath.row){
               
            case 0:
                let aboutController = self.storyboard?.instantiateViewController(withIdentifier: "AboutTextViewController") as? AboutTextViewController
                aboutController!.myTitle = "About"
                self.navigationController?.pushViewController(aboutController!, animated: true)
                break
            case 1:
                let howToViewController = self.storyboard?.instantiateViewController(withIdentifier: "HowItWorksViewController") as? HowItWorksViewController
              
                self.navigationController?.pushViewController(howToViewController!, animated: true)
                break
            case 2:
                let aboutController = self.storyboard?.instantiateViewController(withIdentifier: "AboutTextViewController") as? AboutTextViewController
                aboutController!.myTitle = "Privacy Policy"
                self.navigationController?.pushViewController(aboutController!, animated: true)
                break
            case 3:
                let aboutController = self.storyboard?.instantiateViewController(withIdentifier: "AboutTextViewController") as? AboutTextViewController
                aboutController!.myTitle = "Terms"
                self.navigationController?.pushViewController(aboutController!, animated: true)
                break
            default:
                break
            }
        }else  if(indexPath.section == 0){
            switch(indexPath.row){
                 case 0:
                    self.deleteNumberBtnPressed()
                 break
            case 1:
                let unblockController = self.storyboard?.instantiateViewController(withIdentifier: "UnblockViewController") as? UnblockViewController
                print("HERe")
                self.navigationController?.pushViewController(unblockController!, animated: true)
                break
            default:
                break
            }
        }else  if(indexPath.section == 1){
             switch(indexPath.row){
                case 0:
                    print("Share")
                    let shareContent: String = "Just got a Pushnote. Subscribe here https://itunes.apple.com/gb/app/push-note/id962393538?mt=8"
                    print(shareContent)
                    let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
                    // self.present(activityViewController, animated: true, completion: {})
                    if UIDevice.current.userInterfaceIdiom == .pad {
                           activityViewController.popoverPresentationController?.sourceView = self.view
                           //activityViewController.popoverPresentationController?.sourceRect = sender.frame
                    }
                    self.present(activityViewController, animated: true, completion: nil)
                break
            case 1:
            //var appStoreId = "962393538"
            //var urlStr: String = "itms-apps://itunes.apple.com/app/id\(appStoreId)"
            let urlStr: String = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=962393538&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
            UIApplication.shared.openURL(URL(string: urlStr)!)
            
            break
            case 2:
            if (MFMailComposeViewController.canSendMail()) {
                let mailComposer = MFMailComposeViewController();
                mailComposer.mailComposeDelegate = self;
                mailComposer.setToRecipients(["feedback@ipushnote.com"]);
                mailComposer.setSubject("PushNote Feeback");
                //mailComposer.setMessageBody("", isHTML: false);
                self.present(mailComposer, animated: true, completion: nil);
            }
            
            break
             case 3 :
                let weatherController = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
                
                self.navigationController?.pushViewController(weatherController!, animated: true)
                break
             default:
                break
            }
        }
        
        
        
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
            let alert :UIAlertView = UIAlertView(title: "Are you sure", message: "Want to delete your Number?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
            alert.show();
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
}
