//
//  BaseViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 25/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
//let baseUrl: String = "http://www.ipushnote.com/pushnote/services/index/"
//let baseUrl: String = "http://64.235.52.220/~ipushnote/pnote/pushnote/services/index/"
//let baseUrl: String   = "http://64.235.52.220/~ipushnote/pushnote-analytics/services/analyticsindex/"
//let baseUrl: String   = "http://ipushnote.com/pushnote-analytics/services/analyticsindex/"
let baseUrl = "http://184.154.161.201/~pushwosh/pushwoshapp/services/analyticsindex"
let servicesPath = "http://pushwosh.com/pushwoshapp/services/"
//let baseUrl         : String   = "http://localhost/ipushnote/services/analyticsindex/"
//let servicesPath    : String   = "http://localhost/ipushnote/services/"
//let baseUrl         : String   = "http://34.215.238.89/services/analyticsindex/"
//let servicesPath    : String   = "http://34.215.238.89/services/"

let worldWeatherOnlineKey = "7167f4a731f3f4ea5ff59a9f884d4"
let WWOnlineBaseURL = "https://api.worldweatheronline.com/free/v2/weather.ashx?"
let appName = "PushWosh"

class BaseViewController: UIViewController {
    
    var reachability: Reachability?
    var labelPushNotificationCount: UILabel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var size: CGFloat = 22.0
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            size = size * IPAD_SCALING_FACTOR
        }
        
        // configure navigation bar
        configureNavigationBar(with: size)
        
        // configure tab bar
        configureTabBar()
    }
    
    private func configureNavigationBar(with size: CGFloat = 17.0) {
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.lightGray
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                          NSAttributedString.Key.shadow: shadow,
                          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: size)]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    private func configureTabBar() {
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 31.0/255.0, green: 39.0/255.0, blue: 125.0/255.0, alpha: 1.0)], for:UIControl.State())
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 242/255.0, green: 70.0/255.0, blue: 33.0/255.0, alpha: 1.0)], for:.selected)
        tabBarController?.tabBar.tintColor = UIColor(red: 31.0/255.0, green: 39.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    }
    
    func addBackBtn() {
        
        let barbutton = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(BaseViewController.actionBackNav))
        navigationItem.leftBarButtonItem = barbutton
    }
    
    @objc func actionBackNav() {
        navigationController?.popViewController(animated: true)
    }
    
    func isReachable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func showActivityIndicator() {
        SVProgressHUD.show(with: SVProgressHUDMaskType.black)
    }
    
    func hideActivityIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func alert(_ message:String) {
        let alert = UIAlertController(title: appName, message:message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            // Put here any code that you would like to execute when
            // the user taps that OK button (may be empty in your case if that's just
            // an informative alert)
        }
        alert.addAction(action)
        self.present(alert, animated: true){}
        
    }
    
    func setNotificationCount() {
        
        let defaults    = UserDefaults.standard;
        let userId      = defaults.value(forKeyPath: "userData.user_id") as! String
        let parameters      : Parameters = ["userId" : userId];
        
        Alamofire.request(baseUrl + "pushCount", parameters: parameters)
            .responseJSON { [weak self] response in
                print(response)
                if let jsonResponse = response.result.value as? NSDictionary {
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        self?.tabBarController?.tabBar.items?.first?.badgeValue = jsonResponse["totalPush"] as? String
                    }
                }
        }
    }
}
