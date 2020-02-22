//
//  CategoryTableView.swift
//  PushNote
//
//  Created by Khurram Iqbal on 20/02/2020.
//  Copyright © 2020 Ihsan Bhatti. All rights reserved.
//

import UIKit
import Alamofire
import AddressBookUI
import Contacts
import SVProgressHUD

class CategoryTableView: UIView,PayPalPaymentDelegate {
   
    var refreshControl  :   UIRefreshControl = UIRefreshControl()
    var isRefreshing    :   Bool = false
    @IBOutlet weak var _tableView: UITableView!
    var titleStr        :   String = ""
    var categoryId      :   Int = 0;
    var arrCategoryDetail: NSArray = []
    var arrCategoryDetailBackup: NSArray = []
    var isInvite        : Bool = false
    var isSubscribe     : Bool = false
    var isSubCategories : Bool = false
    var isOpenWebController: Bool = false
    var selectedIndexPath:IndexPath?
    var type : String = "Category"
    var phoneNumbers : NSMutableArray = []
    var arrTempSearch : NSArray = []
    var btnDone: UIButton!
    var isSelectedAll: Bool = false
    var userMessage: NSString!
    var event : String = "View"
    var shareType  :String = "";
    var senderBtn : SLButton = SLButton()
    var arrFriends: Array<NSDictionary> = []
    var arrFriendsData: Array<NSDictionary>   = []
    var arrContacts: Array<NSDictionary>  = []
    var arrContactsData:Array<NSDictionary>  = []
    var arrInviteFriendsData:   Array<NSDictionary>  = []
    var selectedFriendsNew: NSMutableArray        = []
    var newBtn: UIButton = UIButton()
    var link: String? = ""
    var subAdminId: String? = ""
    var objectId: String? = "";
    var notificationType: String = "Feed"
    var titleWeb: String? = ""
    weak var controller:BaseViewController!
     
    


    func showActivityIndicator() {
           SVProgressHUD.show(with: SVProgressHUDMaskType.black)
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(IndexSubListingViewController.reloadIndex), for: UIControl.Event.valueChanged)
        _tableView.addSubview(refreshControl)
//        self.getContacts()
        
    }
    @objc func reloadTable(){
        self._tableView.reloadData()
    }
    func getNewsListforIndex() {
        
        
        
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        
        if !AppUtility.sharedInstance.isReachable() {
            return
        }
        if(self.isRefreshing == false){
            
            self.showActivityIndicator()
        }
        self.isRefreshing = false
        let strcatId = String(self.categoryId)
        self.isUserInteractionEnabled = false
        self.showActivityIndicator()
        var serviceUrl = baseUrl ;
        if(type == "Category"){
            serviceUrl += "viewNewsList"
        }else{
            serviceUrl += "getMySubscription"
        }
        
        let params  : Parameters = ["categoryID": strcatId, "userId": userId]
        Alamofire.request(serviceUrl, parameters:params)
            .responseJSON { response in
                
                if let jsonResponse = response.result.value as? NSDictionary{
                    
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        //self.isInvite = true
                        let tempArr: Array<NSDictionary> = jsonResponse["data"] as! Array<NSDictionary>
                        
                        let arr: NSMutableArray = NSMutableArray()
                        
                        for aDic: NSDictionary in tempArr {
                            let newsFeed: NewsFeed = NewsFeed();
                            print(tempArr)
                            
                            if aDic["my_feed_id"] != nil {
                                newsFeed.feedId     = aDic["my_feed_id"] as! String
                            }
                            if aDic["categoryID"] != nil {
                                newsFeed.categoryId = aDic["categoryID"] as! String
                            }
                            if aDic["link"] != nil {
                                newsFeed.link       = aDic["link"] as! String
                            }
                            if aDic["title"] != nil {
                                newsFeed.title      = aDic["title"] as! String
                            }
                            if aDic["details"] != nil {
                                newsFeed.detail     = aDic["details"] as! String
                            }
                            if aDic["user_id"] != nil {
                                newsFeed.userId     = aDic["user_id"] as! String
                            }
                            if aDic["feed_password"] != nil {
                                newsFeed.feedPassword  = aDic["feed_password"] as! String
                            }
                            if aDic["privacy"] != nil {
                                newsFeed.privacyType  = aDic["privacy"] as! String
                            }
                            if aDic["subscribe"] != nil {
                                newsFeed.isSubscribe  = aDic["subscribe"] as! Bool
                            }
                            if aDic["feed_type"] != nil {
                                newsFeed.feedType  = aDic["feed_type"] as! String
                            }
                            if aDic["paypal_email"] != nil {
                                newsFeed.payPalEmail  = aDic["paypal_email"] as! String
                            }
                            if aDic["feed_rate"] != nil {
                                newsFeed.feedRate = aDic["feed_rate"] as! String
                            }
                            if aDic["in_approp"] != nil {
                                newsFeed.in_approp  = aDic["in_approp"] as! Bool
                            }
                            if aDic["r_feed_id"] != nil {
                                newsFeed.id = aDic["r_feed_id"] as! String
                            }
                            if aDic["companyLogo"] != nil {
                                newsFeed.companyLogo = aDic["companyLogo"] as! String
                            }
                            
                            arr.add(newsFeed)
                        }
                        self.arrCategoryDetail = arr
                        self.arrCategoryDetailBackup = arr.copy() as! NSArray
                        self._tableView.reloadData()
                        // self._tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Middle)
                       // self._collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index+2, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true);
                        
                    }
                    else {
                        let str: String = jsonResponse["msg"] as! String
                        AppUtility.sharedInstance.alert(str,controller:self.controller)
                        
                    }
                }
                self.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
        }
    }
