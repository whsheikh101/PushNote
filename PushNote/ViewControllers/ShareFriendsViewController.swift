//
//  ShareFriendsViewController.swift
//  PushNote
//
//  Created by Rizwan on 12/23/14.
//  Copyright (c) 2014 com. All rights reserved.
//

import UIKit
import Alamofire
import AddressBookUI

class ShareFriendsViewController: BaseViewController {
    
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var _tableView: UITableView!
    
    var btnDone: UIButton!
    
    var isFromWeather:Bool = false
    var arrFriends: Array<FriendData> = []
    var arrFriendsData: Array<FriendData> = []
    
    var arrContacts: Array<NSDictionary> = []
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

    var link: String!
    var titleWeb: String?
    var isSelectedAll: Bool = false
    var userMessage: NSString!
    var tempTitle:String?
    var phoneNumbers : NSMutableArray = []
    var subAdminId          : String?   = "" ;
    var objectId            : String?   = "";
    var notificationType    : String?   = "Feed"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnDone = UIButton(type: UIButton.ButtonType.custom)
        let imgLeft: UIImage! = UIImage(named: "done")
        self.btnDone.setImage(imgLeft, for: UIControl.State())
        self.btnDone.frame = CGRect(x: 0, y: 0, width: imgLeft.size.width, height: imgLeft.size.height)
        self.btnDone.addTarget(self, action: #selector(ShareFriendsViewController.doneBtnPressed(_:)), for: UIControl.Event.touchUpInside)
        
        let barLeftBtn: UIBarButtonItem = UIBarButtonItem(customView: self.btnDone)
        self.navigationItem.rightBarButtonItem = barLeftBtn
        
        textFieldSearch.addTarget(self, action: #selector(ShareFriendsViewController.searchTableList), for: UIControl.Event.editingChanged)
        
        //getFriends()
        
       self.showActivityIndicator()
        
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            self.getContacts()
        })

    }
    
    func extractABAddressBookRef(_ abRef: Unmanaged<ABAddressBook>!) -> ABAddressBook? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    func getContacts() {
        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.notDetermined) {
            //println("requesting access...")
            var errorRef: Unmanaged<CFError>? = nil
            addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    self.getContactNames()
                    self.getFriends()
                }
                else {
                    //println("error")
                    DispatchQueue.main.async(execute: {
                        self.showAlert()
                    })
                }
            })
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.restricted) {
            //println("access denied")
            DispatchQueue.main.async(execute: {
                self.showAlert()
            })
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.authorized) {
            //println("access granted")
            self.getContactNames()
            self.getFriends()
        }
    }
    
    func showAlert() {
        
        let alert :UIAlertView = UIAlertView(title: "Access denied", message: "Please goto the Settings > PushNote > Enable Contacts", delegate: nil, cancelButtonTitle: "OK")
        alert.show();
        
        self.arrContacts = []
        self.arrFriends = []
         self.hideActivityIndicator()
    }
    
    func getContactNames() {
        var errorRef: Unmanaged<CFError>?
        addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
        let contactList: NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
        
        var _: ABMultiValue
        
        var arr: Array<NSDictionary> = []
        
        for record  in contactList {
            let contactPerson: ABRecord = record as ABRecord
            
            //var compositeName: Unmanaged<CFString> = ABRecordCopyCompositeName(contactPerson)
            if let compositeName = ABRecordCopyCompositeName(contactPerson) {
                
                let contactName: String = compositeName.takeRetainedValue() as String
                let unmanagedPhones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty)
                let phoneObj: ABMultiValue = Unmanaged.fromOpaque(unmanagedPhones!.toOpaque()).takeUnretainedValue() as NSObject as ABMultiValue
                var dic: NSDictionary
                if ABMultiValueGetCount(phoneObj) != 0 {
                    
                    let index = 0 as CFIndex
                    let unmanagedPhone = ABMultiValueCopyValueAtIndex(phoneObj, index)
                    let phoneNumber:String = Unmanaged.fromOpaque(unmanagedPhone!.toOpaque()).takeUnretainedValue() as NSObject as! String
                    
                    let number = phoneNumber.replacingOccurrences(of: "[\\(\\)\\ \\-]", with: "", options: NSString.CompareOptions.regularExpression, range: nil)
                    let number1 = number.condenseWhitespace()
                     self.phoneNumbers.add(number1)
                    dic = NSDictionary(objects: [contactName,number1], forKeys: ["contactName" as NSCopying,"contactPhone" as NSCopying])
                }
                else {
                    dic = NSDictionary(object: contactName, forKey: "contactName" as NSCopying)
                }
                arr.append(dic)
            }
        }
        self.arrContacts = arr.sorted(by: forwards)
    }
    
    func forwards(_ d1: NSDictionary, d2: NSDictionary) -> Bool {
        return (d1["contactName"] as! String) < (d2["contactName"] as! String)
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
        self.showActivityIndicator()
        
        var pNumbers : NSString = ""
        do {
            let arrJson = try JSONSerialization.data(withJSONObject: self.phoneNumbers, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: arrJson, encoding: String.Encoding.utf8.rawValue)
            pNumbers = string! as NSString
        }catch let error as NSError{
            print(error.description)
        }
          var params  : Parameters = [:];
        
        params["userID"] = userId; params["phoneNumbers"] = pNumbers;
        Alamofire.request(baseUrl + "viewFriends", method: HTTPMethod.post, parameters: params)
            .responseJSON { response in
                
                if let jsonResponse = response.result.value as? NSDictionary{
                    print(jsonResponse)
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        let arrContact = jsonResponse["data"] as! Array<NSDictionary>
                        for dic: NSDictionary in arrContact {
                            if var phoneNumber: String = dic["phoneNumber"] as? String {
                                
                                //Ayaz: Remove from number
                                phoneNumber = self.removeCountryCode(phoneNumber)
                                
                                let arr: NSArray = self.arrContacts as NSArray
                                let predicate: NSPredicate = NSPredicate(format: "contactPhone contains[cd] %@", phoneNumber)
                                var arrResult = arr.filtered(using: predicate) as! Array<NSDictionary>
                                
                                if !arrResult.isEmpty {
                                    let friendData: FriendData = FriendData()
                                    friendData.userId = dic["user_id"] as! String
                                    friendData.userName = dic["username"] as! String
                                    friendData.contactName = arrResult[0]["contactName"] as! String
                                    friendData.userNumber = arrResult[0]["contactPhone"] as! String
                                    self.arrFriends.append(friendData)
                                }
                            }
                        }
                        self.arrFriendsData = self.arrFriends
                        self._tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrFriendsData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) ;
        
        //var imageViewBg: UIImageView = cell.contentView.viewWithTag(1000) as UIImageView
        
        let lblName: UILabel = cell.contentView.viewWithTag(1001) as! UILabel
        let strUsername = self.arrFriendsData[indexPath.row].userName//self.arrFriends[indexPath.row]["username"] as String
        lblName.text = strUsername
        
        let btnCheckbox: UIButton = cell.contentView.viewWithTag(1002) as! UIButton
        btnCheckbox.isSelected = self.arrFriendsData[indexPath.row].selected
        
        return cell;
    }
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        let backgroundView : UIView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.clear
        cell.backgroundView = backgroundView
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath) as UITableViewCell!
        
        let btnCheckbox: UIButton = cell.contentView.viewWithTag(1002) as! UIButton
        btnCheckbox.isSelected = !btnCheckbox.isSelected
        self.arrFriendsData[indexPath.row].selected = btnCheckbox.isSelected

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func searchTableList() {
        
        self.arrFriendsData.removeAll(keepingCapacity: false)
        if textFieldSearch.text!.isEmpty {
            self.arrFriendsData = self.arrFriends
        }
        else {
            let arr: NSArray = self.arrFriends as NSArray
            let predicate: NSPredicate = NSPredicate(format: "userName contains[cd] %@", textFieldSearch.text!)
            self.arrFriendsData = arr.filtered(using: predicate) as! Array<FriendData>
        }
        
        self.btnDone.isEnabled = !self.arrFriendsData.isEmpty
        
        self._tableView.reloadData()
    }
    
    @objc func doneBtnPressed(_ sender: AnyObject) {
        
        var isAnyPerson: Bool = false
        var selectedUserCount: Int = 0;
        
        var userIds: String = ""
        
        for fData:FriendData in self.arrFriendsData {
            if fData.selected {
                selectedUserCount += 1
                if userIds.isEmpty {
                    userIds = fData.userId
                }
                else {
                    userIds += ",\(fData.userId)"
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
            let alert :UIAlertView = UIAlertView(title: "", message: "Please select atleast one Friend", delegate: nil, cancelButtonTitle: "OK")
            alert.show();
        }
        else {
            if !self.isReachable() {
                return
            }
            
            let defaults = UserDefaults.standard;
            let senderName = defaults.value(forKeyPath: "userData.username") as! String
            let userID = defaults.value(forKeyPath: "userData.user_id") as! String
            
            self.view.isUserInteractionEnabled = false
            if self.titleWeb == nil{
                self.tempTitle = ""
            }
            else{
                self.tempTitle = self.titleWeb
            }
            
            if(isFromWeather){
               self.showActivityIndicator()
                let params : Parameters = ["from_userId" :userID , "to_userIds": userIds, "weather_text":self.tempTitle!];
                Alamofire.request(baseUrl + "shareweather", parameters: params)
                    .responseJSON { response in
                        
                        if let jsonResponse = response.result.value  as? NSDictionary{
                            if (jsonResponse["status"] as! String == "SUCCESS") {
                                self.view.isUserInteractionEnabled = true
                                 self.hideActivityIndicator()
                                
                                let alert :UIAlertView = UIAlertView(title: "", message: self.userMessage as String, delegate: nil, cancelButtonTitle: "OK")
                                alert.show();
                                self.navigationController?.popViewController(animated: true);
                            }
                            else {
                                self.view.isUserInteractionEnabled = true
                                 self.hideActivityIndicator()
                                
                                let alert :UIAlertView = UIAlertView(title: "", message: jsonResponse["msg"] as? String, delegate: nil, cancelButtonTitle: "OK")
                                alert.show();
                            }
                        }
                        else{
                            self.view.isUserInteractionEnabled = true
                             self.hideActivityIndicator()
                        }
                }
            }
            else{
                
               self.showActivityIndicator()
                let params : Parameters = ["senderName": senderName, "userId" : userIds, "link": self.link, "title":self.tempTitle!,"contentType" : self.notificationType! , "objectId" : self.objectId! , "merchantId" : self.subAdminId!];
                Alamofire.request(baseUrl + "sendPush", parameters:params)
                    .responseJSON { response in
                        
                        print(response);
                        if let jsonResponse = response.result.value  as? NSDictionary{
                            if (jsonResponse["status"] as! String == "SUCCESS") {
                                self.view.isUserInteractionEnabled = true
                                 self.hideActivityIndicator()
                               
                                let alert :UIAlertView = UIAlertView(title: "", message: self.userMessage as String, delegate: nil, cancelButtonTitle: "OK")
                                alert.show();
                                self.navigationController?.popViewController(animated: true);
                            }
                            else {
                                self.view.isUserInteractionEnabled = true
                                 self.hideActivityIndicator()
                                
                                let alert :UIAlertView = UIAlertView(title: "", message: jsonResponse["message"] as? String, delegate: nil, cancelButtonTitle: "OK")
                                alert.show();
                            }
                        }
                        else{
                            self.view.isUserInteractionEnabled = true
                             self.hideActivityIndicator()
                        }
                }
            }
        }
    }
    
    @IBAction func selectAllBtnPressed(_ sender: AnyObject) {
        
        isSelectedAll = !isSelectedAll
        for fData:FriendData in self.arrFriendsData {
            fData.selected = isSelectedAll
        }
        self._tableView.reloadData()
    }
    
    @IBAction func checkBoxbtnPressed(_ sender: AnyObject, forEvent event: UIEvent) {
        
        //var touch: UITouch = event.allTouches()?.anyObject() as UITouch //Code Replace
        let touch: UITouch = (event.allTouches?.first)!
        let point: CGPoint = touch.location(in: self._tableView)
        let indexPath: IndexPath = self._tableView.indexPathForRow(at: point) as IndexPath!
        
        let btn: UIButton = sender as! UIButton
        
        btn.isSelected = !btn.isSelected
        self.arrFriendsData[indexPath.row].selected = btn.isSelected
        
    }
}
