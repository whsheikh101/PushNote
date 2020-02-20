//
//  IndexSubListingViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 06/03/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit
import Alamofire
import AddressBookUI
import Contacts
class IndexSubListingViewController:
    BaseViewController,
PayPalPaymentDelegate,
UIAlertViewDelegate,
UITextViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,UISearchBarDelegate {
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
    @IBOutlet weak var searchB: UISearchBar!
    var type : String = "Category"
    @IBOutlet weak var userCaption: TextField!
    @IBOutlet weak var searchB1: UISearchBar!
    var phoneNumbers : NSMutableArray = []
    var selectedFriends : NSMutableArray = []
    var arrFriendBackup : NSArray = []
    var arrTempSearch : NSArray = []
    var btnDone: UIButton!
    var isSelectedAll: Bool = false
    var userMessage: NSString!
    var event : String = "View"
    var shareType  :String = "";
    var senderBtn : SLButton = SLButton()
    var arrFriends:             Array<NSDictionary> = []
      var arrFriendsData:         Array<NSDictionary>   = []
      var arrContacts:            Array<NSDictionary>  = []
      var arrContactsData:        Array<NSDictionary>  = []
      var arrInviteFriendsData:   Array<NSDictionary>  = []
    var selectedFriendsNew      : NSMutableArray        = []
    
    var addressBook: ABAddressBook?
    
    var link                    : String? = ""
    var subAdminId              : String? = ""
    var objectId                : String? = "";
    var notificationType        : String = "Feed"
    var titleWeb                : String? = ""
   
    
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var _collectionView: UICollectionView!
    
    @IBOutlet weak var pushView: UIView!
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackBtn()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(IndexSubListingViewController.reloadIndex), for: UIControl.Event.valueChanged)
        _tableView.addSubview(refreshControl)
        self.title = titleStr
        self.getNewsListforIndex();
        self.getContacts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadIndex(){
        self.isRefreshing = true
        self.getNewsListforIndex()
    }
    //UITableView integration
    
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
            let defaultImg = UIImage(named: "iconImg")
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
        
        /*
        if(catDetail.isSubscribe == true){
            btnPlus.selected = true
        }else{
             btnPlus.selected = false
        }
        */
        
    
        
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
                            let detailController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_DETAILS) as! WebViewController
                            
                            
