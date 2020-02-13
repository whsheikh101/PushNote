//
//  WeatherDetailViewController.swift
//  PushNote
//
//  Created by Waqas Haider Sheikh on 20/08/2015.
//  Copyright (c) 2015 com. All rights reserved.
//

import UIKit
import Alamofire
import AddressBookUI
import Contacts
class WeatherDetailViewController: BaseViewController,
UIActionSheetDelegate,
UITextFieldDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,UISearchBarDelegate {
    var lat_long:String?
    var lon :String?
    var lat :String?
    var location:String?
    @IBOutlet weak var userCaption: TextField!
    
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
    var selectedFriendsNew : NSMutableArray = []
    var tempTitle:String?
    var addressBook: ABAddressBook?
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var _collectionView: UICollectionView!
    
    @IBOutlet weak var pushView: UIView!
    
    @IBOutlet weak var labWind: UILabel!
    @IBOutlet weak var labHumidity: UILabel!
    @IBOutlet weak var labVisibility: UILabel!
    @IBOutlet weak var labPrecipitation: UILabel!
    @IBOutlet weak var labPressure: UILabel!
    @IBOutlet weak var labDirection: UILabel!
    @IBOutlet weak var labSpeed: UILabel!
    
    @IBOutlet weak var weatherTemprature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherRealFeel: UILabel!
    @IBOutlet weak var weatherHumidity: UILabel!
    @IBOutlet weak var weatherVisibility: UILabel!
    @IBOutlet weak var weatherPrecipitation: UILabel!
    @IBOutlet weak var weatherPressure: UILabel!
    @IBOutlet weak var weatherWindDirection: UILabel!
    @IBOutlet weak var weatherWindSpeed: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var tempInCent:String = ""
    var tempInFaren:String = ""
    var tempRealFeelInCent = ""
    var tempRealFeelInFaren = ""
    var tempCity:String = ""
    var titleWeb: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackBtn()
        // Do any additional setup after loading the view.
        self.title = location
        self.event = "View"
        //Call Webservice to Get Weather Information
        if !self.isReachable() {
            return
        }
        self.getContacts()
        self.showActivityIndicator()
        
       // self.activityIndicator.startAnimating()
        var lat2 = self.lat_long?.split(separator: ",", maxSplits: 2, omittingEmptySubsequences: true) as! NSArray
        
        
        
        if let lat1 = lat2[0] as? String{
            print(lat1)
            print("HERE")
            self.lat = lat1
            
        }
        if let lon1 = lat2[1] as? String{
            self.lon = lon1
        }
        let url:String = "https://api.openweathermap.org/data/2.5/weather?lat="+self.lat!+"&lon="+self.lon!+"&APPID=201914ed8dcad5d46714cef698e0dd2b";
        print(url);
       
        
        Alamofire.request(url)
            .responseJSON { response in
            
                if let jsonResponse = response.result.value as? NSDictionary {
                    

                   
                    
                    self.labWind.isHidden               = false
                    self.labHumidity.isHidden           = false
                    self.labVisibility.isHidden         = false
                    self.labPrecipitation.isHidden      = false
                    self.labPressure.isHidden           = false
                    self.labDirection.isHidden          = false
                    self.labSpeed.isHidden              = false
                    let data: NSDictionary = jsonResponse
                   // if let data: NSDictionary = jsonResponse["current_observation"] as? NSDictionary { print(data);
                    //let current_condition_arr:NSArray = data["current_condition"] as! NSArray
                   // let current_condition:NSDictionary = current_condition_arr[0] as! NSDictionary
                    //let weatherDesc_arr:NSArray = current_condition["weatherDesc"] as! NSArray
                   // let weatherDesc:NSDictionary = weatherDesc_arr[0] as! NSDictionary
                   // let weatherIconUrl_arr:NSArray = current_condition["weatherIconUrl"] as! NSArray
                   // let weatherIconUrl:NSDictionary = weatherIconUrl_arr[0] as! NSDictionary
                    
                   
                        if let dataMain = data["main"] as? NSDictionary{
                            if let t =  dataMain["temp"] as? String {
                                let tempInString            = t
                                self.tempInFaren            = t
                                self.weatherTemprature.text = tempInString + "ºF"
                            }
                            if let pressureInString = dataMain["pressure"] as? NSNumber{
                                self.weatherPressure.text = pressureInString.stringValue+" mb"
                            }
                            
                            if let humidityInString = dataMain["humidity"] as? NSNumber{
                                self.weatherHumidity.text = humidityInString.stringValue
                            }
                                               
                        }
                    
                    /*
                    if let c =  data["temp_c"] as? NSNumber {
                        self.tempInCent = c.stringValue
                    
                    }
 */
                   
                    if let weatherMain = data["weather"] as? NSArray{
                        
                        print(weatherMain);
                        
                        
                        
                    if let weatherMain2 = weatherMain[0] as? NSDictionary{
                        self.weatherDescription.text = weatherMain2["main"] as? String
                        
                    let iconUrlString = "https://openweathermap.org/img/wn/"+(weatherMain2["icon"] as! String)+"@2x.png"
                    
                        print(iconUrlString)
                    let iconURL:NSURL = NSURL(string: iconUrlString)!
                                           
                    self.weatherIcon.sd_setImage(with: iconURL as URL!)
                    self.weatherIcon.layer.cornerRadius = self.weatherIcon.frame.width/2
                    self.weatherIcon.clipsToBounds = true
                        }
                        
                    }
                    /*
                    let realFeeltempInString:String = data["feelslike_string"] as! String
                    self.tempRealFeelInCent = (data["feelslike_c"] as? String)!
                    self.tempRealFeelInFaren = (data["feelslike_f"] as? String)!
                    self.weatherRealFeel.text = "RealFeel "+realFeeltempInString+"ºF"
                    
                    
                    
                    let visibilityInString:String = data["visibility_km"] as! String
                    self.weatherVisibility.text = visibilityInString+" km"
                    
                    let precipMMInString:String = data["precip_today_in"] as! String
                    self.weatherPrecipitation.text = precipMMInString+" in"
                    */
                    
                    if let windMain = data["wind"] as? NSDictionary{
                   
                        if let wD = windMain["deg"] as? NSNumber{
                        
                            let winddirDegreeInString:String = wD.stringValue
                            self.weatherWindDirection.text = winddirDegreeInString+"º"
                            
                        }
                        if let windSp = windMain["speed"] as? NSNumber{
                            
                            let windspeedKmphInString:String = windSp.stringValue
                            self.weatherWindSpeed.text = windspeedKmphInString+" km/h"
                        }
                    }
                    
                    }
                    self.titleWeb = "Current Weather in \(self.location!) is \(self.tempInCent) ºC / \(self.tempInFaren) ºF"
                    }
                //self.activityIndicator.stopAnimating()
                self.hideActivityIndicator()
       // }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnChangeUnitAction(_ sender: AnyObject) {
        let shareSheet:UIActionSheet = UIActionSheet(title: "PushNote", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "ºC to ºF","ºF to ºC") as UIActionSheet
        shareSheet.show(in: self.view)
    }
    @IBAction func btnBackAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    func animateView(){
        self.scrollView.isHidden = false
        print(self.pushView.frame.size.height)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            let bounds = UIScreen.main.bounds
            let yPosition = bounds.size.height - (self.pushView.frame.size.height + 100)
            print(yPosition)
            self.pushView.frame = CGRect(x: 0.0, y: yPosition, width: self.pushView.frame.size.width, height: (self.pushView.frame.size.height))
            
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
    }
    @IBAction func btnPushAction(_ sender: AnyObject) {
        animateView()
        return;
        let pushView:PushView = PushView.instanceFromNib()
        pushView.animateView()
        self.view.addSubview(pushView)
        /*
        let shareFriendsVC:ShareFriendsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShareFriendsViewController") as! ShareFriendsViewController
        shareFriendsVC.isFromWeather = true
        shareFriendsVC.titleWeb = "Current Weather in \(location!) is \(tempInCent) ºC / \(tempInFaren) ºF"
        self.navigationController?.pushViewController(shareFriendsVC, animated: true)
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
    var newBtn : UIButton = UIButton();
    @IBAction func btnShareAction(_ sender: AnyObject) {
        var shareContent:String = "Current Weather in \(location!) is \(tempInCent) ºC / \(tempInFaren) ºF"
       self.newBtn = sender as! UIButton
        
        shareContent = "\(shareContent). Subscribe here https://itunes.apple.com/gb/app/push-note/id962393538?mt=8"
        "Current Weather in \(location!) is \(tempInCent) ºC / \(tempInFaren) ºF"
        
        
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
                   // self.saveAnalytics(self.link!, objectID: self.objectId!, merchantID: self.subAdminId!)
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

    //MARK: UIActionSheet Delegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            print("Cancel")
        case 1:
            print("C to F")
            self.weatherTemprature.text = tempInFaren+"ºF"
            self.weatherRealFeel.text = "RealFeel "+tempRealFeelInFaren+"ºF"
        case 2:
            print("F to C")
            self.weatherTemprature.text = tempInCent+"ºC"
            self.weatherRealFeel.text = "RealFeel "+tempRealFeelInCent+"ºC"
        default:
            print("Problem in selection")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.tabBarController!.tabBar.isHidden = true
        print("HERe");
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.tabBarController!.tabBar.isHidden = false
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
        }
        */
        cell.friendName.text = fName
        
        cell.friendSelected.tag = indexPath.row
        let imagePathUrl = URL(string: (friendData["photo"] as? String)! )
        let defaultImg = UIImage(named: "iconImg")
        cell.friendPic.sd_setImage(with: imagePathUrl, placeholderImage: defaultImg)
        //cell.friendSelected.se
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
                 // self.activityIndicator.stopAnimating()
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
              
              if self.titleWeb == nil{
                  self.tempTitle = ""
              }
              else{
                  self.tempTitle = self.titleWeb
              }
              
              
             let defaults = UserDefaults.standard;
             let senderName = defaults.value(forKeyPath: "userData.username") as! String
             let userID = defaults.value(forKeyPath: "userData.user_id") as! String
              
             self.view.isUserInteractionEnabled = false
              self.showActivityIndicator();
              
               let params : Parameters = [
                "from_userId" :userID ,
                "to_userIds": userIds,
                "weather_text":self.tempTitle!,
                "userCaption":userCaption.text!];
             
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool
    {
        let maxLength = 80
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    /*
    func saveAnalytics(lnk:String, objectID :String, merchantID : String ){
        
        let defaults = NSUserDefaults.standardUserDefaults();
        let userId = defaults.valueForKeyPath("userData.user_id") as! String
        
        if !self.isReachable() {
            return
        }
        let strId = String(id);
        let strNotificationId = String(notifictionId)
        print(["userId": userId,"link":lnk,"objectId" : objectID,"merchantId": merchantID,"id":strId,"deviceType":"Ios","contentType":self.notificationType,"notificationId":strNotificationId,"event":self.event,"shareType" :self.shareType]);
        
        
        
        Alamofire.request(.POST, baseUrl + "saveAnalytics", parameters:["userId": userId,"link":lnk,"objectId" : objectID,"merchantId": merchantID,"id":strId,"deviceType":"Ios","contentType":self.notificationType,"notificationId":strNotificationId,"event":self.event,"shareType" :self.shareType])
            .responseJSON { response in
                
                if let jsonResponse = response.result.value {
                    print(jsonResponse)
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        if(self.id == 0){
                            self.id = jsonResponse["contentId"] as! Int
                            
                        }
                    }
                    else {
                        
                    }
                }
        }
        
        
    }
*/
    
}
