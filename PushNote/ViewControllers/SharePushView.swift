//
//  SharePushView.swift
//  PushNote
//
//  Created by Khurram Iqbal on 09/03/2020.
//  Copyright © 2020 Ihsan Bhatti. All rights reserved.
//

import UIKit
import Alamofire
import AddressBook
import Contacts

class SharePushView: UIView,UITextFieldDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UISearchBarDelegate {
    
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
    var arrFriends:             Array<NSDictionary> = []
    var arrFriendsData:         Array<NSDictionary>   = []
    var arrContacts:            Array<NSDictionary>  = []
    var arrContactsData:        Array<NSDictionary>  = []
    var arrInviteFriendsData:   Array<NSDictionary>  = []
    var selectedFriendsNew      : NSMutableArray = []
    var link                :   String?         = ""
    var titleWeb            :   String?         = "Home"
    var isFromNotification  :   Bool            = false
    var subAdminId          :   String?         = ""
    var id                  :   Int             = 0 ;
    var objectId            :   String?         = "";
    var notificationType    :   String          = "Feed"
    
    
    var addressBook: ABAddressBook?
    var viewController:BaseViewController!
    
    @IBOutlet weak var userCaption: TextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var _collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchB.autocorrectionType = UITextAutocorrectionType.no
        //Notification
        
        
        self.getContacts()
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
                    let number2 = AppUtility.sharedInstance.removeCountryCode(number1)
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
    func extractABAddressBookRef(_ abRef: Unmanaged<ABAddressBook>!) -> ABAddressBook? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
   
    func forwards(_ c1: ContactData, c2: ContactData) -> Bool {
        return c1.contactName < c2.contactName
    }
    func getFriends() {
        
        if !AppUtility.sharedInstance.isReachable() {
            return
        }
        
        
        
        let defaults    = UserDefaults.standard;
        let userId      = defaults.value(forKeyPath: "userData.user_id") as! String
        self.isUserInteractionEnabled = false
        
        
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
                                let pNumber = AppUtility.sharedInstance.removeCountryCode(phoneNumber)
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
                self.isUserInteractionEnabled = true
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
            self.viewController.alert("Please select atleast one Friend")
        }
            
        else {
            if !AppUtility.sharedInstance.isReachable() {
                return
            }
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
                let controller = self.viewController as! IndexViewController
                let bounds = UIScreen.main.bounds
                let yPosition = bounds.size.height + controller.pushView.frame.size.height
                controller.pushView.frame = CGRect(x: 0, y: yPosition, width: controller.pushView.frame.size.width, height: controller.pushView.frame.size.height)
                
            }, completion: { (finished: Bool) -> Void in
                let controller = self.viewController as! IndexViewController
                controller.scrollView.isHidden = true
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
            })
            
            
            
            
            let defaults = UserDefaults.standard;
            let senderName = defaults.value(forKeyPath: "userData.username") as! String
            let userID = defaults.value(forKeyPath: "userData.user_id") as! String
            
            self.isUserInteractionEnabled = false
            self.viewController.showActivityIndicator();
            
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
                    self.isUserInteractionEnabled = true
                    self.viewController.hideActivityIndicator()
                    
                    
                    self.userCaption.text! = ""
                    self.isSelectedAll = true
                    self.selectAllBtn.isSelected = true
                    self.selectAllBtnPressed(self.selectAllBtn)
                    
                    if let jsonResponse = response.result.value  as? NSDictionary{
                        
                        if (jsonResponse["status"] as! String == "SUCCESS") {
                            self.isUserInteractionEnabled = true
                            self.viewController.hideActivityIndicator()
                            self.viewController.alert( self.userMessage as String)
                        }
                        else {
                            self.isUserInteractionEnabled = true
                            self.viewController.hideActivityIndicator()
                            //self.activityIndicator.stopAnimating()
                            self.viewController.alert(jsonResponse["message"] as! String)
                            
                        }
                    }
                    else{
                        self.isUserInteractionEnabled = true
                        self.viewController.hideActivityIndicator()
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
        let defaultImg = UIImage(named: "indexUserIcon")
        cell.friendPic.sd_setImage(with: imagePathUrl, placeholderImage: defaultImg)
        
        if(friendData["selected"] as? Bool == true){
            cell.friendSelected.isSelected = true
        }else{
            cell.friendSelected.isSelected = false
        }
        
        return cell
    }
    func loadDummyData(){
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
}