//                            self.tabBarController!.tabBar.isHidden = true
                            detailController.link = catDetail.link
                            detailController.subAdminId = catDetail.feedId
                            detailController.objectId = catDetail.id
                            detailController.notificationType = "Feed"
                            if(!catDetail.link.isEmpty){
                                detailController.titleWeb = catDetail.title
                                self.navigationController?.pushViewController(detailController, animated: true)
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
                    let detailController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_DETAILS) as! WebViewController
                    
                    
                    
                    detailController.link = catDetail.link
                    detailController.subAdminId = catDetail.feedId
                    detailController.objectId = catDetail.id
                    if(!catDetail.link.isEmpty){
//                        self.tabBarController!.tabBar.isHidden = true
                        detailController.titleWeb = catDetail.title
                        self.navigationController?.pushViewController(detailController, animated: true)
                    }
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(DeviceType.IS_IPAD) {
            return 92.0;

        }
        
        return 90.0;

    }
    
    //UISearchBar integration
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // searchActive = false;
        searchBar.showsCancelButton = false
        // self.createDictionaryOfArray(locData as [AnyObject])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchB.showsCancelButton = false
        searchBar.text = ""
        self.arrFriendsData = arrFriendBackup.copy() as! NSArray as! Array<NSDictionary>
        self._collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // self.createDictionaryOfArray(locData as [AnyObject])
        searchBar.resignFirstResponder()
        
    }
    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController!.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController!.tabBar.isHidden = false
    }
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.tag == 0 ){
            if(searchText != ""){
                let arrTempSearch:NSMutableArray = []
                for feed:NewsFeed in (self.arrCategoryDetailBackup as NSArray as! [NewsFeed]){
                    let options = NSString.CompareOptions.caseInsensitive
                    let found = feed.title.range(of: searchText, options: options)
                    if ((found) != nil) {
                            arrTempSearch.add(feed)
                    }
                }
                self.arrCategoryDetail = arrTempSearch.copy() as! NSArray
            }
            else{
                self.arrCategoryDetail = arrCategoryDetailBackup.copy() as! NSArray
            }
            self._tableView.reloadData()
        }else{
            if(searchText != ""){
                let arrTempSearch:NSMutableArray = []
                for friendData:NSDictionary in (self.arrFriendBackup as NSArray as! [NSDictionary]){
                    let options = NSString.CompareOptions.caseInsensitive
                    let found = (friendData["userName"] as? String)!.range(of: searchText, options: options)
                    if ((found) != nil) {
                        arrTempSearch.add(friendData)
                    }
                }
                self.arrFriendsData = arrTempSearch.copy() as! NSArray as! Array<NSDictionary>
            }
            else{
                self.arrFriendsData = arrFriendBackup.copy() as! NSArray as! Array<NSDictionary>
            }
            
            self._collectionView.reloadData()
        
        }
    }
    func getNewsListforIndex() {
        
        
        
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        
        if !self.isReachable() {
            return
        }
        if(self.isRefreshing == false){
            
            self.showActivityIndicator()
        }
        self.isRefreshing = false
        let strcatId = String(self.categoryId)
        self.view.isUserInteractionEnabled = false
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
                        self.alert(str)
                        
                    }
                }
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
                self.refreshControl.endRefreshing()
        }
    }
    var newBtn : UIButton = UIButton()
    @IBAction func subscribeBtnPressed(_ sender: AnyObject, forEvent event: UIEvent) {
        
        let btn: UIButton = sender as! UIButton
        self.newBtn = btn;
        let touch: UITouch = (event.allTouches?.first)! as UITouch
        let point: CGPoint = touch.location(in: _tableView) as CGPoint
        let indexPath: IndexPath = _tableView.indexPathForRow(at: point) as IndexPath!
        
        self.isOpenWebController = false
        if !self.isReachable() {
            return
        }
        
        let catDetail: NewsFeed = self.arrCategoryDetail[indexPath.row] as! NewsFeed
        self.link       = catDetail.link
        self.subAdminId = catDetail.feedId
        self.objectId   = catDetail.id
        self.titleWeb   =  catDetail.title
        
        
        if (!catDetail.isSubscribe) {
            
            if(catDetail.in_approp){
                let alertView = UIAlertView(title: "This Feed may contain inappropriate content. Are you sure you want to continue?",
                    message: "", delegate: nil, cancelButtonTitle: nil,
                    otherButtonTitles: "YES", "NO")
                
                AlertViewWithCallback().show(alertView) { alertView, buttonIndex in
                    switch buttonIndex{
                    case 0:
                        print("YES")
                        if catDetail.feedType == "Paid" && catDetail.isSubscribe == false{
                            self.selectedIndexPath = indexPath
                            self.InitializedPayPalControllerWithItem(categoryDeatil: catDetail)
                        }
                        else{
                            self.selectedIndexPath = indexPath
                            if catDetail.privacyType == "Private" {
                                self.selectedIndexPath = indexPath
                                self.isSubscribe = true
                                let alert :UIAlertView = UIAlertView(title: "", message: "Please enter the Password", delegate: self, cancelButtonTitle: "OK")
                                alert.alertViewStyle = UIAlertViewStyle.secureTextInput
                                alert.textField(at: 0)?.keyboardType = UIKeyboardType.numberPad
                                alert.textField(at: 0)?.becomeFirstResponder()
                                alert.tag = indexPath.row
                                alert.show();
                            }
                            else {
                                self.actionSubscribe(sender as! SLButton)
                                self.subscribeCategoryAtIndex(indexPath.row)
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
                    selectedIndexPath = indexPath
                    self.InitializedPayPalControllerWithItem(categoryDeatil: catDetail)
                }
                else{
                    self.selectedIndexPath = indexPath
                    if catDetail.privacyType == "Private" {
                        self.isSubscribe = true
                        let alert :UIAlertView = UIAlertView(title: "", message: "Please enter the Password", delegate: self, cancelButtonTitle: "OK")
                        alert.alertViewStyle = UIAlertViewStyle.secureTextInput
                        alert.textField(at: 0)?.keyboardType = UIKeyboardType.numberPad
                        alert.textField(at: 0)?.becomeFirstResponder()
                        alert.tag = indexPath.row
                        alert.show();
                    }
                    else {
                        actionSubscribe(sender as! SLButton)
                        subscribeCategoryAtIndex(indexPath.row)
                    }
                }
            }
        }
        else {
            if catDetail.privacyType == "Private" {
                
                self.isSubscribe = false
                let alert :UIAlertView = UIAlertView(title: "Are you sure", message: "Want to unsubscribe private feed?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                alert.tag = indexPath.row
                alert.show();
                
            }
            else {
                self.actionSubscribe(sender as! SLButton)
                unsubscribeCategoryAtIndex(indexPath.row)
            }
        }
    }
    func actionSubscribe(_ sender:SLButton) {
        
        sender.showLoading()
        senderBtn = sender;
       
    }
    func unsubscribeCategoryAtIndex(_ index: Int) {
        
       // self.showActivityIndicator()
        self.view.isUserInteractionEnabled = false
        
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
                self.view.isUserInteractionEnabled = true
                //self.hideActivityIndicator()
        }
    }
    
    @objc func reloadTable(){
        self._tableView.reloadData()
    }
    
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
                present(activityViewController, animated: true, completion: {})
                
            case 2:
                
                animateView()
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
                            let navController = self.storyboard?.instantiateViewController(withIdentifier: "NavigationControllerWeb") as! UINavigationController
                            let webController: WebViewController = navController.viewControllers[0] as! WebViewController
                            webController.link = catDetail.link
                            webController.subAdminId = catDetail.feedId
                            webController.objectId = catDetail.id
                            if(!catDetail.link.isEmpty){
                                webController.titleWeb = catDetail.title
                                self.present(navController, animated: true, completion: nil);
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
    
    //MARK: PayPalPaymentDelegate & Methods
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
            present(paymentViewController!, animated: true, completion: nil)
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
        self.view.isUserInteractionEnabled = false
        
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
                self.view.isUserInteractionEnabled = true
               // self.hideActivityIndicator()
        }
    }
    
    func animateView (){
        self.scrollView.isHidden = false
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            let bounds = self.scrollView.bounds;//  UIScreen.main.bounds
            let yPosition = bounds.size.height - self.pushView.frame.size.height - 50
            self.pushView.frame = CGRect(x: 0.0, y: yPosition, width: self.pushView.frame.size.width, height: self.pushView.frame.size.height)
            
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
        
        
        //scrollView.hidden = false
        //self.pushView.frame = CGRectMake(0.0, +320, self.pushView.frame.size.width, self.pushView.frame.size.height)
        
        
        //  pushView.an
        /*
        pushView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
        
        self.pushView.frame = CGRectMake(0.0, +150, self.pushView.frame.size.width, self.pushView.frame.size.height)
        
        }, completion: { (finished: Bool) -> Void in
        
        // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
        */
    }
    
    
    @IBAction func hidePop(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            
            let bounds = UIScreen.main.bounds
            let yPosition = bounds.size.height + self.pushView.frame.size.height
            self.pushView.frame = CGRect(x: 0, y: yPosition, width: self.pushView.frame.size.width, height: self.pushView.frame.size.height)
            
            }, completion: { (finished: Bool) -> Void in
                self.scrollView.isHidden = true
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if segue.identifier == "PushFriends" {
        let destController: ShareFriendsViewController = segue.destinationViewController as! ShareFriendsViewController
        destController.link = self.link
        destController.titleWeb = self.titleWeb
        destController.notificationType = self.notificationType
        destController.objectId   = self.objectId
        destController.subAdminId = self.subAdminId
        
        }
        else {
        let destController: ShareViewController = segue.destinationViewController as! ShareViewController
        destController.link = self.link
        destController.titleWeb = self.titleWeb
        destController.objectId = self.objectId
        destController.notificationType = self.notificationType
        destController.subAdminId = self.subAdminId
        }
        */
    }
    
    //MARK: Notification Method
    func windowNowVisible(_ notification:Notification){
        print("Remove Activity Indicator")
        self.hideActivityIndicator()
        //self.activityIndicator.stopAnimating()
    }
    func saveAnalytics(_ lnk:String, objectID :String, merchantID : String ){
        
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        
        if !self.isReachable() {
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         // get a reference to our storyboard cell
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as! CustomCollectionCell
         
         let friendData: NSDictionary = self.arrFriendsData[indexPath.row]
         
         let fName  = friendData["userName"] as? String
         /*

         if(friendData.userName.characters.count > 12){
             let index1 = fName.startIndex.advancedBy(9)
             fName = fName.substringToIndex(index1)
             fName = fName + "..."
         }*/
         
         cell.friendName.text = fName
       
         cell.friendSelected.tag = indexPath.row
         let imagePathUrl = URL(string: (friendData["photo"] as? String)! )
         let defaultImg = UIImage(named: "iconImg")
         cell.friendPic.sd_setImage(with: imagePathUrl, placeholderImage: defaultImg)
         
         if(friendData["selected"] as? Bool == true){
             cell.friendSelected.isSelected = true
         }else{
             cell.friendSelected.isSelected = false
         }
         
         return cell
     }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.arrFriendsData.count
     }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FriendCell", forIndexPath: indexPath) as! CustomCollectionCell
         if(self.arrFriendsData[indexPath.row]["selected"] as? Bool == false){
              print("HERE")
             let fData = self.arrFriendsData[indexPath.row].mutableCopy() as! NSMutableDictionary
             fData["selected"] = true
             self.arrFriendsData[indexPath.row] = fData
             //cell.friendSelected.selected = true
         }else{
             print("HERE1")
             let fData = self.arrFriendsData[indexPath.row].mutableCopy() as! NSMutableDictionary
             fData["selected"] = false
              self.arrFriendsData[indexPath.row] = fData
             //cell.friendSelected.selected = false
         }
     
        self._collectionView.reloadData()
         
         
     }
     
     func extractABAddressBookRef(_ abRef: Unmanaged<ABAddressBook>!) -> ABAddressBook? {
         if let ab = abRef {
             return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
         }
         return nil
     }
     
     func getContacts() {
         
          var arr: Array<NSDictionary> = []
         let store = CNContactStore()
                store.requestAccess(for: .contacts, completionHandler: {
                    granted, error in
                   
                    
                    let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
                    let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    var cnContacts = [CNContact]()
                    
                    do {
                        try store.enumerateContacts(with: request){
                            (contact, cursor) -> Void in
                            cnContacts.append(contact)
                        }
                    } catch let error {
                        NSLog("Fetch contact error: \(error)")
                    }
                    
                    NSLog(">>>> Contact list:")
                     var i : Int = 0 ;
                    for contact in cnContacts{
                        let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
                     var contactData : [String:String] = [:]
                          
                        for phoneNumber in contact.phoneNumbers{
                         
                            if let number = phoneNumber.value as? CNPhoneNumber,
                                let label = phoneNumber.label {
                                 let number = number.stringValue.replacingOccurrences(of: "[\\(\\)\\ \\-]", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
                                 let number1 =  number.condenseWhitespace()
                                let number2 = AppUtility.sharedInstance.removeCountryCode(number1)
                                 let trimmedString = number2.replacingOccurrences(of: " ", with: "")


                             
                             self.phoneNumbers.add(trimmedString)
                             contactData["contactName"]     = fullName
                             contactData["contactPhone"]    = trimmedString
                             i = i + 1;
                 
                            }
                        }
                     arr.append(contactData as NSDictionary)
                    }
                   
                })
           
         
           //  self.arrContacts = arr.sorted(by: forwards)
             self.arrContactsData = arr
             self.getFriends()
     }

 
    func forwards(_ c1: ContactData, c2: ContactData) -> Bool {
        return c1.contactName < c2.contactName
    }
    
    func qsort(_ input: [String]) -> [String] {
        if let (pivot, rest) = input.decompose {
            let lesser = rest.filter { $0 < pivot }
            let greater = rest.filter { $0 >= pivot }
            return qsort(lesser) + [String(pivot)] + qsort(greater)
        } else {
            return []
        }
    }
  func getFriends() {
        
        if !self.isReachable() {
            return
        }
        
        
        
        let defaults    = UserDefaults.standard;
        let userId      = defaults.value(forKeyPath: "userData.user_id") as! String
        self.view.isUserInteractionEnabled = false
        
        
        var pNumbers : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: self.phoneNumbers, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            pNumbers = string! as NSString
        }catch let error as NSError{
            print(error.description)
        }
        
        
        let params : Parameters = ["userID" : userId,"phoneNumbers":pNumbers]
        Alamofire.request(baseUrl + "viewFriends", method: HTTPMethod.post, parameters: params)
            .responseJSON { response in
               // self.activityIndicator.stopAnimating()
                self.arrFriends = []
                
                if let jsonResponse = response.result.value as? NSDictionary {
                    print(jsonResponse)
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        let arr: NSArray = self.arrContactsData as NSArray
                        let arrContact = jsonResponse["data"] as! Array<NSDictionary>
                        for dic: NSDictionary in arrContact {
                            
                            if var phoneNumber: String = dic["phoneNumber"] as? String {
                                let pNumber = String(AppUtility.sharedInstance.removeCountryCode(phoneNumber))
                                print(pNumber)
                                
                                phoneNumber = pNumber
                                if phoneNumber.characters.count  > 1 {
                                    let start = phoneNumber.index(phoneNumber.startIndex, offsetBy: 1)
                                    let end = phoneNumber.index(phoneNumber.endIndex, offsetBy: 0)
                                    let range = start..<end; phoneNumber = phoneNumber.substring(with: range);}
                                let predicate: NSPredicate = NSPredicate(format: "contactPhone contains[cd] %@", phoneNumber)
                                let arrResult = arr.filtered(using: predicate) as NSArray
                                
                                if arrResult.count > 0 {
                                    var friendData: [String:Any] = [:]
                                    friendData["userId"] = dic["user_id"] as! String
                                    friendData["userName"] = dic["username"] as! String
                                    
                                    friendData["photo"] = dic["photo"] as! String
                                    friendData["selected"] = false
                                    self.arrFriends.append(friendData as NSDictionary)
                                }
                            }
                        }
                        
                        self.arrFriendsData = self.arrFriends
                        self.arrFriendBackup = self.arrFriendsData as NSArray
                        self._collectionView.reloadData()
                        
                        
                    }
                    else {
                        //self.alert(jsonResponse["msg"] as! String)
                    }
                }
                self.view.isUserInteractionEnabled = true
        }
    }
    
    @IBAction  func doneBtnPressed(_ sender: AnyObject) {
        
        var isAnyPerson: Bool = false
        var selectedUserCount: Int = 0;
        
        var userIds: String = ""
        
        for fData: NSDictionary in self.arrFriendsData {
            //let fData2
            if fData["selected"] as? Bool == true {
                selectedUserCount += 1
                if userIds.isEmpty {
                    userIds = fData["userId"] as! String
                }
                else {
                    userIds += ",\(fData["userId"])"
                }
                isAnyPerson = true
            }
        }
        if(selectedUserCount>0){
            if(selectedUserCount == 1){
                self.userMessage = "You just PUSHED your friend"
            }
            else if(selectedUserCount == self.arrFriendsData.count){
                self.userMessage = "You just PUSHED all your friends"
            }
            else{
                self.userMessage = "You just PUSHED your friends"
            }
        }
        
        if !isAnyPerson {
            self.alert("Please select atleast one Friend")
        }
        
        else {
            if !self.isReachable() {
                return
            }
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
                
                let bounds = UIScreen.main.bounds
                let yPosition = bounds.size.height + self.pushView.frame.size.height
                self.pushView.frame = CGRect(x: 0, y: yPosition, width: self.pushView.frame.size.width, height: self.pushView.frame.size.height)
                
                }, completion: { (finished: Bool) -> Void in
                    self.scrollView.isHidden = true
                    // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
            })
            
            
            
            
           let defaults = UserDefaults.standard;
           let senderName = defaults.value(forKeyPath: "userData.username") as! String
           let userID = defaults.value(forKeyPath: "userData.user_id") as! String
            
           self.view.isUserInteractionEnabled = false
            self.showActivityIndicator();
            
            let params : Parameters = [
                "senderName"    : senderName,
                "userId"        : userIds,
                "link"          : self.link!,
                "title"         :self.titleWeb!,
                "senderId"      : userID,
                "objectId"      :self.objectId!,
                "merchantId"    : self.subAdminId!,
                "userCaption"   :userCaption.text!,
                "contentType"   :self.notificationType
            ]
            print(baseUrl + "sendPush");
            print(params)
            Alamofire.request(baseUrl + "sendPush", parameters:params)
                    .responseJSON { response in
                        self.view.isUserInteractionEnabled = true
                        self.hideActivityIndicator()
                       
                        
                        self.userCaption.text! = ""
                        self.isSelectedAll = true
                        self.selectAllBtn.isSelected = true
                        self.selectAllBtnPressed(self.selectAllBtn)
                        
                        if let jsonResponse = response.result.value  as? NSDictionary{
                            
                            if (jsonResponse["status"] as! String == "SUCCESS") {
                                self.view.isUserInteractionEnabled = true
                                self.hideActivityIndicator()
                                self.alert( self.userMessage as String)
                            }
                            else {
                                self.view.isUserInteractionEnabled = true
                                self.hideActivityIndicator()
                                //self.activityIndicator.stopAnimating()
                                self.alert(jsonResponse["message"] as! String)
                                
                            }
                        }
                        else{
                            self.view.isUserInteractionEnabled = true
                            self.hideActivityIndicator()
                            //self.activityIndicator.stopAnimating()
                        }
                
            }
        }
    }
    @IBOutlet weak var selectAllBtn: Button!
    
  @IBAction func selectAllBtnPressed(_ sender: UIButton) {
        if(sender.isSelected == false){
            sender.isSelected = true;
        }else{
             sender.isSelected = false;
        }
        
        isSelectedAll = !isSelectedAll
        var j = 0
        for fData:NSDictionary in self.arrFriendsData {
             let fData2 = fData.mutableCopy() as! NSMutableDictionary
            fData2["selected"] = isSelectedAll
            self.arrFriendsData[j] = fData2
            j = j + 1
        }
        self._collectionView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    @IBAction func selectFriend(_ sender: UIButton) {
        let  fData: NSDictionary  = self.arrFriendsData[sender.tag]
        let fData2 = fData.mutableCopy() as! NSMutableDictionary
        if(sender.isSelected == false){
            sender.isSelected = true;
            fData2["selected"] = true
        }else{
            sender.isSelected = false;
            fData2["selected"] = false
        }
        self.arrFriendsData[sender.tag] = fData2
    }
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool
    {
        let maxLength = 80
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    //UISearchBar integration
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchB.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        // searchActive = false;
        searchB.showsCancelButton = false
        // self.createDictionaryOfArray(locData as [AnyObject])
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchB.showsCancelButton = false
        searchBar.text = ""
        self.arrFriendsData = arrFriendBackup.copy() as! NSArray as! Array<NSDictionary>
        self._collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // self.createDictionaryOfArray(locData as [AnyObject])
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
       if(searchText != ""){
                  let arrTempSearch:NSMutableArray = []
                  
                  
                  for friendData:NSDictionary in (self.arrFriendBackup as NSArray as! [NSDictionary]){
                      let options = NSString.CompareOptions.caseInsensitive
                      let found = (friendData["userName"] as! String).range(of: searchText, options: options)
                      if ((found) != nil) {
                          arrTempSearch.add(friendData)
                      }
                  }
                  self.arrFriendsData = arrTempSearch.copy() as! NSArray as! Array<NSDictionary>
              }
              else{
                  self.arrFriendsData = arrFriendBackup.copy() as! NSArray as! Array<NSDictionary>
              }
        
        self._collectionView.reloadData()
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
