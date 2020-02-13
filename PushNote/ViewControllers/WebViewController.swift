//
//  WebViewController.swift
//  PushNote
//
//  Created by Rizwan on 12/12/14.
//  Copyright (c) 2014 com. All rights reserved.
//

import UIKit
import Alamofire
import AddressBookUI
import AVFoundation
import Contacts
class WebViewController:
    BaseViewController,
    UITextFieldDelegate,
    PayPalPaymentDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UISearchBarDelegate {
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var songImg: UIImageView!
    @IBOutlet weak var userCaption: TextField!
    var senderId : Int = 0;
    var productData : NSDictionary = NSDictionary()
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var searchB: UISearchBar!
    var phoneNumbers : NSMutableArray = []
    var selectedFriends : NSMutableArray = []
    var arrFriendBackup : NSArray = []
    var arrTempSearch : NSArray = []
    var btnDone: UIButton!
    var isSelectedAll: Bool = false
    var userMessage: NSString!
    var event : String = "View"
    var shareType  :String = "";
    var countryCodes = ["93",
        "355",
        "213",
        "1684",
        "376",
        "244",
        "1264",
        "672",
        "1268",
        "54",
        "374",
        "297",
        "61",
        "43",
        "994",
        "1242",
        "973",
        "880",
        "1246",
        "375",
        "32",
        "501",
        "229",
        "1441",
        "975",
        "591",
        "387",
        "267",
        "55",
        "1284",
        "673",
        "359",
        "226",
        "95",
        "257",
        "855",
        "237",
        "238",
        "1345",
        "236",
        "235",
        "56",
        "86",
        "61",
        "61",
        "57",
        "269",
        "682",
        "506",
        "385",
        "53",
        "357",
        "420",
        "243",
        "45",
        "253",
        "1767",
        "1809",
        "593",
        "20",
        "503",
        "240",
        "291",
        "372",
        "251",
        "500",
        "298",
        "679",
        "358",
        "33",
        "689",
        "241",
        "220",
        "970",
        "995",
        "49",
        "233",
        "350",
        "30",
        "299",
        "1473",
        "1671",
        "502",
        "224",
        "245",
        "592",
        "509",
        "39",
        "504",
        "852",
        "36",
        "354",
        "91",
        "62",
        "98",
        "964",
        "353",
        "44",
        "972",
        "39",
        "225",
        "1876",
        "81",
        "962",
        "7",
        "254",
        "686",
        "381",
        "965",
        "996",
        "856",
        "371",
        "961",
        "266",
        "231",
        "218",
        "423",
        "370",
        "352",
        "853",
        "389",
        "261",
        "265",
        "60",
        "960",
        "223",
        "356",
        "692",
        "222",
        "230",
        "262",
        "52",
        "691",
        "373",
        "377",
        "976",
        "382",
        "1664",
        "212",
        "258",
        "264",
        "674",
        "977",
        "31",
        "599",
        "687",
        "64",
        "505",
        "227",
        "234",
        "683",
        "672",
        "850",
        "1670",
        "47",
        "968",
        "92",
        "680",
        "507",
        "675",
        "595",
        "51",
        "63",
        "870",
        "48",
        "351",
        "1",
        "974",
        "242",
        "40",
        "7",
        "250",
        "590",
        "290",
        "1869",
        "1758",
        "1599",
        "508",
        "1784",
        "685",
        "378",
        "239",
        "966",
        "221",
        "381",
        "248",
        "232",
        "65",
        "421",
        "386",
        "677",
        "252",
        "27",
        "82",
        "34",
        "94",
        "249",
        "597",
        "268",
        "46",
        "41",
        "963",
        "886",
        "992",
        "255",
        "66",
        "670",
        "228",
        "690",
        "676",
        "1868",
        "216",
        "90",
        "993",
        "1649",
        "688",
        "256",
        "380",
        "971",
        "44",
        "598",
        "1340",
        "998",
        "678",
        "58",
        "84",
        "681",
        "970",
        "967",
        "260",
        "263"];
    var arrFriends:             Array<NSDictionary> = []
    var arrFriendsData:         Array<NSDictionary>   = []
    var arrContacts:            Array<NSDictionary>  = []
    var arrContactsData:        Array<NSDictionary>  = []
    var arrInviteFriendsData:   Array<NSDictionary>  = []
    var selectedFriendsNew      : NSMutableArray = []
    
    var addressBook: ABAddressBook?
    
    @IBOutlet weak var musicType: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songId: UILabel!
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var _collectionView: UICollectionView!
    
    @IBOutlet weak var pushView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var link                :   String?         = ""
    var titleWeb            :   String?         = "Home"
    var isFromNotification  :   Bool            = false
    var subAdminId          :   String?         = ""
    var id                  :   Int             = 0 ;
    var objectId            :   String?         = "";
    var notificationType    :   String          = "Feed"
    var notificationType1   :   String          = "Product"
    var notifictionId       :   Int             = 0
    var musicPlayer         :   AVAudioPlayer?  ;
   
    var mp3Player           :   MP3Player?
    var timer               :   Timer?
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackTime: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBAction func playPause(_ sender: UIButton) {
        if(sender.isSelected == true){
            sender.isSelected = false
            mp3Player?.pause()
            timer?.invalidate()
            activityIndicator.stopAnimating()
        }else{
            sender.isSelected = true
             mp3Player?.play()
            startTimer()
        }
    }
    @objc func updateViewsWithTimer(_ theTimer: Timer){
        updateViews()
    }
   
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(WebViewController.updateViewsWithTimer(_:)), userInfo: nil, repeats: true)
    }
    func updateViews(){
        if (( mp3Player?.checkIfPlayerIsPlaying()) == true){
            activityIndicator.stopAnimating()
        }else{
            activityIndicator.startAnimating()
        }
        trackTime.text = mp3Player?.getCurrentTimeAsString()
        if let progress = mp3Player?.getProgress() {
            if (progress == 0.0){
                timer?.invalidate()
                if(playPauseBtn.isSelected == true){
                    playPauseBtn.isSelected = false
                    activityIndicator.stopAnimating()
                }
            }
            progressBar.progress = progress
        }
    }
   
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.addBackBtn2()
        userCaption.delegate = self
        userCaption.autocorrectionType = UITextAutocorrectionType.no
        searchB.autocorrectionType = UITextAutocorrectionType.no
        //Notification
       
        NotificationCenter.default.addObserver(self, selector: #selector(WebViewController.windowNowVisible(_:)),
                    name: UIWindow.didBecomeKeyNotification,
                    object: self.view.window)

        self.navigationItem.title = titleWeb
        self.getContacts()
        if(self.notificationType == "Music"){
            self.progressBar.trackImage = UIImage(named: "bar")
            self.progressBar.progressImage = UIImage(named: "fill-bar")
            Alamofire.request(baseUrl + "getMusicDetails/" + self.objectId!)
                .responseJSON { response in
                    self.activityIndicator.stopAnimating()
                    if let jsonResponse = response.result.value as? NSDictionary {
                        if (jsonResponse["status"] as! String == "SUCCESS") {
                            let songDetails = jsonResponse["data"] as? NSDictionary
                            if(songDetails!["music_type"] as! String == "SoundCloud" || songDetails!["music_type"] as! String == "iTunes"    ||
                                songDetails!["music_type"] as! String == "Spotify"
                                ){
                                self.musicType.text = songDetails!["music_type"] as? String
                                
                                self.mp3Player = MP3Player()
                                var  apiUrl = ""
                                if(songDetails!["music_type"] as! String == "SoundCloud" ){
                                 let trackId = String(describing: songDetails!["songId"]!)
                               
                                 let clientId = "709efb08a8e23396d4faed45224e2fa5"
                                  apiUrl = "https://api.soundcloud.com/tracks/\(trackId)/stream?client_id="+clientId
                                }else{
                                    apiUrl = String(describing: songDetails!["songId"]!)
                                }
                             
                        if let songUrl = songDetails!["imageUrl"] as? String {
                            self.songImg.sd_setImage(with: NSURL(string: songUrl) as! URL)
                        }
                               
                               
                                self.songTitle.text = songDetails!["music_name"] as? String
                                self.activityIndicator.startAnimating()
                              
                                Alamofire.request(apiUrl)
                                    .response{ response  in
                                        self.activityIndicator.stopAnimating()
                                        self.playerView.isHidden = false
                                        self.mp3Player?.queueTrack(response.data!)
                                        
                                }
                                
                            }else{
                                self.previewWebLink()
                            }
                            
                        }else{
                            self.previewWebLink()
                        }
                    }else{
                        self.previewWebLink()
                    }
            }
                  
        }else if (self.notificationType == "Product"){
            self.buyBtn.isHidden = false;
            if let pType = self.productData["type"] as? String{
                if(pType == "Product" || pType == "Iframe"){
                    self.link = servicesPath + "product/index/" + self.objectId!
                }else{
                    self.link = self.productData["link"]! as! String
                }
            }
            print(self.link)
            self.previewWebLink()
        }else{
            self.previewWebLink()
        }
    }
    
   
   
    func previewWebLink(){
        if var url = self.link {
            url = url.trimmingCharacters(in: .whitespacesAndNewlines)
            print(url)
            if let url1 = URL(string:url) as? URL{
                if let request =  NSMutableURLRequest(url: url1) as? NSMutableURLRequest {
                    self.webView.loadRequest(request as URLRequest)
                }
            }
            self.event = "View"
            self.saveAnalytics(self.link!, objectID:self.objectId!, merchantID: self.subAdminId!)
        }
    }
    func addBackBtn2(){
        
        let barbutton = UIBarButtonItem(image: UIImage(named: "backBtn"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(WebViewController.backBtnPressed1))
        //barbutton.tintColor = UIColor.whiteColor()
        // let image = UIImage(named: IMG_MENU)?.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = barbutton
    }
    @objc func backBtnPressed1() {
        if self.id > 0 {
            //Update Analytics time
             self.event = "View"
            self.saveAnalytics(self.link!, objectID:self.objectId!, merchantID: self.subAdminId!)
        }
        
        if self.isFromNotification {
          //  self.alert("Notification")
            self.navigationController?.view.removeFromSuperview()
        }
        else {
             //self.alert("Notification2")
             self.navigationController?.popViewController(animated: true)
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {

         self.activityIndicator.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //self.hideActivityIndicator()
        
        self.activityIndicator.stopAnimating()
    }
    
    @IBAction func shareMediaBtnPressed(_ sender: AnyObject) {
        
        let inviteViewController = self.storyboard?.instantiateViewController(withIdentifier: "InviteFriendsViewController")as!UINavigationController
        self.present(inviteViewController, animated: true, completion: nil);
        
    }
    
    @IBAction func shareFriendsBtnPressed(_ sender: AnyObject) {
        
    }
    var newBtn : UIButton = UIButton();
    @IBAction func actionShare(_ sender: AnyObject) {
        
        
        self.newBtn = sender as! UIButton
        
        let shareContent:String = "Just got a Pushnote from \(link!). Subscribe here https://itunes.apple.com/gb/app/push-note/id962393538?mt=8"
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
          // self.alert("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
           // print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            
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
                }else  if String(describing: activity!).lowercased().range(of: "googleplus") != nil {
                    shareT = "GooglePlus"
                }
                
                if(shareT != ""){
                    self.event      = "Share"
                    self.shareType  = shareT
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
       
    }
    
    func animateView (){
        self.scrollView.isHidden = false
       
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            let bounds = self.scrollView.bounds; print(UIScreen.main.bounds);print(bounds)
            let yPosition = bounds.size.height - self.pushView.frame.size.height 
          
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
    
    @IBAction func actionPush(_ sender: AnyObject) {
        
        animateView()
        return
        
        let pushView:PushView = PushView.instanceFromNib()
        pushView.animateView()
        self.view.addSubview(pushView)
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
    @objc func windowNowVisible(_ notification:Notification){
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
        let strId = String(id);
        let strNotificationId = String(notifictionId)
       
      
      
        let params : Parameters = [
            "userId"            : userId,
            "link"              :lnk,
            "objectId"          : objectID,
            "merchantId"        :merchantID,
            "id"                :strId,
            "deviceType"        :"Ios",
            "contentType"       :self.notificationType,
            "notificationId"    :strNotificationId,
            "event"             :self.event,
            "shareType"         :self.shareType,
            "inviteeId"         :String(self.senderId)
        ] ;
        
        Alamofire.request(baseUrl + "saveAnalytics", parameters:params)
            .responseJSON { response in
                
                if let jsonResponse = response.result.value as? NSDictionary{
                    print(jsonResponse)
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        if(self.id == 0){
                            if(self.event == "View"){
                                self.id = jsonResponse["contentId"] as! Int
                            }
                        }
                    }
                    else {
                        
                    }
                }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!isFromNotification){
//          self.tabBarController!.tabBar.isHidden = true
        }
        print("HERe");
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(!isFromNotification){
           // self.tabBarController!.tabBar.isHidden = false
        }
        print("HERe1");
       
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
                                let number2 = self.removeCountryCode(number1)
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
    func getContactNames() {
        var errorRef: Unmanaged<CFError>?
        addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        let contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        
        var _: ABMultiValue
        
        var arr: Array<NSDictionary> = []
        
        for record in contactList {
            let contactPerson: ABRecord = record as ABRecord
            
            //var compositeName: Unmanaged<CFString> = ABRecordCopyCompositeName(contactPerson)
            if let compositeName = ABRecordCopyCompositeName(contactPerson) {
                
                let contactName: String = compositeName.takeRetainedValue() as String
                let unmanagedPhones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty)
                let phoneObj: ABMultiValue = Unmanaged.fromOpaque(unmanagedPhones!.toOpaque()).takeUnretainedValue() as NSObject as ABMultiValue
                var contactData : [String:Any] = [:]
                if ABMultiValueGetCount(phoneObj) != 0 {
                    
                    let index = 0 as CFIndex
                    let unmanagedPhone = ABMultiValueCopyValueAtIndex(phoneObj, index)
                    let phoneNumber:String = Unmanaged.fromOpaque(unmanagedPhone!.toOpaque()).takeUnretainedValue() as NSObject as! String
                    
                    let number = phoneNumber.replacingOccurrences(of: "[\\(\\)\\ \\-]", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
                    let number1 =  number.condenseWhitespace()
                    let number2 = self.removeCountryCode(number1)
                    let trimmedString = number2.replacingOccurrences(of: " ", with: "")
                    
                    
                    
                    self.phoneNumbers.add(trimmedString)
                    contactData["contactName"]  = contactName
                    contactData["contactPhone"] = trimmedString
                    
                }
                else {
                    contactData["contactName"] = contactName
                    //dic = NSDictionary(object: contactName, forKey: "contactName")
                }
                
                arr.append(contactData as! NSDictionary)
            }
        }
        
       // self.arrContacts = arr.sorted(by: forwards)
        self.arrContactsData = arr
       
    }
    func removeCountryCode(_ phoneNumber:String) -> String {
        var number:NSString = phoneNumber as NSString
        number = number.replacingOccurrences(of: "+", with: "") as NSString
        let predicate: NSPredicate = NSPredicate(format: "%@ BEGINSWITH[cd] self", number)
        let arr = self.countryCodes as NSArray
        let arrResult = arr.filtered(using: predicate) as NSArray
        if arrResult.count > 0 {
            number = number.substring(from: (arrResult[0] as! NSString).length) as NSString
        }
        return number as String;
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
                self.activityIndicator.stopAnimating()
                self.arrFriends = []
                
                if let jsonResponse = response.result.value as? NSDictionary {
                    print(jsonResponse)
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        let arr: NSArray = self.arrContactsData as NSArray
                        let arrContact = jsonResponse["data"] as! Array<NSDictionary>
                        for dic: NSDictionary in arrContact {
                            
                            if var phoneNumber: String = dic["phoneNumber"] as? String {
                                let pNumber = String(self.removeCountryCode(phoneNumber))
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
    
    
    //UISearchBar integration
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchB.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // searchActive = false;
        searchB.showsCancelButton = false
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool
    {
        let maxLength = 80
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        //print(self.mp3Player)
        self.mp3Player?.stop()
        
        
    }
    
    /*
    func selectAllNotification(sender:AnyObject){
        self.topMenuBtn = "Done"
        selectedNotifications = []
        for  arrNot in self.arrNotifications{
            selectedNotifications.addObject((arrNot["id"] as? String)!)
        }
        self.collectionViewData.reloadData()
        self.updateCollectionView()
    }
    func unSelectAllNotification(sender:AnyObject){
        self.topMenuBtn = "Edit"
        selectedNotifications = []
        self.collectionViewData.reloadData()
        self.updateCollectionView()
    }
*/
    
    @IBAction func buyNow(_ sender: Any) {
        self.InitializedPayPalControllerWithItem()
        
    }
    
    
    //MARK: PayPalPaymentDelegate & Methods
    func InitializedPayPalControllerWithItem(){
      
        
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction:"AZOZoTsIhMCCmxlllyu4ogSCeLtlhMRqJSNoB7y_7ysQeU3ECa4hJXFrDE74H71IFnKXXaao9kvjHCDE"])
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
        if let pTitle = self.productData["title"] as? String{
        
        let item1 = PayPalItem()
        item1.name = pTitle
        item1.quantity = 1
        item1.price = NSDecimalNumber(string: self.productData["price"] as? String)
        item1.currency = "USD"
        
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal:subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: pTitle, intent: .sale)
        
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
    }
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController!) {
        print("PayPal Payment Cancelled")
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController!, didComplete completedPayment: PayPalPayment!) {
        
            paymentViewController?.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
                if let paymentInfo = completedPayment.confirmation as? NSDictionary{
                    
                    let dicResponse: AnyObject? = paymentInfo.object(forKey: "response") as AnyObject
                    self.showActivityIndicator();
                    var params : Parameters = [:]
                    if let uId =  UserDefaults.standard.value(forKeyPath: "userData.user_id") as? String{
                        params["userId"] = uId;
                    }
                    params["referalUserId"]         = self.senderId;
                    params["productId"]             = self.productData["productId"];
                    params["transactionId"]         = dicResponse?.object(forKey: "id") as! String
                    params["referalId"]             = self.productData["id"];
 
                    Alamofire.request(baseUrl + "purchaseProduct",method: HTTPMethod.post, parameters: params)
                        .responseJSON{ response in
                            self.hideActivityIndicator()
                            if let jsonResponse = response.result.value as? NSDictionary {
                                if (jsonResponse["status"] as! String == "SUCCESS") {
                                   self.alert(jsonResponse["message"] as! String);
                                }else{
                                    self.alert(jsonResponse["message"] as! String);
                                }
                            }
                    }
                }
        })
    }
}
