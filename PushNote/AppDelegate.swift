//
//  AppDelegate.swift
//  PushNote
//
//  Created by Danish Ghauri on 25/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var vc = BaseViewController()
    var window: UIWindow?
    var dicNotification: NSDictionary!
    var navController: UINavigationController!
    var audioPlayer     : AVAudioPlayer!
    var uInfo : AnyObject? = () as AnyObject?
    var lblPushCount = UILabel()
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let defaults = UserDefaults.standard;
        if (defaults.value(forKeyPath: "userData.user_id") as? String) != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let t = storyboard.instantiateViewController(withIdentifier: "TabSegue") as! UITabBarController;
            print(t) ;
        if let tbc : UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabSegue") as? UITabBarController{
            self.window?.rootViewController = tbc
            
            }
        }
        if let launchOpts = launchOptions {
            let dic: NSDictionary = launchOpts[UIApplication.LaunchOptionsKey.remoteNotification] as! NSDictionary
            dicNotification = dic
        }
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
       
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // let devToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //var devToken: NSString = deviceToken.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>")) as NSString;print(devToken);
       // devToken = devToken.replacingOccurrences(of: " ", with: "") as NSString
        
        
        var devToken = ""
        for i in 0..<deviceToken.count {
            devToken = devToken + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        let defaults = UserDefaults.standard;
        let userId = defaults.value(forKeyPath: "userData.user_id") as! String
        let params : Parameters = ["deviceID": devToken, "deviceType": "iOS", "userId": userId]
        Alamofire.request(baseUrl + "addDevice", parameters:params)
            .responseJSON { response in
                if let jsonResponse = response.result.value {
                    print("jsonResponse: \(jsonResponse)")
                }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error);
        print("error");
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
       self.setBadgeCount();
        if application.applicationState != UIApplication.State.active {
            if userInfo["url"] != nil {
                self.uInfo = userInfo as AnyObject?
                if userInfo["type"] != nil{
                    if(userInfo["type"] as! String == "Location"){
                        addMapViewWithUrl(userInfo["url"] as! String, title: userInfo["title"] as? String)
                    }
                    else if(userInfo["type"] as! String == "Caption"){
                        let alert:UIAlertView = UIAlertView(title: "Caption", message: userInfo["url"] as? String, delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                    else if(userInfo["type"] as! String == "Weather"){
                        let alert:UIAlertView = UIAlertView(title: "Weather", message: userInfo["url"] as? String, delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    } else if(userInfo["type"] as! String == "local" &&  userInfo["url"] as?
                        String == ""){
                        let alert:UIAlertView = UIAlertView(title: "Pushnote", message: userInfo["message"] as? String, delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }else if(userInfo["type"] as! String == "welcome"){
                            let alert:UIAlertView = UIAlertView(title: "Welcome to Pushnote", message: "To get started, go to the INDEX section and get yourself subscribed to a feed.", delegate: nil, cancelButtonTitle: "OK")
                            alert.show()
                    }
                    else{
                        if(userInfo["type"] as! String == "local" && userInfo["message"] as? String != "" ){
                            
                            self.uInfo = userInfo as AnyObject?
                            let alertView = UIAlertView(title: "Pushnote",
                                message:(userInfo["message"] as? String)!, delegate: nil, cancelButtonTitle: nil,
                                otherButtonTitles: "Cancel", "Go To Link")
                            
                            AlertViewWithCallback().show(alertView) { alertView, buttonIndex in
                                switch buttonIndex{
                                case 0:
                                   print("HERE")
                                   break;
                                case 1:
                                    self.addWebViewWithUrl(userInfo["url"] as! String, title: userInfo["title"] as? String)
                                    break;
                                default:
                                    print("Something went wrong!")
                                }
                            }
                        
                        }else{
                            addWebViewWithUrl(userInfo["url"] as! String, title: userInfo["title"] as? String)
                        
                        }
 
                        
                    }
                }
                else{
                    if userInfo["url"] != nil{
                        addWebViewWithUrl(userInfo["url"] as! String, title: userInfo["title"] as? String)
                    }
                }
            }
        }
        else {
            
            if let dic: NSDictionary = userInfo["aps"] as? NSDictionary {
               let soundPath: String = Bundle.main.path(forResource: dic["sound"] as? String, ofType: "")!
                
                if FileManager.default.fileExists(atPath: soundPath) {
                    
                    
                    do{
                        self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
                        self.audioPlayer.prepareToPlay()
                        self.audioPlayer.play()
                    }catch{
                        print(error)
                    }
                
                    
                    if(userInfo["type"] as! String == "welcome"){
                        let alert:UIAlertView = UIAlertView(title: "Welcome to Pushnote", message: "Please tap the box to get started!", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                    
                    
                }
            }
        }
    }
    func setBadgeCount(){
        if let tbc = self.window?.rootViewController as? UITabBarController{
            var tPushes     =  tbc.tabBar.items?.first?.badgeValue;
            var tPushes1    = Int(tPushes!);
            tPushes1        = tPushes1! + 1;
            tbc.tabBar.items?.first?.badgeValue = String(describing: tPushes1!);
        }
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GPPURLHandler.handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func addWebViewWithUrl(_ url: String, title: String?) {
        
        if navController != nil {
            navController.view.removeFromSuperview()
            navController = nil
        } 
        //print(url)print(self.uInfo)
        if !url.isEmpty {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           
            navController = storyboard.instantiateViewController(withIdentifier: "NavigationControllerWeb") as! UINavigationController
            let webController: WebViewController = navController.viewControllers[0] as! WebViewController
           
            webController.link                      = url
            webController.titleWeb                  = title//"Web Title"
            webController.isFromNotification        = true
            webController.notificationType          = (self.uInfo!["type"] as? String)!
            webController.objectId                  = (self.uInfo!["objectId"] as? String)!
            if let contType = self.uInfo!["productType"] as? String{
                webController.notificationType1 = contType;
                if let pD = self.uInfo!["productData"] as? NSDictionary {
                    webController.productData           = pD
                }
            }
            
            
            self.window?.addSubview(navController.view)
            
      
        }
    }
    
    func addMapViewWithUrl(_ url: String, title: String?) {
        
        if navController != nil {
            navController.view.removeFromSuperview()
            navController = nil
        }
        
        if !url.isEmpty {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            navController = storyboard.instantiateViewController(withIdentifier: "NavigationControllerMap") as! UINavigationController
            let mapController: MapViewController = navController.viewControllers[0] as! MapViewController
            mapController.lat_long = url
            mapController.isFromNotification = true
            self.window?.addSubview(navController.view)

        }
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.iosDevelopment.PushNote" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "PushNote", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("PushNote.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            if let coordinator = try coordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil) {
                // Report any error we got.
                var dict = [AnyHashable: Any]()
                dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
                dict[NSLocalizedFailureReasonErrorKey] = failureReason
                dict[NSUnderlyingErrorKey] = error
                //error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo as! [String : Any])
                // Replace this with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              //  NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        } catch {
            print(error)
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext!.hasChanges {
            do {
                try managedObjectContext!.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }


}