//    func getContacts() {
//
//         var arr: Array<NSDictionary> = []
//        let store = CNContactStore()
//               store.requestAccess(for: .contacts, completionHandler: {
//                   granted, error in
//
//
//                   let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
//                   let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
//                   var cnContacts = [CNContact]()
//
//                   do {
//                       try store.enumerateContacts(with: request){
//                           (contact, cursor) -> Void in
//                           cnContacts.append(contact)
//                       }
//                   } catch let error {
//                       NSLog("Fetch contact error: \(error)")
//                   }
//
//                   NSLog(">>>> Contact list:")
//                    var i : Int = 0 ;
//                   for contact in cnContacts{
//                       let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
//                    var contactData : [String:String] = [:]
//
//                       for phoneNumber in contact.phoneNumbers{
//
//                           if let number = phoneNumber.value as? CNPhoneNumber,
//                               let label = phoneNumber.label {
//                                let number = number.stringValue.replacingOccurrences(of: "[\\(\\)\\ \\-]", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
//                                let number1 =  number.condenseWhitespace()
//                               let number2 = AppUtility.sharedInstance.removeCountryCode(number1)
//                                let trimmedString = number2.replacingOccurrences(of: " ", with: "")
//
//
//
//                            self.phoneNumbers.add(trimmedString)
//                            contactData["contactName"]     = fullName
//                            contactData["contactPhone"]    = trimmedString
//                            i = i + 1;
//
//                           }
//                       }
//                    arr.append(contactData as NSDictionary)
//                   }
//
//               })
//
//
//          //  self.arrContacts = arr.sorted(by: forwards)
//            self.arrContactsData = arr
//            self.getFriends()
//    }
    @objc func reloadIndex(){
           self.isRefreshing = true
           self.getNewsListforIndex()
       }
    
     func InitializedPayPalControllerWithItem(categoryDeatil catDetail:NewsFeed){
            PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentSandbox:catDetail.payPalEmail])
            PayPalMobile.preconnect(withEnvironment: PayPalEnvironmentProduction)
            
            var resultText = "" // empty
            let payPalConfig = PayPalConfiguration() // default
            
            // Set up payPalConfig
            payPalConfig.acceptCreditCards = true;
            payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
            payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
            
            // Setting the languageOrLocale property is optional.
            //
            // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
            // its user interface according to the device's current language setting.
            //
            // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
            // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
            // to use that language/locale.
            //
            // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
            
            payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
            
            // Setting the payPalShippingAddressOption property is optional.
            //
            // See PayPalConfiguration.h for details.
            payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOption.none;
            
            // Note: For purposes of illustration, this example shows a payment that includes
            //       both payment details (subtotal, shipping, tax) and multiple items.
            //       You would only specify these if appropriate to your situation.
            //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
            //       and simply set payment.amount to your total charge.
            
            // Optional: include multiple items
            let item1 = PayPalItem()
            item1.name = catDetail.title
            item1.quantity = 1
            item1.price = NSDecimalNumber(string: catDetail.feedRate)
            item1.currency = "USD"
            
            let items = [item1]
            let subtotal = PayPalItem.totalPrice(forItems: items)
            
            // Optional: include payment details
            let shipping = NSDecimalNumber(string: "0.00")
            let tax = NSDecimalNumber(string: "0.00")
            let paymentDetails = PayPalPaymentDetails(subtotal:subtotal, withShipping: shipping, withTax: tax)
            
            let total = subtotal.adding(shipping).adding(tax)
            
            let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Subscription payment "+catDetail.title, intent: .sale)
            
            payment.items = items
            payment.paymentDetails = paymentDetails
            
            if (payment.processable) {
                let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                self.controller.present(paymentViewController!, animated: true, completion: nil)
            }
            else {
                // This particular payment will always be processable. If, for
                // example, the amount was negative or the shortDescription was
                // empty, this payment wouldn't be processable, and you'd want
                // to handle that here.
                print("Payment not processalbe: \(payment)")
            }
        }
        
        func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController!) {
            print("PayPal Payment Cancelled")
            paymentViewController?.dismiss(animated: true, completion: nil)
        }
        
        func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController!, didComplete completedPayment: PayPalPayment!) {
            print("PayPal Payment Success !")
            paymentViewController?.dismiss(animated: true, completion: { () -> Void in
                // send completed confirmaion to your server
                print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
               // self.subscribeCategoryAtIndex(self.selectedIndexPath!.row)
            })
        }

        func subscribeCategoryAtIndex(_ index: Int) {
            
           // self.showActivityIndicator()
            self.isUserInteractionEnabled = false
            
            let defaults = UserDefaults.standard;
            let userId = defaults.value(forKeyPath: "userData.user_id") as! String
            
            let catDetail: NewsFeed = self.arrCategoryDetail[index] as! NewsFeed
            let feedId = catDetail.feedId
            let params : Parameters = ["userId" :userId , "feedId": feedId];
            Alamofire.request( baseUrl + "addUserNewsFeed", parameters:params)
                .responseJSON { response in
                   
                    if let jsonResponse = response.result.value as? NSDictionary{
                       
    //                    self.senderBtn.setTitle("Subscribed!", for: UIControl.State.normal)
    //                    self.senderBtn.setTitle("Subscribed!", for: .selected)
                        self.senderBtn.perform(#selector(SLButton.hideLoading), with: nil, afterDelay: 0.0);
                        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: "reloadTable", userInfo: nil, repeats: false)
                        
                       
                        if (jsonResponse["status"] as! String == "SUCCESS") {
                            //btn.selected = !btn.selected
                            let catDetail: NewsFeed = self.arrCategoryDetail[index] as! NewsFeed
                            catDetail.isSubscribe = true
                            
                          //  self._tableView.reloadData()
                            
                            let alertView:UIAlertView = UIAlertView(title: "Subscribed", message: "Share this awesome service with others!", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Share", "Push This")
                            alertView.tag = 1010
                            alertView.show()
                            
                        }
                    }else{
    //                    self.senderBtn.setTitle("Subscribed!", for: UIControl.State.normal)
    //                    self.senderBtn.setTitle("Subscribed!", for: .selected)
                        self.senderBtn.perform("hideLoading", with: nil, afterDelay: 0.0);
                        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: "reloadTable", userInfo: nil, repeats: false)
                    }
                    self.isUserInteractionEnabled = true
                   // self.hideActivityIndicator()
            }
        }
        
    
}
// MARK: - TableView
extension CategoryTableView:UITableViewDelegate,UITableViewDataSource{
     func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
            
