//
//  HowToUseViewController.swift
//  PushNote
//
//  Created by Rizwan on 11/6/14.
//  Copyright (c) 2014 com. All rights reserved.
//

import UIKit

class HowToUseViewController: BaseViewController {
    
    @IBOutlet weak var _scrollView: UIScrollView!
    @IBOutlet weak var _pageControl: UIPageControl!
    
    var arrListImages: Array<String>! = []
    var arrListNames: Array<String>! = []
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "ABOUT"
        
        self.arrListImages = ["setting_about", "setting_work", "setting_privacy-policy", "setting_terms-condition"]
        self.arrListNames = ["About", "How It Works", "Privacy Policy", "Terms & Conditions"]
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrListImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) ;
        
        let imageViewBg: UIImageView = cell.contentView.viewWithTag(1000) as! UIImageView
        imageViewBg.image = UIImage(named: self.arrListImages[indexPath.row]);
        
        let lblName: UILabel = cell.contentView.viewWithTag(1001) as! UILabel
        lblName.text = self.arrListNames[indexPath.row]
        
        return cell;
    }
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        let backgroundView : UIView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = UIColor.clear
        cell.backgroundView = backgroundView
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        switch (indexPath.row) {
        case 0:
            let aboutTextViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutTextViewController") as! AboutTextViewController
            aboutTextViewController.myTitle = self.arrListNames[indexPath.row]
            self.navigationController?.pushViewController(aboutTextViewController, animated: true)
            
            break
        case 1:
            let howItWorksViewController = self.storyboard?.instantiateViewController(withIdentifier: "HowItWorksViewController") as! HowItWorksViewController
            self.navigationController?.pushViewController(howItWorksViewController, animated: true)

            break
        case 2:
            let aboutTextViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutTextViewController") as! AboutTextViewController
            aboutTextViewController.myTitle = self.arrListNames[indexPath.row]
            self.navigationController?.pushViewController(aboutTextViewController, animated: true)

            break
        case 3:
            let aboutTextViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutTextViewController") as! AboutTextViewController
            aboutTextViewController.myTitle = self.arrListNames[indexPath.row]
            self.navigationController?.pushViewController(aboutTextViewController, animated: true)

            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
