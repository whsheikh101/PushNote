//
//  FriendsViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 28/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import AddressBookUI
import MessageUI
import CoreLocation
import Contacts
extension Array {
    var decompose : (head: Element, tail: [Element])? {
        return (count > 0) ? (self[0], Array(self[1..<count])) : nil
    }
}

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}

class FriendsViewController: BaseViewController,
    MFMessageComposeViewControllerDelegate,
    CLLocationManagerDelegate,
    UITextViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
UISearchBarDelegate{
    
    
    fileprivate var locationManager = CLLocationManager()
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var isRefreshing : Bool = false
    var btnDone: UIButton!
    var selectedUserId:String?
    
    @IBOutlet weak var userCaptionField: UITextField!
    var arrFriendBackup : NSArray = []
    var arrTempSearch : NSArray = []
    @IBOutlet weak var searchB: UISearchBar!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var txtViewMsg: UITextView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var _tableView: UITableView!
    @IBOutlet weak var btnFriends: UIButton!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var btnSelectAll: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var latLong : String = ""
    var arrFriends: Array<NSDictionary> = []
    var arrFriendsData: Array<NSDictionary> = []
    
    
    
    
    var arrContacts: Array<NSDictionary> = []
    var arrContactsData: Array<NSDictionary> = []
    var arrInviteFriendsData: Array<NSDictionary> = []
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
    
    var addressBook: ABAddressBook?
    var isSelectAllFriends: Bool = false
    var isSelectAllInvited: Bool = false
    
    var selectedCount: Int = 0
    
    @IBOutlet weak var textFieldBgConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldConstraint: NSLayoutConstraint!
    var phoneNumbers : NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setTabbar()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        // _tableView.editing = true
        self.navigationItem.title = "FRIENDS"
        /*let qualityOfServiceClass = QOS_CLASS_BACKGROUND
         let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
         dispatch_async(backgroundQueue, {
         
         })*/
        DispatchQueue.main.async(execute: {
            self.getContacts()
            
        })
        
        let unselectedColor = UIColor.init(red: 0.0862745098, green: 0.168627451, blue: 0.3137254902, alpha: 1.0)
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: unselectedColor]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(FriendsViewController.reloadContacts), for: UIControl.Event.valueChanged)
        self._tableView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    @objc func reloadContacts(){
        self.isRefreshing = true
        self.getContacts()
    }
    func setTabbar() {
        
        self.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(named: "friendsTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "friends-activeTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableView integration
    
    
    //    func numberOfSections(in tableView: UITableView) -> Int{
    //        return 2
    //    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        if self.arrFriendsData.count == 0 {
            
            let dict = NSMutableDictionary()
            dict["userId"] = "dummyID"
            dict["selected"] = false
            dict["userName"] = "dummyUserName"
            dict["contactName"] = "dummyContactName"
            dict["userNumber"] = "03312275651"
            dict["photo"] = ""
            
            self.arrFriendsData.append(dict)
            self.arrFriendsData.append(dict)
}
        
        if arrInviteFriendsData.count == 0{
            
            let dict = NSMutableDictionary()
            dict["userId"] = "dummyID"
            dict["selected"] = false
            dict["userName"] = "dummyUserName"
            dict["contactName"] = "dummyContactName"
            dict["contactPhone"] = "03312275651"
            dict["photo"] = ""

            self.arrInviteFriendsData.append(dict)
            self.arrInviteFriendsData.append(dict)
        }
        
        return (self.segmentControl.selectedSegmentIndex == 0) ? self.arrFriendsData.count : self.arrInviteFriendsData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = (self.segmentControl.selectedSegmentIndex == 0) ? tableView.dequeueReusableCell(withIdentifier: "Cell1") as! CustomTableCell : tableView.dequeueReusableCell(withIdentifier: "Cell2") as! CustomTableCell
        
        //let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath) ;
        
        //let imageViewBg: UIImageView = cell.contentView.viewWithTag(1000) as! UIImageView
        //imageViewBg.image = UIImage(named: "bg-find-friend-" + String(indexPath.row%4+1));
        
        //let lblName: UILabel = cell.contentView.viewWithTag(1001) as! UILabel
        /*
         let lblDesc: UILabel = cell.contentView.viewWithTag(1002) as! UILabel
         let btnLock: UIButton = cell.contentView.viewWithTag(1003) as! UIButton
         let btnNoti: UIButton = cell.contentView.viewWithTag(1004) as! UIButton
         
         let btnCheckbox: UIButton = cell.contentView.viewWithTag(1005) as! UIButton
         
         
         let btnShareLocation: UIButton = cell.contentView.viewWithTag(1007) as! UIButton
         
         if (btnInvite.selected) {
         let contactData = self.arrContactsData[indexPath.row]
         lblName.text = contactData.contactName
         lblDesc.text = contactData.contactPhone
         btnLock.hidden = true
         btnNoti.hidden = true
         btnCheckbox.selected = contactData.selected
         btnCheckbox.hidden = false
         imageViewbox.hidden = false
         btnShareLocation.hidden = true
         }
         else {
         let friendData: FriendData = self.arrFriendsData[indexPath.row]
         lblName.text = friendData.userName + "\n" + friendData.contactName
         lblDesc.text = friendData.userNumber
         btnLock.hidden = false
         btnNoti.hidden = false
         btnCheckbox.selected = friendData.selected
         btnCheckbox.hidden = true
         imageViewbox.hidden = true
         btnShareLocation.hidden = false
         }
         */
        
        if(self.segmentControl.selectedSegmentIndex == 0){
            
            let lblName: UILabel = cell.contentView.viewWithTag(1001) as! UILabel
            let btnLock: UIButton = cell.contentView.viewWithTag(1003) as! UIButton
            let btnNoti: UIButton = cell.contentView.viewWithTag(1004) as! UIButton
            let imageViewbox: UIImageView = cell.contentView.viewWithTag(1006) as! UIImageView
            
            let friendData: NSDictionary = self.arrFriendsData[indexPath.row]
            lblName.text = ((friendData["userName"] as? String)!) + "\n" + ((friendData["contactName"] as? String)!)
            
            cell.contactPhone.text = friendData["userNumber"] as? String
            
            let imagePathUrl = URL(string: ((friendData["photo"] as? String)!) )
            let defaultImg = UIImage(named: "user icon")
            imageViewbox.sd_setImage(with: imagePathUrl, placeholderImage: defaultImg)
            //lblDesc.text = friendData.userNumber
            btnLock.isHidden = false
            btnNoti.isHidden = false
            
            // btnCheckbox.selected = friendData.selected
            // btnCheckbox.hidden = true
            //  imageViewbox.hidden = true
            //  btnShareLocation.hidden = false
            
        }else{
            
            
            if let contactData = self.arrInviteFriendsData[indexPath.row] as? NSDictionary{
                cell.contactName.text = contactData["contactName"] as? String
                cell.contactPhone.text = contactData["contactPhone"] as? String
                cell.inviteBtn.tag = indexPath.row
            }
            
            
            
        }
        
        
        cell.backgroundColor = UIColor.white
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath){
        if (editingStyle == UITableViewCell.EditingStyle.delete)
        {
            _tableView.beginUpdates()
            _tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.middle)
            _tableView.endUpdates()
        }
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        // let arrayOfKeys = Array(locationDataDictionary.keys).sort{ $0 > $1 }
    //        let  headerCell:UITableViewCell?
    //        headerCell = tableView.dequeueReusableCell(withIdentifier: "HCell")
    //
    //        let lblHeader = headerCell?.viewWithTag(100) as! Label
    //        if(section == 0) {
    //            lblHeader.text = "FRIENDS ON PUSH NOTE"
    //        }
    //        else {
    //            lblHeader.text = "INVITE PUSH NOTE"
    //        }
    //        return headerCell
    //    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //
    //        if(DeviceType.IS_IPAD) {
    //
    //            return 68.0
    //        }
    //        else{
    //
    //            return 48.0
    //        }
    //
    //
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(DeviceType.IS_IPAD) {
            
            if(self.segmentControl.selectedSegmentIndex == 0) {
                
                return 80.0;
            }
            else{
                return 60.0
            }
        }
        
        if(self.segmentControl.selectedSegmentIndex == 0) {
            
            return 100.0;
        }
        else{
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if(self.segmentControl.selectedSegmentIndex == 0){
            
            // let friendsPopup = FriendsPopup.instanceFromNib()
            //friendsPopup.animateView()
            // self.view.addSubview(friendsPopup)
        }
        
    }
    func extractABAddressBookRef(_ abRef: Unmanaged<ABAddressBook>!) -> ABAddressBook? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    var arr2 : NSMutableArray = NSMutableArray();
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
    
    func showAlert() {
        
        let alert :UIAlertView = UIAlertView(title: "Access denied", message: "Please goto the Settings > PushNote > Enable Contacts", delegate: nil, cancelButtonTitle: "OK")
        alert.show();
        
        self.arrContacts = []
        self.arrContactsData = []
        self.arrFriends = []
        self.arrFriendsData = []
        self.activityIndicator.stopAnimating()
        //self.hideActivityIndicator()
    }
    /*
     func getContactNames() {
     var errorRef: Unmanaged<CFError>?
     addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
     let contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
     
     var _: ABMultiValue
     
     var arr: Array<ContactData> = []
     
     for record  in contactList {
     let contactPerson: ABRecord = record as ABRecord
     
     //var compositeName: Unmanaged<CFString> = ABRecordCopyCompositeName(contactPerson)
     if let compositeName = ABRecordCopyCompositeName(contactPerson) {
     
     let contactName: String = compositeName.takeRetainedValue() as String
     let unmanagedPhones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty)
     let phoneObj: ABMultiValue = Unmanaged.fromOpaque(unmanagedPhones!.toOpaque()).takeUnretainedValue() as NSObject as ABMultiValue
     let contactData = ContactData()
     if ABMultiValueGetCount(phoneObj) != 0 {
     
     let index = 0 as CFIndex
     let unmanagedPhone = ABMultiValueCopyValueAtIndex(phoneObj, index)
     let phoneNumber:String = Unmanaged.fromOpaque(unmanagedPhone!.toOpaque()).takeUnretainedValue() as NSObject as! String
     
     let number = phoneNumber.replacingOccurrences(of: "[\\(\\)\\ \\-]", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
     let number1 =  number.condenseWhitespace()
     let number2 = self.removeCountryCode(number1)
     let trimmedString = number2.replacingOccurrences(of: " ", with: "")
     
     
     
     self.phoneNumbers.add(trimmedString)
     contactData.contactName = contactName
     contactData.contactPhone = trimmedString
     
     }
     else {
     contactData.contactName = contactName
     //dic = NSDictionary(object: contactName, forKey: "contactName")
     }
     
     arr.append(contactData)
     }
     }
     
     self.arrContacts = arr.sorted(by: forwards)
     self.arrContactsData = self.arrContacts
     self._tableView.reloadData()
     
     }
     */
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
        
        
        
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        self.view.isUserInteractionEnabled = false
        
        
        var pNumbers : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: self.phoneNumbers, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            pNumbers = string! as NSString
            
        }catch let error as NSError{
            print(error.description)
        }
        if(self.isRefreshing == false){
            self.showActivityIndicator()
        }
        self.isRefreshing = false
        var params  : Parameters = [:];
        
        params["userID"]        = userId;
        params["phoneNumbers"] = pNumbers;
        
        
        Alamofire.request(baseUrl + "viewFriends", method: HTTPMethod.post, parameters: params)
            .responseJSON { response in
                self.activityIndicator.stopAnimating()
                self.arrFriends = []
                self.arrInviteFriendsData = []
                
                if let jsonResponse = response.result.value as? NSDictionary{
                    print(jsonResponse["status"]);
                    
                    if (jsonResponse["status"] as? String == "SUCCESS") {
                        
                        let arr: NSArray = self.arrContactsData as NSArray
                        let arrContact = jsonResponse["data"] as! Array<NSDictionary>
                        print(arrContact)
                        
                        for dic: NSDictionary in arrContact {
                            
                            if var phoneNumber: String = dic["phoneNumber"] as? String {
                                let pNumber = String(self.removeCountryCode(phoneNumber))
                                phoneNumber = pNumber
                                if phoneNumber.count  > 1 {
                                    let start = phoneNumber.index(phoneNumber.startIndex, offsetBy: 1)
                                    let end = phoneNumber.index(phoneNumber.endIndex, offsetBy: 0)
                                    let range = start..<end; phoneNumber = phoneNumber.substring(with: range);
                                }
                                print(phoneNumber);
                                
                                // let predicate: NSPredicate = NSPredicate(format: "contactPhone contains[cd] %@", phoneNumber)
                                
                                let predicate: NSPredicate =  NSPredicate(format: "contactPhone contains[cd] %@", phoneNumber)
                                
                                
                                let arrResult = arr.filtered(using: predicate) as NSArray
                                
                                if arrResult.count > 0 {
                                    var friendData: [String:Any?] = [:]
                                    
                                    friendData["userId"] = dic["user_id"] as? String
                                    friendData["userName"] = dic["username"] as? String
                                    friendData["selected"] = false
                                    //  friendData.contactName = arrResult[]
                                    if let arrRes = arrResult[0] as? NSDictionary{
                                        friendData["contactName"] = (arrRes["contactName"] as? String)!
                                        friendData["userNumber"] = (arrRes["contactPhone"] as? String)!
                                    }
                                    
                                    friendData["photo"] = dic["photo"] as! String
                                    self.arrFriends.append(friendData as! NSDictionary)
                                }
                            }
                        }
                        
                        self.arrFriendsData = self.arrFriends
                        
                        if self.arrFriendsData.count == 0 {
                            
                            let dict = NSMutableDictionary()
                            dict["userId"] = "dummyID"
                            dict["selected"] = false
                            dict["userName"] = "dummyUserName"
                            dict["contactName"] = "dummyContactName"
                            dict["userNumber"] = "03312275651"
                            dict["photo"] = ""
                            self.arrFriendsData.append(dict)
                        }
                        self.decideContactsToInvite()
                        // self._tableView.reloadData()
                        
                    }
                    else {
                        self.alert(jsonResponse["msg"] as! String)
                    }
                }
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
                self.refreshControl.endRefreshing()
        }
    }
    
    func decideContactsToInvite(){
        let arr: NSArray = self.arrFriendsData as NSArray
        for friend in  self.arrContactsData{
            if friend is NSDictionary{
                if var phoneNumber : String = friend["contactPhone"] as? String {
                    phoneNumber = self.removeCountryCode(phoneNumber)
                    let predicate: NSPredicate = NSPredicate(format: "userNumber contains[cd] %@", phoneNumber)
                    let arrResult = arr.filtered(using: predicate) as NSArray
                    
                    print(arrResult)
                    
                    if arrResult.count > 0 {
                        
                    }else{
                        
                        let contactData : NSDictionary = ["contactName" : friend["contactName"],"contactPhone" : friend["contactPhone"] , "selected":false]
                        
                        self.arrInviteFriendsData.append(contactData)
                        
                        
                    }
                }
            }
        }
        print(self.arrInviteFriendsData)
        
        self.arrFriendBackup = self.arrFriendsData as NSArray
        self._tableView.reloadData()
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
    @IBAction func lockBtnPressed(_ sender: AnyObject, forEvent event: UIEvent) {
        
        
        
        if !self.isReachable() {
            return
        }
        print(sender.tag)
        
        let defaults = UserDefaults.standard;
        let touch: UITouch = (event.allTouches?.first)! as UITouch
        let point = touch.location(in: _tableView) as CGPoint
        
        let indexPath: IndexPath = _tableView.indexPathForRow(at: point) as IndexPath!
        //let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        let uId = self.arrFriendsData[indexPath.row]["userId"]
        var blockedBy = "0" ;
        if let uData = defaults.value(forKey: "userData") as? NSDictionary{
            blockedBy = uData["user_id"] as! String
            return;
            
        }
        //Current UserID
        //self.activityIndicator.startAnimating()
        self.showActivityIndicator()
        let params : Parameters = ["uid": uId,"blockedBy":blockedBy]
        Alamofire.request(baseUrl + "block", parameters: params)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let jsonResponse = response.result.value  as? NSDictionary{
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        self.arrFriendsData.remove(at: indexPath.row)
                        self.arrFriends.remove(at: indexPath.row)
                        self._tableView.reloadData()
                        // self._tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Middle)
                        self._tableView.reloadData()
                    }
                    else {
                        self.alert(jsonResponse["msg"] as! String)
                    }
                }
                self.hideActivityIndicator()
                //self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func shareLocationBtnPressed(_ sender: UIButton, forEvent event: UIEvent) {
        let touch: UITouch = (event.allTouches?.first)! as UITouch
        let point = touch.location(in: _tableView) as CGPoint
        let indexPath: IndexPath = _tableView.indexPathForRow(at: point) as IndexPath!
        selectedUserId = self.arrFriendsData[indexPath.row]["userId"] as! String
        
        //Start Updating Location
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    func sendpush(){
        
        let userId = selectedUserId
        let defaults    = UserDefaults.standard;
        let senderName  = defaults.value(forKeyPath: "userData.username") as! String
        let senderId    = defaults.value(forKeyPath: "userData.user_id") as! String
        
        self.view.isUserInteractionEnabled = false
        self.showActivityIndicator()
        let params : Parameters = ["senderName": senderName, "userId" : userId!, "link": "","userCaption" : self.txtViewMsg.text!,"senderId" : senderId,"title" : "Pushnote" ]
        Alamofire.request(baseUrl + "sendPush", parameters:params)
            .responseJSON { response in
                print(response.response)
                self.txtViewMsg.text = ""
                // self.userCaptionField.text = ""
                self.locationBtn.isSelected = false
                
                if let jsonResponse = response.result.value  as? NSDictionary{
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        self.alert("Push Sent!")
                    }
                    else {
                        self.alert(jsonResponse["message"] as! String)
                        
                    }
                }
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
                //self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func pushBtnPressed(_ sender: AnyObject, forEvent event: UIEvent) {
        let touch: UITouch = (event.allTouches?.first)! as UITouch
        let point = touch.location(in: _tableView) as CGPoint
        let indexPath: IndexPath = _tableView.indexPathForRow(at: point) as IndexPath!
        selectedUserId = self.arrFriendsData[indexPath.row]["userId"] as! String
        animateView();
        return
        
    }
    /*
     @IBAction func selectBtnPressed(_ sender: AnyObject, forEvent event: UIEvent) {
     let touch: UITouch = (event.allTouches?.first)! as UITouch
     let point: CGPoint = touch.location(in: self._tableView)  as CGPoint
     let indexPath: IndexPath = self._tableView.indexPathForRow(at: point) as IndexPath!
     
     let btn: UIButton = sender as! UIButton
     
     btn.isSelected = !btn.isSelected
     self.arrInviteFriendsData[indexPath.row]["selected"] = btn.isSelected
     selectedCount += btn.isSelected ? 1 : -1
     self.btnDone.isEnabled = (selectedCount != 0)
     }
     @IBAction func selectAllBtnPressed(_ sender: AnyObject) {
     
     if (btnInvite.isSelected) {
     self.isSelectAllInvited = !self.isSelectAllInvited
     for cData   :  NSMutableDictionary in self.arrInviteFriendsData {
     cData["selected"] = self.isSelectAllInvited
     }
     selectedCount = self.isSelectAllInvited ? self.arrContactsData.count : 0
     self.btnDone.isEnabled = (selectedCount != 0)
     }
     else {
     self.isSelectAllFriends = !isSelectAllFriends
     for fData:NSMutableDictionary in self.arrFriendsData {
     fData["selected"] = self.isSelectAllFriends
     }
     }
     
     self._tableView.reloadData()
     
     
     }
     */
    
    //MARK: CLLocation Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        let newLocation = locations.last! as CLLocation
        print("current position: \(newLocation.coordinate.longitude) , \(newLocation.coordinate.latitude)")
        
        if(self.activityIndicator.isAnimating == false){
            
            //Share Service
            let defaults = UserDefaults.standard;
            let userId = defaults.value(forKeyPath: "userData.user_id") as! String
            //let lat_long = String(format: "%@,%@",String(stringInterpolationSegment: newLocation.coordinate.latitude),String(stringInterpolationSegment: newLocation.coordinate.longitude))
            
            let lat_long :  String =
                String(describing:  newLocation.coordinate.latitude)
                    + ","
                    + String(describing: newLocation.coordinate.longitude)
            
            
            
            latLong = lat_long
            print("UserID:\(userId)")
            print("SelectedUserID:\(selectedUserId)")
            print("Lat long:\(lat_long)")
            
            //  callLocationService(userId, selectedUserId: selectedUserId!, latlong: lat_long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let errorAlert = UIAlertView(title: "Error", message: "Failed to Get Your Location", delegate: nil, cancelButtonTitle: "Ok")
        errorAlert.show()
    }
    
    func callLocationService(_ userId:String,selectedUserId:String,latlong:String) {
        self.showActivityIndicator(); let params : Parameters = ["from_userId": userId, "to_userId" : selectedUserId, "lat_long": latlong,"userCaption" : self.txtViewMsg.text!]
        Alamofire.request(baseUrl + "sharelocation", parameters:params)
            .responseJSON { response in
                self.txtViewMsg.text = ""
                //self.userCaptionField.text = ""
                self.locationBtn.isSelected = false
                
                if let jsonResponse = response.result.value as? NSDictionary {
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        print("Success:\(jsonResponse)")
                        self.alert(jsonResponse["msg"] as! String)
                        
                    }
                    else {
                        self.alert(jsonResponse["msg"] as! String)
                    }
                }
                self.view.isUserInteractionEnabled = true
                self.hideActivityIndicator()
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func inviteFriend(_ sender: AnyObject) {
        let index = sender.tag
        print(index)
        if (MFMessageComposeViewController.canSendText()) {
            
            let compose: MFMessageComposeViewController = MFMessageComposeViewController()
            compose.messageComposeDelegate = self
            
            let index = sender.tag
            print(index)
            
            let contactUser = self.arrContactsData[index!] as! NSDictionary
            if contactUser["contactPhone"] as? String != "" {
                compose.recipients = [contactUser["contactPhone"] as! String]
                
                let userName = UserDefaults.standard.value(forKeyPath: "userData.username") as! String
                //self.textToShare = "Hey! Checkout this cool app called 'Pushnote'. Enjoy!!"
                let textToShare = "I am inviting you to Pushnote (https://itunes.apple.com/gb/app/push-note/id962393538?mt=8) Push me back! @\(userName)"
                compose.body = textToShare
                self.present(compose, animated: true, completion: nil)
            }
            
        }
    }
    func animateView() {
        
        
        //self.viewPopup.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.scrollView.isHidden = false
        self.viewPopup.transform = CGAffineTransform(a: self.viewPopup.transform.a/2.0, b: 0, c: 0, d: 1, tx: self.viewPopup.frame.size.width, ty: 0);
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            
            self.viewPopup.transform = CGAffineTransform.identity;
            
        }, completion: { (finished: Bool) -> Void in
            
            // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
        
        self.txtViewMsg.becomeFirstResponder()
    }
    
    func closeAnimate (){
        
        self.viewPopup.transform = CGAffineTransform.identity;
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            
            // self.viewPopup.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.viewPopup.transform = CGAffineTransform(a: self.viewPopup.transform.a/2.0, b: 0, c: 0, d: 1, tx: self.viewPopup.frame.size.width, ty: 0);
            
        }, completion: { (finished: Bool) -> Void in
            self.scrollView.isHidden = true
            // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
        self.txtViewMsg.resignFirstResponder()
        
    }
    
    @IBAction func actionClose(_ sender: AnyObject) {
        self.closeAnimate()
    }
    
    @IBAction func actionLocation(_ sender: UIButton) {
        if(sender.isSelected == false){
            sender.isSelected = true
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            
        }else{
            sender.isSelected = false
            
        }
    }
    
    
    @IBAction func actionSend(_ sender: AnyObject) {
        
        self.closeAnimate()
        if(locationBtn.isSelected == false){
            self.txtViewMsg.resignFirstResponder()
            self.sendpush()
        }else{
            let defaults = UserDefaults.standard;
            let userId = defaults.value(forKeyPath: "userData.user_id") as! String
            callLocationService(userId, selectedUserId: selectedUserId!, latlong: latLong)
        }
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView){
        
        textView.text = ""
        
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
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.arrFriendsData = arrFriendBackup.copy() as! NSArray as! Array<NSDictionary>
        self._tableView.reloadData()
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
                let found = (friendData["userName"] as? String)?.range(of: searchText, options: options)
                if ((found) != nil) {
                    print(friendData["userName"])
                    arrTempSearch.add(friendData)
                }
            }
            
            self.arrFriendsData = arrTempSearch.copy() as! NSArray as! Array<NSDictionary>
            //print(arrTempSearch)
        }
        else{
            self.arrFriendsData = arrFriendBackup.copy() as! NSArray as! Array<NSDictionary>
        }
        
        //let range  : NSRange = NSMakeRange(0, 1)
        //  let selectedIndices =  NSMutableIndexSet(integersIn: range.toRange() ?? 0..<0)
        self._tableView.reloadData()
        
        
    }
    func textViewdidBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView.text == "Say Something" {
            textView.text = nil
            textView.textColor = UIColor.black
            
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Say Something"
            
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 80
        let currentString: NSString = textView.text as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: text) as NSString
        print(newString.length)
        return newString.length <= maxLength
    }
    
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        self._tableView.reloadData()
        
    }
    
}