            return arrCategoryDetail.count;
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
            let lblName: UILabel = cell!.contentView.viewWithTag(1001) as! UILabel
            let catDetail: NewsFeed = self.arrCategoryDetail[indexPath.row] as! NewsFeed
            lblName.text = catDetail.title as? String
           
            let lblDesc: UILabel = cell!.contentView.viewWithTag(1002) as! UILabel
            lblDesc.text = catDetail.detail
            
            
            let imageViewLock: UIImageView = cell!.contentView.viewWithTag(1004) as! UIImageView
            imageViewLock.isHidden = true
           
            if !catDetail.isSubscribe {
                
                
                if catDetail.privacyType == "Private" {
                    imageViewLock.isHidden = false
                }
            }
            let catImg = cell?.contentView.viewWithTag(1005) as! UIImageView
            if (catDetail.companyLogo != ""){
                let imgUrl = catDetail.companyLogo
                let imgPathUrl = URL(string: imgUrl)
                let defaultImg = UIImage(imageLiteralResourceName: "indexUserIcon")
                 catImg.sd_setImage(with: imgPathUrl, placeholderImage: defaultImg)
            
            }
            let btnPlus: UIButton = cell!.contentView.viewWithTag(1003) as! UIButton
            
            btnPlus.isSelected = catDetail.isSubscribe
            btnPlus.setTitle("Subscribe", for: UIControl.State())
            btnPlus.setTitle("UnSubscribe", for: UIControl.State.selected)
            btnPlus.layer.borderColor = UIColor.clear.cgColor
            btnPlus.setTitleColor(.white, for: .normal)
            btnPlus.setTitleColor(.white, for: .selected)
            if( btnPlus.isSelected == false){
                
                
             
                btnPlus.backgroundColor = UIColor.init(red: 0.8588235294, green: 0.2901960784, blue: 0.3450980392, alpha: 1.0)
                
            }else{
                btnPlus.layer.borderColor = UIColor.clear.cgColor
               
                btnPlus.backgroundColor = UIColor.init(red: 0.1098039216, green: 0.1882352941, blue: 0.3254901961, alpha: 1.0)
            }
            return cell!
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            
            
            
            let catDetail: NewsFeed = self.arrCategoryDetail[indexPath.row] as! NewsFeed
            
