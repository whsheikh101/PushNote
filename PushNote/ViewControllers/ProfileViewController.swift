//
//  ProfileViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 28/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController{

    @IBOutlet weak var phoneNumber: Label!
    @IBOutlet weak var country: Label!
    @IBOutlet weak var userEmail: Label!
    @IBOutlet weak var userName: Label!
    @IBOutlet weak var profilePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       self.navigationItem.title = "Profile"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setTabbar()
        self.fetchUserData()
    }
    
    
    func fetchUserData(){
        let defaults = UserDefaults.standard;
        let userData = defaults.value(forKeyPath: "userData") as! NSObject
        self.setProfileData(userData)
        print(userData)
        
    }
    func setTabbar() {
        
        self.tabBarItem = UITabBarItem(title: "PROFILE", image: UIImage(named: "profileTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "profile-activeTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
        
        if let navigationItem = self.navigationItem.rightBarButtonItems{
            for item in navigationItem{
                item.target = self
                item.action = #selector(menuButtonTapped(sender:))
                
            }
            
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setProfileData(_ uData : NSObject){
        if let imgUrl = uData.value(forKey: "photo") as? String{
            let imgPathUrl = URL(string: imgUrl)
            let defaultImg = UIImage(named: "iconImg")
            self.profilePicture.sd_setImage(with: imgPathUrl, placeholderImage: defaultImg)
        }
        
        if let userN = uData.value(forKey: "username") as? String{
            let userProfileName = userN
            self.userName.text = userProfileName
        }
        if let userE = uData.value(forKey: "email") as? String{
            let userEmail       = userE
            self.userEmail.text = userEmail
        }
        if let userC = uData.value(forKey: "country") as? String{
            let userCountry     = userC
            self.country.text = userCountry
        }
        if let userP = uData.value(forKey: "phoneNumber") as? String{
            let userPhoneNumber = userP
            self.phoneNumber.text   = userPhoneNumber
        }
        
    }
    @IBAction func mySubscriptionBtnPressed(_ sender: AnyObject) {
        let subListing = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_INDEX_SUB_LISTING) as! IndexSubListingViewController
        subListing.titleStr = "MY SUBSCRIPTIONS"
        subListing.type = "My Subscriptions"
        self.navigationController?.pushViewController(subListing, animated: true)
    }
    
    @IBAction func resetPasswordBtnPressed(_ sender: AnyObject) {
        let resetPasswordView = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
        self.navigationController?.pushViewController(resetPasswordView, animated: true)
        
    }
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController{
            self.present(controller, animated: true, completion: nil)
            controller.didUpdateData = { [weak self] in
                self?.fetchUserData()
            }
        }

    }
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil{
            
        }
    }
    @IBAction func editProfileBtnPressed(_ sender: AnyObject) {
        let editProfileView = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(editProfileView, animated: true)
        
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
