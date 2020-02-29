//
//  HomeViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 28/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import AVFoundation

class HomeViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var refreshControl:UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var collectionViewData: UICollectionView!
    var arrNotifications: Array<NSDictionary>! = []
    var isRefreshing            : Bool = false
    var notificationId          : Int = 0 ;
    var topMenuBtn              : String = ""
    var selectedNotifications   : NSMutableArray! = []
    var serverFlag = 0
    var page = 0
    var loadMore : Int = 0
    var senderId : Int = 0 ;
    var selectAll:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(HomeViewController.reloadNotifications), for: UIControl.Event.valueChanged)
        self.setTabbar()
        self.addLogo()
        self.tabBarController?.selectedIndex = 0
        collectionViewData.backgroundColor = UIColor.white
        collectionViewData.addSubview(refreshControl)
        self.collectionViewData.alwaysBounceVertical = true
        
        if DeviceType.IS_IPAD {
            labelPushNotificationCount = UILabel(frame: CGRect(x: 130, y: 0, width: 22, height: 22))
            
        } else {
            
            labelPushNotificationCount = UILabel(frame: CGRect(x: 40, y: 0, width: 22, height: 22))
        }
        labelPushNotificationCount?.layer.borderColor = UIColor.red.cgColor
        labelPushNotificationCount?.layer.borderWidth = 2
        labelPushNotificationCount?.layer.cornerRadius = (labelPushNotificationCount?.bounds.size.height ?? 0)/2
        labelPushNotificationCount?.textAlignment = NSTextAlignment.center
        labelPushNotificationCount?.layer.masksToBounds = true
        labelPushNotificationCount?.font = UIFont(name: "Arial", size: 12)
        labelPushNotificationCount?.textColor = UIColor.white
        labelPushNotificationCount?.backgroundColor = UIColor.red
        labelPushNotificationCount?.text = "0"
        labelPushNotificationCount?.tag = 999
        
        // register push notification
        registerPushNotification()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let btnRight: UIButton! = UIButton(type: UIButton.ButtonType.custom)
        btnRight.setImage(UIImage(imageLiteralResourceName: "edit"), for: .normal)
        btnRight.addTarget(self, action: #selector(HomeViewController.btnEditAction(_:)), for: UIControl.Event.touchUpInside)
        
        let barBtnRight: UIBarButtonItem = UIBarButtonItem(customView: btnRight)
        self.navigationItem.rightBarButtonItem = barBtnRight
        self.navigationItem.leftBarButtonItem = nil
        self.page = 1
        self.arrNotifications = []
        self.topMenuBtn = ""
        
        selectedNotifications = []
        
        setNotificationCount();
        
        getNotifications()
//        self.tabBarController!.tabBar.isHidden = false
    }
    
    @objc func reloadNotifications(){
        
        let btnRight: UIButton! = UIButton(type: UIButton.ButtonType.custom)
        btnRight.setImage(UIImage(imageLiteralResourceName: "edit"), for: .normal)
        btnRight.addTarget(self, action: #selector(HomeViewController.btnEditAction(_:)), for: UIControl.Event.touchUpInside)
        let barBtnRight: UIBarButtonItem = UIBarButtonItem(customView: btnRight)
        self.navigationItem.rightBarButtonItem = barBtnRight
        self.isRefreshing = true
        self.page = 1;
        self.topMenuBtn = ""
        selectedNotifications = []
        
        getNotifications()
        setNotificationCount();
    }
    func addLogo() {
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named:"PushWoshLogo"))
    }
    func setTabbar() {
        
        self.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "home-activeTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        // self.tabBarItem.image = UIImage(named: "homeTab");self.tabBarItem.selectedImage = UIImage(named: "home-activeTab")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var separtorCell = self.arrNotifications.count/2
        separtorCell += (self.arrNotifications.count % 2 == 1) ? 1 : 0
        return self.arrNotifications.count + separtorCell
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        var cellIdentifier = ""
        let cellType = indexPath.row % 3
        if cellType == 0{
            cellIdentifier = "LeftCell"
        } else if cellType == 1{
            cellIdentifier = "CenterCell"
             
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
        } else{
            cellIdentifier = "RightCell"
        }
        
        var arrayIndex = indexPath.row
        let adjustIndex = (indexPath.row + 1) / 3
        if (adjustIndex > 0 ){
            arrayIndex -= adjustIndex
        }
        print(indexPath.row,arrayIndex)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeCollectionViewCell
        
        cell.lblDesc.text = self.arrNotifications[arrayIndex]["txt"] as? String
        
        var height = cell.lblDesc.frame.size.height
        if(DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS ){
            
            height = self.requiredHeight(150.0, font: UIFont.systemFont(ofSize: 12.0), text:cell.lblDesc.text! )
        }
        else if(DeviceType.IS_IPHONE_6P){
            
            height = self.requiredHeight(195.0-16.0, font: UIFont.systemFont(ofSize: 12.0), text:cell.lblDesc.text! )
        }
        else if(DeviceType.IS_IPHONE_6){
            height = self.requiredHeight(195.0-16.0, font: UIFont.systemFont(ofSize: 12.0), text:cell.lblDesc.text! )
        }
            
        else{
            height = self.requiredHeight(195.0-16.0, font: UIFont.systemFont(ofSize: 12.0*IPAD_SCALING_FACTOR), text:cell.lblDesc.text! )
        }
        
        var frame = cell.lblDesc.frame
        frame.size.height = height
        cell.lblDesc.frame = frame
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.lblTime.text = self.arrNotifications[arrayIndex]["timestamp"] as? String;
        let txt: String = self.arrNotifications[arrayIndex]["title"] as! String
        
        cell.lblTitle.text = txt.replacingOccurrences(of: "\n", with: "")
        
        
        if let t = self.arrNotifications[arrayIndex]["image"] as? String{
            let defaultImg = UIImage(named: "PushWoshLogoIcon")
            
            let imageUrl = URL(string: t)
            cell.imgViewC.sd_setImage(with: imageUrl, placeholderImage: defaultImg)
            
        }
 
        if(self.arrNotifications[arrayIndex]["status"] as! String == "0" ){
            cell.imgViewDot.isHighlighted = true
        }else{
            cell.imgViewDot.isHighlighted = false
        }
        cell.selectUnSelectButton.tag = arrayIndex;
        if (selectedNotifications.contains((Int((self.arrNotifications[arrayIndex]["id"] as? String)!)!))){
            cell.selectUnSelectButton.isSelected = true;
        }else{
            cell.selectUnSelectButton.isSelected = false;
        }
        if self.topMenuBtn == ""{
            cell.selectUnSelectButton.isHidden = true
        }else{
            cell.selectUnSelectButton.isHidden = false
        }
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        if indexPath.row % 3 == 1{
            return
        }
        var arrayIndex = indexPath.row
        let adjustIndex = (indexPath.row + 1) / 3
        if adjustIndex > 0{
            arrayIndex -= adjustIndex
        }
        print(indexPath.row,arrayIndex)
        
        
        let cellIdentifier = (indexPath.row % 3 == 0) ? "LeftCell" : "RightCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeCollectionViewCell
        
       
        
        let newArr = self.arrNotifications[arrayIndex] as NSDictionary
        let newArr1 = newArr.mutableCopy() as! NSDictionary
        newArr1.setValue("0", forKey: "status")
        self.arrNotifications[arrayIndex] = newArr1
        // print( self.arrNotifications[indexPath.row])
        collectionView.reloadData()
        //self.arrNotifications[indexPath.row].setValue("1", forKey: "status")
        let dic: NSDictionary = self.arrNotifications[arrayIndex]
        self.notificationId = Int(dic["id"] as! String)!;
        if(self.topMenuBtn == "Edit" || self.topMenuBtn == "Done"){
            
            if (selectedNotifications.contains(self.notificationId)){
                self.selectedNotifications.remove(notificationId)
            }else{
                self.selectedNotifications.add(notificationId)
            }
            
            
            self.collectionViewData.reloadData()
        }else{
            
            //if(!_tableView.editing){
            //tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            
            //  cell.imgViewDot.highlighted = true
            
            if let sndId = dic["senderId"] as? String{
                self.senderId = Int(sndId)!
            }
            
            if(dic["notification_type"] as! String == "Location"){
                let mapController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                mapController.lat_long = dic["url"] as? String
                mapController.isFromNotification = false
                self.saveAnalytics("", objectID: dic.value(forKey: "objectId") as! String , merchantID: dic.value(forKey: "subAdminId") as! String,notificationType: dic["notification_type"] as! String)
                self.navigationController?.pushViewController(mapController, animated: true)
//                self.tabBarController!.tabBar.isHidden = true
            }
            else if(dic["notification_type"] as! String == "Caption"){
                let alert:UIAlertView = UIAlertView(title: "Caption", message: dic["url"] as? String, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
                self.saveAnalytics("", objectID: dic.value(forKey: "objectId") as! String , merchantID: dic.value(forKey: "subAdminId") as! String,notificationType: dic["notification_type"] as! String)
                
            }
            else if(dic["notification_type"] as! String == "Weather"){
                let alert:UIAlertView = UIAlertView(title: "Weather", message: dic["url"] as? String, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
                
                self.saveAnalytics("", objectID: dic.value(forKey: "objectId") as! String , merchantID: dic.value(forKey: "subAdminId") as! String,notificationType: dic["notification_type"] as! String)
                
                
            }else if(dic["notification_type"] as! String == "local" &&  dic["url"] as? String == ""){
                self.alert(dic["message"] as! String)
                self.saveAnalytics("", objectID: dic.value(forKey: "objectId") as! String , merchantID: dic.value(forKey: "subAdminId") as! String,notificationType: dic["notification_type"] as! String)
            }
            else{
                //dic["notification_type"] as! String == "local" &&
                if(dic["message"] as! String != "" ){
                    
                    //self.saveAnalytics("", objectID: dic.value(forKey: "objectId") as! String , merchantID: dic.value(forKey: "subAdminId") as! String,notificationType: dic["notification_type"] as! String)
                    
                    let alert = UIAlertController(title: "PushWosh", message:dic["message"] as? String, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Cancel", style: .default) { _ in
                        
                    }
                    let action1 = UIAlertAction(title: "Go To Link", style: .default) { _ in
                        let webController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_DETAILS) as! WebViewController
                        
                        
                        webController.link                  = dic["url"]        as? String
                        webController.titleWeb              = dic["title"]      as? String
                        webController.subAdminId            = dic["subAdminId"]   as? String
                        webController.objectId              = dic["objectId"]    as? String
                        webController.notificationType      = dic["contentType"] as! String
                        webController.notificationType1     = dic["productType"] as! String
                        webController.notifictionId         = Int(dic["id"] as! String)!
                        webController.senderId              = self.senderId
                        
                        if let pD = dic["productData"] as? NSDictionary {
                            webController.productData           = pD
                        }
                        
                        self.navigationController?.pushViewController(webController, animated: true)
//                        self.tabBarController!.tabBar.isHidden = true
                    }
                    alert.addAction(action)
                    alert.addAction(action1)
                    self.present(alert, animated: true){}
                    return
                }
                
                let webController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_DETAILS) as! WebViewController
                webController.link                  = dic["url"]            as? String
                webController.titleWeb              = dic["title"]          as? String
                webController.subAdminId            = dic["subAdminId"]     as? String
                webController.objectId              = dic["objectId"]       as? String
                webController.notificationType      = dic["contentType"]    as! String
                webController.notificationType1     = dic["productType"]    as! String
                webController.notifictionId         = Int(dic["id"]         as! String)!
                webController.senderId              = self.senderId
                
                if let pD = dic["productData"] as? NSDictionary {
                    webController.productData           = pD
                }
                
                
                self.navigationController?.pushViewController(webController, animated: true)
//                self.tabBarController!.tabBar.isHidden = true
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row % 3 == 1{
           
            
            return CGSize(width: 25, height: 150)
        } else{
            
            let width = (self.view.frame.width / 2 ) - 32.5
           
            
            return CGSize(width: width, height: 150)

        }
//        let text = self.arrNotifications[indexPath.row]["txt"] as! String
//
//
//
//
//        if(DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS){
//
//            let height = self.requiredHeight(150.0, font: UIFont.systemFont(ofSize: 12.0), text:text )
//            return CGSize(width: 150.0 , height: 90.0+height)
//        }
//
//        if(DeviceType.IS_IPHONE_6P){
//
//            let height = self.requiredHeight(195.0-16.0, font: UIFont.systemFont(ofSize: 12.0), text:text )
//            return CGSize(width: 198.0 , height: 90.0+height)
//        }
//
//        if(DeviceType.IS_IPHONE_6){
//            let height = self.requiredHeight(195.0-16.0, font: UIFont.systemFont(ofSize: 12.0), text:text )
//
//            return CGSize(width: 180.0 , height: 90.0+height)
//        }
//        else if DeviceType.IS_IPHONE_X{
//            let height = self.requiredHeight(195.0-16.0, font: UIFont.systemFont(ofSize: 12.0), text:text )
//
//            return CGSize(width: 180.0 , height: 90.0+height)
//        }
//        else{
//
//
//
//            let height = self.requiredHeight(195.0-16.0, font: UIFont.systemFont(ofSize: 12.0*IPAD_SCALING_FACTOR), text:text )
//            return CGSize(width: 375.0 , height:90.0+height)
//        }
        
        
    }
    
    func requiredHeight(_ width:CGFloat,font:UIFont,text:String) -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        
        return label.frame.height
    }
    func registerPushNotification() {
        
        if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0 {
            let setting: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    func getNotifications() {
        
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        if !self.isReachable() {
            return
        }
        
        if(self.serverFlag == 1){
            return
        }
        self.serverFlag = 1
        
        
        if(self.isRefreshing == false){
            self.showActivityIndicator()
        }
        self.isRefreshing = false
        
        let params : Parameters = ["userId" : userId,"page":String(self.page)];
        
        
        Alamofire.request( baseUrl + "updateNotificationStatus", parameters:params)
            .responseJSON { response in
                
                self.serverFlag = 0
                if let jsonResponse = response.result.value  as? NSDictionary{
                    
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        self.firstTimePush()
                        self.loadMore = jsonResponse["loadMore"] as! Int
                        let newData  = jsonResponse["data"] as! Array<NSDictionary>
                        
                        if(self.page == 1){
                            
                            self.arrNotifications = []
                            self.arrNotifications = newData
                            
                            
                        }else{
                            var startIndex : Int = self.arrNotifications.count + 1;
                            
                            for newD in newData{
                                // let indx : String = String(startIndex)
                                self.arrNotifications.append(newD)
                                //self.arrNotifications.setObject(newD.value, forKey: indx)
                                startIndex = startIndex + 1
                            }
                        }
                        self.page = self.page + 1
                        
                        self.collectionViewData.reloadData()
                        
                    }
                    else {
                        
                        self.alert((jsonResponse["msg"] as? String)!)
                    }
                }
                
                self.hideActivityIndicator()
                self.refreshControl.endRefreshing()
        }
    }
    func saveAnalytics(_ lnk:String, objectID :String, merchantID : String,notificationType : String ){
        
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        
        if !self.isReachable() {
            return
        }
        let strNotificationId = String(self.notificationId);
        
        let params :  Parameters = [
            "userId"        :   userId,
            "link"          :   lnk,
            "objectId"      :   objectID,
            "merchantId"    :   merchantID,
            "deviceType"    :   "Ios",
            "contentType"   :   notificationType,
            "notificationId":   strNotificationId,
            "inviteeId"     :   String(self.senderId)
        ];
        Alamofire.request(baseUrl + "saveAnalytics", parameters:params)
            .responseJSON { response in
                self.setNotificationCount();
                if let jsonResponse = response.result.value as? NSDictionary{
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                    }else {
                        
                    }
                }
        }
        
        
    }
    func deleteNotifications(_ notificationId:String, type:String, indexPaths:NSArray){
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        
        if !self.isReachable() {
            return
        }
        
        self.showActivityIndicator()
        let params : Parameters = ["userId" : userId, "type": "all", "notificationId": notificationId];
        Alamofire.request(baseUrl + "deleteNotification", parameters:params)
            .responseJSON { response in
                
                
                self.hideActivityIndicator()
                self.setNotificationCount()
                if let jsonResponse = response.result.value as? NSDictionary {
                    
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        self.selectedNotifications = []
                        if(type == "All"){
                            self.arrNotifications.removeAll(keepingCapacity: true)
                        }else{
                            for indexPath in indexPaths{
                                self.arrNotifications.remove(at: indexPath as! Int)
                            }
                        }
                        
                    }
                    else {
                        self.alert(jsonResponse["msg"] as! String)
                    }
                    
                    self.topMenuBtn = "Edit"
                    self.collectionViewData.reloadData()
                }
        }
    }
    func deleteNotification(_ notificationId: String, type: String, index: Int) {
        
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        let params : Parameters = ["userId" : userId, "type": type, "notificationId": notificationId];
        Alamofire.request(baseUrl + "deleteNotification", parameters:params)
            .responseJSON { response in
                
                if let jsonResponse = response.result.value as? NSDictionary {
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        if type == "single" {
                            self.arrNotifications.remove(at: index)
                            
                        }
                        else {
                            //self.arrNotifications.removeAllObjects()
                            self.arrNotifications.removeAll(keepingCapacity: false)
                            self.collectionViewData.reloadData()
                        }
                    }
                    else {
                        self.alert(jsonResponse["msg"] as! String)
                    }
                    
                }
        }
    }
    func updateCollectionView() {
        
        if(self.topMenuBtn == "Edit"){
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = nil;
            
            let btnRight: UIButton! = UIButton(type: UIButton.ButtonType.custom)
            btnRight.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            btnRight.setTitle("Select All", for: UIControl.State())
            btnRight.setTitleColor(.black, for: .normal)
            btnRight.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
            btnRight.addTarget(self, action: #selector(HomeViewController.selectAllNotification(_:)), for: UIControl.Event.touchUpInside)
            
            let barBtnRight: UIBarButtonItem = UIBarButtonItem(customView: btnRight)
            self.navigationItem.rightBarButtonItem = barBtnRight
            
            
            let btnleft: UIButton! = UIButton(type: UIButton.ButtonType.custom)
            btnleft.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            btnleft.setTitle("Delete", for: UIControl.State())
            btnleft.setTitleColor(.black, for: .normal)
            btnleft.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
            btnleft.addTarget(self, action: #selector(HomeViewController.btnDoneAction(_:)), for: UIControl.Event.touchUpInside)
            let btnleft1: UIButton! = UIButton(type: UIButton.ButtonType.custom)
            btnleft1.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            btnleft1.setTitle("Cancel", for: UIControl.State())
            btnleft1.setTitleColor(.black, for: .normal)
            btnleft1.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
            btnleft1.addTarget(self, action: #selector(HomeViewController.btnCancelAction(_:)), for: UIControl.Event.touchUpInside)
            let barBtnleft: UIBarButtonItem = UIBarButtonItem(customView: btnleft)
            let barBtnleft1: UIBarButtonItem = UIBarButtonItem(customView: btnleft1)
            self.navigationItem.leftBarButtonItems = [barBtnleft,barBtnleft1]
            // self.navigationItem.leftBarButtonItem =
        }
        else{
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = nil;
            
            let btnRight: UIButton! = UIButton(type: UIButton.ButtonType.custom)
            btnRight.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            btnRight.setTitle("Unselect All", for: UIControl.State())
            btnRight.setTitleColor(.black, for: .normal)
            btnRight.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
            btnRight.addTarget(self, action: #selector(HomeViewController.unSelectAllNotification(_:)), for: UIControl.Event.touchUpInside)
            
            let barBtnRight: UIBarButtonItem = UIBarButtonItem(customView: btnRight)
            self.navigationItem.rightBarButtonItem = barBtnRight
            
            let btnleft: UIButton! = UIButton(type: UIButton.ButtonType.custom)
            btnleft.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            btnleft.setTitle("Delete", for: UIControl.State())
            btnleft.setTitleColor(.black, for: .normal)
            btnleft.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
            btnleft.addTarget(self, action: #selector(HomeViewController.btnDoneAction(_:)), for: UIControl.Event.touchUpInside)
            let btnleft1: UIButton! = UIButton(type: UIButton.ButtonType.custom)
            btnleft1.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            btnleft1.setTitle("Cancel", for: UIControl.State())
            btnleft1.setTitleColor(.black, for: .normal)
            btnleft1.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
            btnleft1.addTarget(self, action: #selector(HomeViewController.btnCancelAction(_:)), for: UIControl.Event.touchUpInside)
            let barBtnleft: UIBarButtonItem = UIBarButtonItem(customView: btnleft)
            let barBtnleft1: UIBarButtonItem = UIBarButtonItem(customView: btnleft1)
            self.navigationItem.leftBarButtonItems = [barBtnleft,barBtnleft1]
            
            
        }
        self.collectionViewData.reloadData()
    }
    @objc func selectAllNotification(_ sender:AnyObject){
        self.topMenuBtn = "Done"
        selectedNotifications = []
        for  arrNot in self.arrNotifications{
            selectedNotifications.add(Int((arrNot["id"] as? String)!))
        }
        self.collectionViewData.reloadData()
        self.updateCollectionView()
    }
    @objc func unSelectAllNotification(_ sender:AnyObject){
        self.topMenuBtn = "Edit"
        selectedNotifications = []
        self.collectionViewData.reloadData()
        self.updateCollectionView()
    }
    
    
    @objc func btnEditAction(_ sender:AnyObject){
        self.topMenuBtn = "Edit"
        self.updateCollectionView()
    }
    
    @objc func btnCancelAction(_ sender:AnyObject){
        selectedNotifications = []; self.topMenuBtn = ""; let btnRight: UIButton! = UIButton(type: UIButton.ButtonType.custom)
        btnRight.setImage(UIImage(imageLiteralResourceName: "edit"), for: .normal)
        btnRight.addTarget(self, action: #selector(HomeViewController.btnEditAction(_:)), for: UIControl.Event.touchUpInside)
        
        
        let barBtnRight: UIBarButtonItem = UIBarButtonItem(customView: btnRight)
        self.navigationItem.rightBarButtonItem = barBtnRight
        self.navigationItem.leftBarButtonItems = nil
        self.collectionViewData.reloadData();
    }
    
    func btnBackAction(_ sender:AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnDoneAction(_ sender:AnyObject){
        
        let selectedRows:NSArray? = selectedNotifications
        if(selectedRows!.count == 0){
            self.alert("Please Mark a notification to delete!")
        }else{
            let indexArr : NSMutableArray = []
            var t = 0
            let totalNotif = self.arrNotifications.count
            
            for i in 0 ..< totalNotif {
                let ind = selectedNotifications.index(of: self.arrNotifications[i]["id"] as! String)
                if(ind < totalNotif){
                    indexArr.add(i)
                }
            }
            let selectedIDs:String = selectedNotifications!.componentsJoined(by: ",")
            let type = (self.selectedNotifications.count == totalNotif ) ? "All" : "Single"
            self.deleteNotifications(selectedIDs, type: type,indexPaths: indexArr)
        }
    }
    @IBAction func selectNotification(_ sender: UIButton) {
        
        let notificationData : NSDictionary = arrNotifications[sender.tag]
        
        let notificationId = notificationData["id"] as? String
        
        
        if(sender.isSelected == true){
            sender.isSelected = false
            selectedNotifications.remove(notificationId!)
            
        }else{
            sender.isSelected = true
            selectedNotifications.add(notificationId!)
        }
        // print(selectedNotifications)
        
        
        // self.arrNotifications[sender.tag] = notificationData
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollViewHeight : CGFloat = scrollView.frame.size.height
        let scrollContentSizeHeight : CGFloat = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        let scrollVal = scrollOffset + scrollViewHeight
        if (scrollVal >= scrollContentSizeHeight){
            if(self.loadMore == 1){
                self.getNotifications()
            }
        }
        
    }
    
    func firstTimePush(){
        
        let defaults = UserDefaults.standard;
        let userData = defaults.value(forKey: "userData") as! NSDictionary
        
        
        if(userData.value(forKey: "firstTime") as? Int == 1) {
            
            var audioPlayer = AVAudioPlayer()
            let soundPath: String = Bundle.main.path(forResource: "hello-2.caf", ofType: "")!
            if FileManager.default.fileExists(atPath: soundPath) {
                do{
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
                }
                catch{
                    print(error)
                }
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
            let uD = userData.mutableCopy()
            (uD as AnyObject).setValue("1", forKey: "firstTime")
            defaults.set(uD, forKey: "userData")
            defaults.synchronize()
        }
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var circularView: Bool {
        get{
            return  self.circularView
            }
        set {
            if newValue == true{
                self.layer.cornerRadius = self.frame.height/2
                self.layer.masksToBounds = true
            } else{
                self.layer.cornerRadius = 0
                self.layer.masksToBounds = false
            }
        }
    }
    
}
