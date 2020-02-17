//
//  NotificationsViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 07/03/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit
import Alamofire
import AddressBookUI
import MessageUI
import CoreLocation
import Contacts

class NotificationsViewController: BaseViewController,CLLocationManagerDelegate {
    var locationManager         = CLLocationManager()
    
    @IBOutlet weak var scrollViewImages: UIScrollView!
     var addressBook: ABAddressBook?
    @IBOutlet weak var imgBullet1: UIImageView!
    @IBOutlet weak var imgBullet2: UIImageView!
    @IBOutlet weak var imgBullet3: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    
    @IBOutlet weak var btnAgree: UIButton!
    
    @IBOutlet weak var btnNotNow: UIButton!
    @IBOutlet weak var imgViewMobile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.imgBullet1.image = UIImage(named: "checkBoxActive")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
       // self.scrollViewImages.contentSize = CGSize(width: self.view.frame.size.width * 3, height: self.scrollViewImages.frame.size.height)
        
        self.addRemainingImagesOnScroll()
    }
    
    func addRemainingImagesOnScroll() {
        
        let imageView = UIImageView(frame: CGRect(x: self.scrollViewImages.frame.size.width+59, y: self.imgViewMobile.frame.origin.y, width:self.imgViewMobile.frame.size.width , height: imgViewMobile.frame.size.height))
        
        imageView.image = UIImage(named: "mobile-2")
        self.scrollViewImages.addSubview(imageView)
        
        let imageView2 = UIImageView(frame: CGRect(x: (self.scrollViewImages.frame.size.width*2)+59, y: self.imgViewMobile.frame.origin.y, width:self.imgViewMobile.frame.size.width , height: imgViewMobile.frame.size.height))
        
        imageView2.image = UIImage(named: "mobile-3")
        self.scrollViewImages.addSubview(imageView2)
        
        let lbl1 = UILabel(frame: CGRect(x: self.scrollViewImages.frame.size.width+8, y: self.lblText.frame.origin.y, width:self.lblText.frame.size.width , height: lblText.frame.size.height))
        
        lbl1.backgroundColor = UIColor.clear
        lbl1.textColor = UIColor.darkGray
        lbl1.textAlignment = NSTextAlignment.center
        lbl1.text = "Easy share things will all your contacts through a simple push."
        lbl1.numberOfLines = 2
        
        self.scrollViewImages.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect(x: (self.scrollViewImages.frame.size.width*2)+8, y: self.lblText.frame.origin.y, width:self.lblText.frame.size.width , height: lblText.frame.size.height))
        
        lbl2.backgroundColor = UIColor.clear
        lbl2.textColor = UIColor.darkGray
        lbl2.textAlignment = NSTextAlignment.center
        lbl2.text = "Drop a pin, check the weather and much more based on your location."
        lbl2.numberOfLines = 2
        
        self.scrollViewImages.addSubview(lbl2)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func actionNotNow(_ sender: AnyObject) {
        
        if(sender.tag == 0) {
            
            btnAgree.tag = 1
            btnNotNow.tag = 1
            self.scrollViewImages.setContentOffset(CGPoint(x: self.scrollViewImages.frame.size.width  , y: self.scrollViewImages.frame.origin.y), animated: true)
            btnAgree.setImage(UIImage(named: "sync-your-contact"), for: UIControl.State())
            self.imgBullet2.image = UIImage(named: "checkBoxActive")
        }
        
        else if(sender.tag == 1) {
            
            btnAgree.tag = 2
            btnNotNow.tag = 2
            self.scrollViewImages.setContentOffset(CGPoint(x: self.scrollViewImages.frame.size.width*2 , y: self.scrollViewImages.frame.origin.y), animated: true)
            btnAgree.setImage(UIImage(named: "use-your-location"), for: UIControl.State())
            self.imgBullet3.image = UIImage(named: "checkBoxActive")

        }
        else if(sender.tag == 2){
            
            self.moveToHome()
        }
    }
    @IBAction func actionAgree(_ sender: AnyObject) {
        
        
        if(sender.tag == 0) {
            registerPushNotification()
            
            btnNotNow.tag = 1
            btnAgree.tag = 1
            self.scrollViewImages.setContentOffset(CGPoint(x: self.scrollViewImages.frame.size.width , y: self.scrollViewImages.frame.origin.y), animated: true)
            btnAgree.setImage(UIImage(named: "sync-your-contact"), for: UIControl.State())
            self.imgBullet2.image = UIImage(named: "checkBoxActive")
        }
        
        else if(sender.tag == 1) {
            getContactsPermission();
            /*
            btnNotNow.tag = 2
            btnAgree.tag = 2
            self.scrollViewImages.setContentOffset(CGPoint(x: self.scrollViewImages.frame.size.width*2, y: self.scrollViewImages.frame.origin.y), animated: true)
            btnAgree.setImage(UIImage(named: "use-your-location"), forState: UIControlState.Normal)
            self.imgBullet3.image = UIImage(named: "checkBoxActive")
*/
        }
        
        else if(sender.tag == 2){
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            self.showActivityIndicator()
        }
    }
    
    func moveToHome() {
        
        let tabController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_DASHBOARD);UIApplication.shared.keyWindow?.rootViewController = tabController
        self.present(tabController!, animated: true, completion: nil)
    }
    func registerPushNotification() {
        
        if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0 {
            let setting: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    func extractABAddressBookRef(_ abRef: Unmanaged<ABAddressBook>!) -> ABAddressBook? {
        if let ab = abRef {
            return Unmanaged<NSObject>.fromOpaque(ab.toOpaque()).takeUnretainedValue()
        }
        return nil
    }
    
    func getContactsPermission(){
        
        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.notDetermined) {
            print("requesting access...")
            var errorRef: Unmanaged<CFError>? = nil
            addressBook = extractABAddressBookRef(ABAddressBookCreateWithOptions(nil, &errorRef))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in
                if success {
                    self.btnNotNow.tag = 2
                    self.btnAgree.tag = 2
                    self.scrollViewImages.setContentOffset(CGPoint(x: self.scrollViewImages.frame.size.width*2 , y: self.scrollViewImages.frame.origin.y), animated: true)
                    self.btnAgree.setImage(UIImage(named: "use-your-location"), for: UIControl.State())
                    self.imgBullet3.image = UIImage(named: "checkBoxActive")
                }
                else {
                    print("Denied")
                    self.btnNotNow.tag = 2
                    self.btnAgree.tag = 2
                    self.scrollViewImages.setContentOffset(CGPoint(x: self.scrollViewImages.frame.size.width*2 , y: self.scrollViewImages.frame.origin.y), animated: true)
                    self.btnAgree.setImage(UIImage(named: "use-your-location"), for: UIControl.State())
                    self.imgBullet3.image = UIImage(named: "checkBoxActive")
                }
            })
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.denied || ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.restricted) {
             print("HERE")
            self.btnNotNow.tag = 2
            self.btnAgree.tag = 2
            self.scrollViewImages.setContentOffset(CGPoint(x: self.scrollViewImages.frame.size.width*2 , y: self.scrollViewImages.frame.origin.y), animated: true)
            self.btnAgree.setImage(UIImage(named: "use-your-location"), for: UIControl.State())
            self.imgBullet3.image = UIImage(named: "checkBoxActive")
        }
        else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.authorized) {
             print("Authorized")
            self.btnNotNow.tag = 2
            self.btnAgree.tag = 2
            self.scrollViewImages.setContentOffset(CGPoint(x: self.scrollViewImages.frame.size.width*2, y: self.scrollViewImages.frame.origin.y), animated: true)
            self.btnAgree.setImage(UIImage(named: "use-your-location"), for: UIControl.State())
            self.imgBullet3.image = UIImage(named: "checkBoxActive")
        }
    
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
            self.moveToHome()
            print(error, terminator: "")
            self.hideActivityIndicator()
        
    
    }
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        self.hideActivityIndicator()
        self.moveToHome()
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
