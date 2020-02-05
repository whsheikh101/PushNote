//
//  ShareViewController.swift
//  PushNote
//
//  Created by Rizwan on 1/7/15.
//  Copyright (c) 2015 com. All rights reserved.
//

import UIKit
import Social
import MessageUI
import Alamofire
/*
class ShareViewController: BaseViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate, GPPSignInDelegate {
  
    @IBOutlet weak var _tableView: UITableView!
    var arrShareType: Array<String> = []
    let kClientId = "883274197078-iihhi1jj1mu519h5ahut65e3j98smeb5.apps.googleusercontent.com"
    var isIndex: Bool = false
    var _documentInteractionController: UIDocumentInteractionController!
    
    var link: String!
    var titleWeb: String!
    var isFromWeather:Bool = false
    var weatherShareText:String = ""
    var subAdminId: String?  = "0"
    var objectId: String? = "0"
    var merchantId: String? = "0"
    var notificationType : String? = "Feed"
    var shareType :  String? = "";
    
    
    var oAuthLoginView: OAuthLoginView!
    var nacController: UINavigationController!

    var textToShare: String = ""
    
    var isShared: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        arrShareType = ["share-via-facebook", "share-via-message", "share-via-email", "share-via-whatsapp", "share-via-twitter", "share-via-google-+", "share-via-linkedin"]
        
        if self.isIndex {
            
            let btnLeft: UIButton = UIButton(type: UIButtonType.Custom)
            let imgLeft: UIImage! = UIImage(named: "back")
            btnLeft.setImage(imgLeft, forState: UIControlState.Normal)
            btnLeft.frame = CGRectMake(0, 0, 28, 28)
            btnLeft.addTarget(self, action: "backBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            let barLeftBtn: UIBarButtonItem = UIBarButtonItem(customView: btnLeft)
            self.navigationItem.leftBarButtonItem = barLeftBtn
            
            self.navigationItem.title = "SHARE"
        }
        
        self.textToShare = "Just got a Pushnote from \(link). Subscribe here https://itunes.apple.com/gb/app/push-note/id962393538?mt=8"
        self.weatherShareText = "\(weatherShareText). Subscribe here https://itunes.apple.com/gb/app/push-note/id962393538?mt=8"
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrShareType.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) ;
        
        let imageViewBg: UIImageView = cell.contentView.viewWithTag(1000) as! UIImageView
        imageViewBg.image = UIImage(named: self.arrShareType[indexPath.row]);
        
        return cell;
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let backgroundView : UIView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.clearColor()
        cell.backgroundView = backgroundView
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
            
        case 0:
            if (SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)) {
                
                let controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                if(isFromWeather){
                    controller.setInitialText(self.weatherShareText)
                }
                else{
                    controller.setInitialText(self.textToShare)
                }
                controller.addImage(UIImage(named: "Icon"))
                controller.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                    switch result {
                    case SLComposeViewControllerResult.Cancelled:
                        print("Cancelled") // Never gets called
                        break
                    case SLComposeViewControllerResult.Done:
                        self.shareType = "Facebook";
                        self.saveAnalytics(self.link!, objectID: self.objectId!, merchantID: self.subAdminId!, notificationType: self.notificationType!)
                        break
                    }
                }
                
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
            else {
                let alert :UIAlertView = UIAlertView(title: "", message: "Please login with your Facebook account in settings", delegate: nil, cancelButtonTitle: "OK")
                alert.show();
            }
            break
        case 1:
            if (MFMessageComposeViewController.canSendText()) {
                
                let compose: MFMessageComposeViewController = MFMessageComposeViewController()
                compose.messageComposeDelegate = self
                if(isFromWeather){
                   compose.body = self.weatherShareText
                }
                else{
                    compose.body = self.textToShare
                }
                self.presentViewController(compose, animated: true, completion: nil)
            }
            break
        case 2:
            if (MFMailComposeViewController.canSendMail()) {
                
                let compose: MFMailComposeViewController = MFMailComposeViewController()
                compose.mailComposeDelegate = self
                compose.setSubject("PushNote Share")
                if(isFromWeather){
                    compose.setMessageBody(self.weatherShareText, isHTML: false)
                }
                else{
                 compose.setMessageBody(self.textToShare, isHTML: false)
                }
                compose.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.presentViewController(compose, animated: true, completion: nil)
            }
            break
        case 3:
            var escapedString:CFString!
            if(isFromWeather){
                escapedString = CFURLCreateStringByAddingPercentEscapes(
                    nil,
                    self.weatherShareText,
                    nil,
                    "!*'();:@&=+$,/?%#[]",
                    CFStringBuiltInEncodings.UTF8.rawValue
                )
            }
            else{
                escapedString = CFURLCreateStringByAddingPercentEscapes(
                    nil,
                    self.textToShare,
                    nil,
                    "!*'();:@&=+$,/?%#[]",
                    CFStringBuiltInEncodings.UTF8.rawValue
                )
            }
            
            let urlWhatsApp: String = "whatsapp://send?text=\(escapedString)"
            let url: NSURL = NSURL(string: urlWhatsApp)!
            
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
            else {
                let alert :UIAlertView = UIAlertView(title: "WhatsApp not installed.", message: "Your device has no WhatsApp installed.", delegate: nil, cancelButtonTitle: "OK")
                alert.show();
            }
            
            break
        case 4:
            if (SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)) {
                
                let controller = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                if(isFromWeather){
                   controller.setInitialText(self.weatherShareText)
                }
                else{
                 controller.setInitialText(self.textToShare)
                }
                
                controller.addImage(UIImage(named: "Icon"))
                controller.completionHandler = { (result:SLComposeViewControllerResult) -> Void in
                    switch result {
                    case SLComposeViewControllerResult.Cancelled:
                        print("Cancelled") // Never gets called
                        break
                    case SLComposeViewControllerResult.Done:
                        self.shareType = "Twitter";
                        self.saveAnalytics(self.link!, objectID: self.objectId!, merchantID: self.subAdminId!, notificationType: self.notificationType!)
                        break
                    }
                }
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
            else {
                let alert :UIAlertView = UIAlertView(title: "", message: "Please login with your Twitter account in settings", delegate: nil, cancelButtonTitle: "OK")
                alert.show();
            }
            break
        case 5:
            
            let signIn: GPPSignIn = GPPSignIn.sharedInstance()
            signIn.shouldFetchGooglePlusUser = true
            signIn.shouldFetchGoogleUserEmail = true
            
            signIn.clientID = kClientId
            signIn.scopes = [kGTLAuthScopePlusLogin]
            signIn.delegate = self
            signIn.authenticate()
            break
        case 6:
            
            let tokenKey: NSString = "";
            
            NSUserDefaults.standardUserDefaults().setObject(tokenKey, forKey: "TokenKey")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            self.isShared = false
            
            self.oAuthLoginView = OAuthLoginView(nibName: nil, bundle: nil)
            nacController = UINavigationController(rootViewController: self.oAuthLoginView)
            nacController.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 127.0/255.0, blue: 0, alpha: 1.0)
            nacController.navigationBar.translucent = false
            
            // register to be told when the login is finished
            
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginViewDidFinish:", name: "loginViewDidFinish", object: self.oAuthLoginView)
                
                self.presentViewController(nacController, animated: true, completion: nil)
//            }
            break
        default:
            print("nothing selected")
            break
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.shareType = "Message";
        self.saveAnalytics(self.link!, objectID: self.objectId!, merchantID: self.subAdminId!, notificationType: self.notificationType!)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        
        if(result == MFMailComposeResultSent){
            self.shareType = "Mail";
            self.saveAnalytics(self.link!, objectID: self.objectId!, merchantID: self.subAdminId!, notificationType: self.notificationType!)
        }
        
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        
        if error == nil  {
            
            let shareBuilder = GPPShare.sharedInstance().nativeShareDialog()
            if(isFromWeather){
                shareBuilder.setPrefillText(self.weatherShareText)
            }
            else{
             shareBuilder.setPrefillText(self.textToShare)
            }
            shareBuilder.attachImage(UIImage(named: "Icon.png"))
            shareBuilder.open()
        }
        
    }
    
    
    func loginViewDidFinish(notification:NSNotification) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
        profileApiCall()
    }
    
    func profileApiCall() {
        
        let url: NSURL = NSURL(string: "http://api.linkedin.com/v1/people/~")!
        
        let request: OAMutableURLRequest = OAMutableURLRequest(URL: url, consumer: self.oAuthLoginView.consumer, token: self.oAuthLoginView.accessToken, callback: nil, signatureProvider: nil)
        request.setValue("json", forHTTPHeaderField: "x-li-format")
        //request.setValue("json", for: "x-li-format")
        
        let fetcher: OADataFetcher = OADataFetcher()
        fetcher.fetchDataWithRequest(request,
            delegate: self,
            didFinishSelector: "profileApiCallResult:didFinish:",
            didFailSelector: "profileApiCallResult:didFail:")
        
    }

    func profileApiCallResult(ticket: OAServiceTicket, didFinish data:NSData) {
        
        let responseBody: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        let profile: NSDictionary = responseBody.objectFromJSONString() as! NSDictionary
        
        if profile.count != 0 {
            print(profile)
        }
    // The next thing we want to do is call the network updates
        networkApiCall()
    
    }
    
    func profileApiCallResult(ticket:OAServiceTicket, didFail error:NSData) {
        
        NSLog(error.description);
    }

    func networkApiCall() {
        
        let url:NSURL = NSURL(string: "http://api.linkedin.com/v1/people/~/network/updates?scope=self&count=1&type=STAT")!
        
        let request: OAMutableURLRequest = OAMutableURLRequest(URL: url, consumer: self.oAuthLoginView.consumer, token: self.oAuthLoginView.accessToken, callback: nil, signatureProvider: nil)
        request.setValue("json", forHTTPHeaderField: "x-li-format")
        
        let fetcher: OADataFetcher = OADataFetcher()
        fetcher.fetchDataWithRequest(request,
            delegate: self,
            didFinishSelector: "networkApiCallResult:didFinish:",
            didFailSelector: "networkApiCallResult:didFail:")
        
    }
    
    
    func networkApiCallResult(ticket:OAServiceTicket, didFinish data:NSData) {
        
        let responseBody: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        let personData: NSDictionary = responseBody.objectFromJSONString() as! NSDictionary
        
        if !self.isShared {
            postStatus()
        }
    }
    
    func networkApiCallResult(ticket:OAServiceTicket, didFail error:NSData) {
        NSLog(error.description);
    }
    
    func postStatus() {
        
        let url: NSURL = NSURL(string: "http://api.linkedin.com/v1/people/~/shares")!
        
        let request: OAMutableURLRequest = OAMutableURLRequest(URL: url, consumer: self.oAuthLoginView.consumer, token: self.oAuthLoginView.accessToken, callback: nil, signatureProvider: nil)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let comment: String = self.titleWeb + " " + self.link
        
        let update:NSDictionary = NSDictionary(objects: [NSDictionary(object: "anyone", forKey: "code"),comment], forKeys: ["visibility","comment"])
//        var update: NSDictionary = NSDictionary(objectsAndKeys: NSDictionary(objectsAndKeys: "anyone","code"),"visibility", comment, "comment" )
        
        let updateString: NSString = update.JSONString()
        
        request.setHTTPBodyWithString(updateString as String)
        request.HTTPMethod = "POST"
        
        let fetcher: OADataFetcher = OADataFetcher()
        fetcher.fetchDataWithRequest(request,
            delegate: self,
            didFinishSelector: "postUpdateApiCallResult:didFinish:",
            didFailSelector: "postUpdateApiCallResult:didFail:")
        
    }
    
    func postUpdateApiCallResult(ticket:OAServiceTicket, didFinish data:NSData) {
    // The next thing we want to do is call the network updates
        
        self.isShared = true
        networkApiCall()
        print(NSString(data: data, encoding: NSUTF8StringEncoding))
        let alert :UIAlertView = UIAlertView(title: "", message: "Posted on Linkedin", delegate: nil, cancelButtonTitle: "OK")
        alert.show();
        self.shareType = "Linkedin";
        self.saveAnalytics(self.link!, objectID: self.objectId!, merchantID: self.subAdminId!, notificationType: self.notificationType!)

    }

    func postUpdateApiCallResult(ticket:OAServiceTicket, didFail error:NSData) {
        NSLog(error.description);
    }
    func saveAnalytics(lnk:String, objectID :String, merchantID : String,notificationType : String ){
        
        let defaults = NSUserDefaults.standardUserDefaults();
        let userId = defaults.valueForKeyPath("userData.user_id") as! String
       
        if !self.isReachable() {
            return
        }
        // let strId = String(id);
        print(["userId": userId,"link":lnk,"objectId" : objectID,"merchantId": merchantID,"deviceType":"Ios","contentType":notificationType]);
        
        
        Alamofire.request(.POST, baseUrl + "saveAnalytics", parameters:["userId": userId,"link":lnk,"objectId" : objectID,"merchantId": merchantID,"deviceType":"Ios","contentType":notificationType,"event" : "Share","shareType":self.shareType!])
            .responseJSON { response in
                
                if let jsonResponse = response.result.value {
                    print(jsonResponse)
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                    }
                    else {
                        
                    }
                }
        }
        
        
    }
}*/
