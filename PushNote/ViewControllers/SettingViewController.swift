//
//  SettingViewController.swift
//  PushNote
//
//  Created by Khurram Iqbal on 14/02/2020.
//  Copyright © 2020 Khurram Iqbal. All rights reserved.
//

import UIKit
import Alamofire
class SettingViewController: BaseViewController{
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationItem.title = "Settings".uppercased()
    }
    
    func openPrivacy() {
        
        let privacyController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_PRIVACY)
        self.navigationController?.pushViewController(privacyController!, animated: true)
    }
    
    func openTerms() {
        
        let termsController = self.storyboard?.instantiateViewController(withIdentifier: SEGUE_TERMS)
        self.navigationController?.pushViewController(termsController!, animated: true)
    }
    
    private func pushController(identifier:String){
    
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: identifier){
            self.navigationController?.pushViewController(controller, animated:true)
        }
    }
    
    @IBAction func mySubscription(_ sender: Any) {
       
        let subListing = self.storyboard?.instantiateViewController(withIdentifier: "IndexSubListingSegue") as! IndexSubListingViewController
        subListing.titleStr = "MY SUBSCRIPTIONS"
        subListing.type = "My Subscriptions"
        self.navigationController?.pushViewController(subListing, animated: true)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
//        self.pushController(identifier: "ResetPasswordViewController")
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as? ResetPasswordViewController{
            self.present(controller, animated: true, completion: nil)
        }
    }
    @IBAction func editProfile(_ sender: Any) {
        self.pushController(identifier: "EditProfileViewController")
    }
    @IBAction func aboutPush(_ sender: Any) {
       
        let aboutController = self.storyboard?.instantiateViewController(withIdentifier: "AboutTextViewController") as? AboutTextViewController
        aboutController!.myTitle = "About"
        self.navigationController?.pushViewController(aboutController!, animated: true)
    }
    
    @IBAction func howToUse(_ sender: Any) {
        self.pushController(identifier: "HowItWorksViewController")
    }
    
    @IBAction func privacyPolicy(_ sender: Any) {
       
        let aboutController = self.storyboard?.instantiateViewController(withIdentifier: "AboutTextViewController") as? AboutTextViewController
        aboutController!.myTitle = "Privacy Policy"
        self.navigationController?.pushViewController(aboutController!, animated: true)
    }
    
    @IBAction func termsConditions(_ sender: Any) {

        let aboutController = self.storyboard?.instantiateViewController(withIdentifier: "AboutTextViewController") as? AboutTextViewController
        aboutController!.myTitle = "Terms"
        self.navigationController?.pushViewController(aboutController!, animated: true)
    }
    
}

