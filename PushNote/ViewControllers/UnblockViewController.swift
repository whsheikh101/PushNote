//
//  UnblockViewController.swift
//  PushNote
//
//  Created by Rizwan on 11/6/14.
//  Copyright (c) 2014 com. All rights reserved.
//

import UIKit
import Alamofire

class UnblockViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var _tableView: UITableView!
    var arrBlockFriends: NSArray = []
    
    override func viewDidLoad() {
        
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        self.title = "Blocked".uppercased()
        if !self.isReachable() {
            return
        }
        self.addBackBtn()
        self.showActivityIndicator(); let params : Parameters = ["userID" : userId]
        Alamofire.request(baseUrl + "viewBlockedFriends", parameters:params)
            .responseJSON { response in
                
                if let jsonResponse = response.result.value  as? NSDictionary{
                    print(jsonResponse)
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        self.arrBlockFriends = jsonResponse["data"] as! Array<NSDictionary> as NSArray
                        
                        self._tableView.reloadData()
                    }
                    else {
                        let alert :UIAlertView = UIAlertView(title: "", message: jsonResponse["msg"] as? String, delegate: nil, cancelButtonTitle: "OK")
                        alert.show();
                    }
                }
                self.hideActivityIndicator()
        }
    }
    
    @IBAction func unblockAllBtnPressed(_ sender: AnyObject) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrBlockFriends.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CustomTableCell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomTableCell
        let blockFriendDictionary = self.arrBlockFriends[indexPath.row] as! NSDictionary
        cell.contactName.text = blockFriendDictionary["username"] as? String
        cell.unblockBtn.tag = indexPath.row
        let imagePathUrl = URL(string: blockFriendDictionary["photo"] as! String )
        let defaultImg = UIImage(named: "iconImg")
        cell.userPicture.sd_setImage(with: imagePathUrl!, placeholderImage: defaultImg)
       // imageViewbox.sd_setImageWithURL(imagePathUrl, placeholderImage: defaultImg)
        
        
        return cell;
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let backgroundView : UIView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.clear
        cell.backgroundView = backgroundView
        cell.backgroundColor = UIColor.clear
    }
    
    @IBAction func unlockBtnPressed(_ sender: AnyObject, forEvent event: UIEvent) {
        print(sender);
        
        let touch: UITouch = (event.allTouches?.first)! as UITouch
        let point = touch.location(in: _tableView) as CGPoint
        let indexPath: IndexPath = _tableView.indexPathForRow(at: point) as IndexPath!
        let blockFriendDictionary = self.arrBlockFriends[indexPath.row] as! NSDictionary
        let userId = blockFriendDictionary["user_id"] as! String
        
        if !self.isReachable() {
            return
        }
        let defaults = UserDefaults.standard;
        
        let blockedBy = defaults.value(forKeyPath: "userData.user_id") as! String //Current UserID

        self.showActivityIndicator(); let params : Parameters = ["uid" : userId,"blockedBy" : blockedBy ]
        Alamofire.request(baseUrl + "unBlock", parameters:params)
            .responseJSON { response in
                
                if let jsonResponse = response.result.value  as? NSDictionary{
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        print(jsonResponse);
                        let arrMutable: NSMutableArray = self.arrBlockFriends.mutableCopy() as! NSMutableArray
                        arrMutable.removeObject(at: indexPath.row)
                        
                        self.arrBlockFriends = arrMutable
                        self._tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.middle)
                        
                    }
                    else {
                        self.alert(jsonResponse["msg"] as! String)
                    
                    }
                }
                self.hideActivityIndicator()
        }
    }
}