            if(catDetail.in_approp){
                let alertView = UIAlertView(title: "This Feed may contain inappropriate content. Are you sure you want to continue?",
                    message: "", delegate: nil, cancelButtonTitle: nil,
                    otherButtonTitles: "YES", "NO")
                
                AlertViewWithCallback().show(alertView) { alertView, buttonIndex in
                    switch buttonIndex{
                    case 0:
                        if catDetail.feedType == "Paid" && catDetail.isSubscribe == false{

                            self.selectedIndexPath = indexPath
                            self.InitializedPayPalControllerWithItem(categoryDeatil: catDetail)
                        }
                        else{
                            //self.selectedIndexPath = indexPath
                            if catDetail.privacyType == "Private" {
                                self.isSubscribe = true
                                self.isOpenWebController = true
                                let alert :UIAlertView = UIAlertView(title: "", message: "Please enter the Password", delegate: self, cancelButtonTitle: "OK")
                                alert.alertViewStyle = UIAlertViewStyle.secureTextInput
                                alert.textField(at: 0)?.keyboardType = UIKeyboardType.numberPad
                                alert.textField(at: 0)?.becomeFirstResponder()
                                alert.tag = indexPath.row
                                alert.show();
                            }
                            else{
                                let detailController = self.controller.storyboard?.instantiateViewController(withIdentifier: SEGUE_DETAILS) as! WebViewController
                                
                                
    //                            self.tabBarController!.tabBar.isHidden = true
                                detailController.link = catDetail.link
                                detailController.subAdminId = catDetail.feedId
                                detailController.objectId = catDetail.id
                                detailController.notificationType = "Feed"
                                if(!catDetail.link.isEmpty){
                                    detailController.titleWeb = catDetail.title
                                    self.controller.navigationController?.pushViewController(detailController, animated: true)
                                }
                            }
                        }
                    case 1:
                        print("NO")
                    default:
                        print("Something went wrong!")
                    }
                }
            }
            else{
                if catDetail.feedType == "Paid" && catDetail.isSubscribe == false{
                    print("paid")
                    selectedIndexPath = indexPath
                    self.InitializedPayPalControllerWithItem(categoryDeatil: catDetail)
                }
                else{
                    self.selectedIndexPath = indexPath
                    if catDetail.privacyType == "Private" {
                        self.isSubscribe = true
                        self.isOpenWebController = true
                        let alert :UIAlertView = UIAlertView(title: "", message: "Please enter the Password", delegate: self, cancelButtonTitle: "OK")
                        alert.alertViewStyle = UIAlertViewStyle.secureTextInput
                        alert.textField(at: 0)?.keyboardType = UIKeyboardType.numberPad
                        alert.textField(at: 0)?.becomeFirstResponder()
                        alert.tag = indexPath.row
                        alert.show();
                    }
                    else{
                        let detailController = self.controller.storyboard?.instantiateViewController(withIdentifier: SEGUE_DETAILS) as! WebViewController
                        
                        
                        
                        detailController.link = catDetail.link
                        detailController.subAdminId = catDetail.feedId
                        detailController.objectId = catDetail.id
                        if(!catDetail.link.isEmpty){
    //                        self.tabBarController!.tabBar.isHidden = true
                            detailController.titleWeb = catDetail.title
                            self.controller.navigationController?.pushViewController(detailController, animated: true)
                        }
                    }
                }
            }
            
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            if(DeviceType.IS_IPAD) {
                return 92.0;

            }
            
