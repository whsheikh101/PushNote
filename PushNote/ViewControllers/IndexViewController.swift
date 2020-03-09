//
//  IndexViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 28/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit
import Alamofire
class IndexViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var isRefreshing : Bool = false
    var arrCategory: Array<NSDictionary> = []
    var arrCategoryDetail: NSArray = []
    var arrCategoryBackup : NSArray = []
    var arrTempSearch : NSArray = []
    var arrayCat:Array<String> = ["All","Technology","Sports","Business","Celeb","CrowdFunding","Finance","Life Style","Music"]
    @IBOutlet weak var pushView: SharePushView!
    

    
    @IBOutlet weak var collectionViewIndex: UICollectionView!
    @IBOutlet weak var searchB: UISearchBar!
    @IBOutlet weak var categoryView:CategoryTableView!
    @IBOutlet weak var scrollView: UIScrollView!

    var didAdjustKeyboardHeight:Bool = false
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IndexViewController.windowNowVisible(_:)),
                                               name: UIWindow.didBecomeKeyNotification,
                                               object: self.view.window)
        
        self.pushView.viewController = self
        self.categoryView.controller = self
        self.setTabbar()
        self.navigationItem.title = "Index"
        collectionViewIndex.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(IndexViewController.reloadIndex), for: UIControl.Event.valueChanged)
        collectionViewIndex.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if( arrCategory.count == 0){
            self.getCategories()
        }
    }
    @objc func windowNowVisible(_ notification:Notification){
        print("Remove Activity Indicator")
        self.hideActivityIndicator()
        //self.activityIndicator.stopAnimating()
    }
    func animateView (){
        self.scrollView.isHidden = false
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            let bounds = self.scrollView.bounds; print(UIScreen.main.bounds);print(bounds)
            let yPosition = bounds.size.height - self.pushView.frame.size.height
            
            self.pushView.frame = CGRect(x: 0.0, y: yPosition, width: self.pushView.frame.size.width, height: self.pushView.frame.size.height)
            
        }, completion: { (finished: Bool) -> Void in
            
            // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
    }
    
    @IBAction func hidePop(_ sender: UIButton) {
           UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.view.endEditing(true)
               let bounds = UIScreen.main.bounds
               let yPosition = bounds.size.height + self.pushView.frame.size.height
               self.pushView.frame = CGRect(x: 0, y: yPosition, width: self.pushView.frame.size.width, height: self.pushView.frame.size.height)
               
           }, completion: { (finished: Bool) -> Void in
               self.scrollView.isHidden = true
               // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
           })
           
           
       }
    @objc func reloadIndex(){
        self.isRefreshing = true
        self.getCategories()
    }
    
     @objc   func keyboardWillShow(notification: Notification) {
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
               print("notification: Keyboard will show")
            if !didAdjustKeyboardHeight{
               
                self.pushView.frame.origin.y -= keyboardSize.height
                didAdjustKeyboardHeight = !didAdjustKeyboardHeight
            }
            
               
           }
           
       }
       
       @objc func keyboardWillHide(notification: Notification) {
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
               
               self.pushView.frame.origin.y += keyboardSize.height
            didAdjustKeyboardHeight = false
               
           }
       }
    func setTabbar() {
        
        self.tabBarItem = UITabBarItem(title: "Index", image: UIImage(named: "indexTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "index-activeTab")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal))
    
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrCategory.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        let imgView = cell.viewWithTag(100) as! UIImageView
        let lblName = cell.viewWithTag(200) as! Label
        
        imgView.contentMode = .scaleAspectFill
        
        if let imgUrlPath = self.arrCategory[indexPath.row]["categoryImage"] as? String {
            if let imgUrl = URL(string: imgUrlPath){
                 let defaultImg = UIImage(named: "PushWoshLogoIcon") // indexUserIcon
                imgView.sd_setImage(with: imgUrl, placeholderImage: defaultImg)
            }
        }
        
        
        
        lblName.text = self.arrCategory[indexPath.row]["categoryName"] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        if(DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS){
            
            return CGSize(width: 85.0 , height: 110.0)
        }
        
        else if(DeviceType.IS_IPHONE_6P){
            
            return CGSize(width: 103.0 , height: 103.0)
        }
        else if(DeviceType.IS_IPHONE_6){
            
            return CGSize(width: 103.0 , height: 103.0)
        }else if(DeviceType.IS_IPHONE_X){
            
            return CGSize(width: 103.0 , height: 103.0)
        }
        else{
            return CGSize(width: 206.0 ,height: 254.0)
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.categoryView.categoryId = Int(self.arrCategory[indexPath.row]["categoryID"] as! String)!
        self.categoryView.getNewsListforIndex()
    }
    func getCategories() {
        
        if !self.isReachable() {
            return
        }
        if(self.isRefreshing == false){
        
            self.showActivityIndicator()
        }
        self.isRefreshing = false
        
        Alamofire.request(baseUrl + "viewCategory")
            .responseJSON { [weak self] response in
                
                if let jsonResponse = response.result.value as? NSDictionary {
                    print("Feeds:\(jsonResponse)")
                    if (jsonResponse["status"] as! String == "SUCCESS") {
                        
                        self?.arrCategory = jsonResponse["data"] as! Array<NSDictionary>
                        self?.arrCategoryBackup =  self?.arrCategory as! NSArray
                        self?.collectionViewIndex.reloadData()
                        
                        // select all category
                        guard self?.arrCategory.isEmpty == false else { return }
                        self?.categoryView.categoryId = Int(self?.arrCategory[0]["categoryID"] as! String)!
                        self?.categoryView.getNewsListforIndex()
                    }
                }
                self?.hideActivityIndicator()
                self?.refreshControl.endRefreshing()
        }
    }
    
    //UISearchBar integration
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // searchActive = false;
        searchBar.showsCancelButton = false
        // self.createDictionaryOfArray(locData as [AnyObject])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.arrCategory = self.arrCategoryBackup.copy() as! NSArray as! Array<NSDictionary>
        self.collectionViewIndex.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // self.createDictionaryOfArray(locData as [AnyObject])
        searchBar.resignFirstResponder()
        
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText != ""){
            let arrTempSearch:NSMutableArray = []
            for friendData in self.arrCategoryBackup{
                let options = NSString.CompareOptions.caseInsensitive; let friendData1 = friendData as! NSDictionary
                let friendTitle = friendData1["categoryName"] as! String
                let found = friendTitle.range(of: searchText, options: options)
                if ((found) != nil) {
                    
                    arrTempSearch.add(friendData)
                }
            }
            
            self.arrCategory = arrTempSearch.copy() as! NSArray as! Array<NSDictionary>
            //print(arrTempSearch)
        }
        else{
            self.arrCategory = arrCategoryBackup.copy() as! NSArray as! Array<NSDictionary>
        }
        
        self.collectionViewIndex.reloadData()
        
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
         self.tabBarController?.tabBar.invalidateIntrinsicContentSize()
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