            return 100.0;

        }
}
// MARK: - AlertDelegate
extension CategoryTableView:UIAlertViewDelegate{
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
          
          if(alertView.tag == 1010){
             
              let catDetail: NewsFeed = self.arrCategoryDetail[selectedIndexPath!.row] as! NewsFeed
              
              switch buttonIndex{
              case 0:
                  print("Cancel")
              case 1:
                  print("Share")
                  let shareContent:String = "Just got a Pushnote from \(catDetail.link). Subscribe here https://itunes.apple.com/gb/app/push-note/id962393538?mt=8"
                  let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
                  activityViewController.completionWithItemsHandler = {
                      (activity, success, items, error) in
                      print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
                      
                      if(success != false){
                          var shareT = ""
                          if String(describing: activity!).lowercased().range(of: "facebook") != nil {
                              shareT = "Facebook"
                          }else  if String(describing: activity!).lowercased().range(of: "mail") != nil {
                              shareT = "Mail"
                          }else  if String(describing: activity!).lowercased().range(of: "message") != nil {
                              shareT = "Message"
                          }else  if String(describing: activity!).lowercased().range(of: "linkedin") != nil {
                              shareT = "Linkedin"
                          }else  if String(describing: activity!).lowercased().range(of: "whatsapp") != nil {
                              shareT = "Whatsapp"
                          }else  if String(describing: activity!).lowercased().range(of: "twitter") != nil {
                              shareT = "Twitter"
                          }else  if String(describing: activity!).lowercased().range(of: "GooglePlus") != nil {
                              shareT = "GooglePlus"
                          }
                          if(shareT != ""){
                              self.event = "Share"
                              self.shareType = shareT
                              self.saveAnalytics(self.link!, objectID: self.objectId!, merchantID: self.subAdminId!)
                          }
                          
                          
                          
                      }
                      
                  }
                  if UIDevice.current.userInterfaceIdiom == .pad{
                    activityViewController.popoverPresentationController!.sourceView = self.newBtn;
                      activityViewController.popoverPresentationController!.permittedArrowDirections    = .right
                      activityViewController.popoverPresentationController?.sourceRect = self.newBtn.bounds
                  }
                  self.controller.present(activityViewController, animated: true, completion: {})
                  
              case 2:
                  
                  return
                  
                  
     
              default:
                  print("something went wrong!")
              }

          }
          else{
              if self.isSubscribe {
                  
                  let textField: UITextField = alertView.textField(at: 0)! as UITextField
                  if !textField.text!.isEmpty {
                      let catDetail: NewsFeed = self.arrCategoryDetail[alertView.tag] as! NewsFeed
                      if catDetail.feedPassword == textField.text {
                          if(self.isOpenWebController){
                            let navController = self.controller.storyboard?.instantiateViewController(withIdentifier: "NavigationControllerWeb") as! UINavigationController
                              let webController: WebViewController = navController.viewControllers[0] as! WebViewController
                              webController.link = catDetail.link
                              webController.subAdminId = catDetail.feedId
                              webController.objectId = catDetail.id
                              if(!catDetail.link.isEmpty){
                                  webController.titleWeb = catDetail.title
                                self.controller.present(navController, animated: true, completion: nil);
                              }
                          }
                          else{
                              subscribeCategoryAtIndex(alertView.tag)
                          }
                      }
                      else {
                          let alert :UIAlertView = UIAlertView(title: "", message: "Wrong Password", delegate: nil, cancelButtonTitle: "OK")
                          alert.show()
                      }
                  }
              }
              else {
                  if buttonIndex == 1 {
                      unsubscribeCategoryAtIndex(alertView.tag)
                  }
              }
          }
      }
    
    func saveAnalytics(_ lnk:String, objectID :String, merchantID : String ){
           
           let defaults = UserDefaults.standard;
           let userId = defaults.value(forKeyPath: "userData.user_id") as! String
           
        if !self.controller.isReachable() {
               return
           }
           let strId = "0";
           let strNotificationId = "0"
           
           
           let params : Parameters = ["userId": userId,"link":lnk,"objectId" : objectID,"merchantId": merchantID,"id":strId,"deviceType":"Ios","contentType":self.notificationType,"notificationId":strNotificationId,"event":self.event,"shareType" :self.shareType];
           
           Alamofire.request(baseUrl + "saveAnalytics", parameters:params)
               .responseJSON { response in
                   
                   if let jsonResponse = response.result.value as? NSDictionary{
                       
                       if (jsonResponse["status"] as! String == "SUCCESS") {

                       }
                       else {
                           
                       }
                   }
           }
           
           
       }
  func unsubscribeCategoryAtIndex(_ index: Int) {
          
         // self.showActivityIndicator()
          self.isUserInteractionEnabled = false
          
          let defaults = UserDefaults.standard;
          let userId = defaults.value(forKeyPath: "userData.user_id") as! String
          
          let catDetail: NewsFeed = self.arrCategoryDetail[index] as! NewsFeed
          let feedId = catDetail.feedId
          let params : Parameters = ["userId": userId, "feedId": feedId]
          Alamofire.request(baseUrl + "unSubscribe", parameters:params)
              .responseJSON { response in
                  
                  if let jsonResponse = response.result.value as? NSDictionary{
                      
                      if (jsonResponse["status"] as! String == "SUCCESS") {
                          //btn.selected = !btn.selected
                          let catDetail: NewsFeed = self.arrCategoryDetail[index] as! NewsFeed
                          catDetail.isSubscribe = false
  //                        self.senderBtn.setTitle("Unsubscribed!", for: UIControl.State.selected)
  //                        self.senderBtn.setTitle("Unsubscribed!", for: UIControl.State.normal)
                          Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)
                           self.senderBtn.perform("hideLoading", with: nil, afterDelay: 0.0);
                          
                          
                      }
                  }
                  self.isUserInteractionEnabled = true
                  //self.hideActivityIndicator()
          }
      }
}
