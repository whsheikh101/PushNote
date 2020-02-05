//
//  PushDetailsViewController.swift
//  PushNote
//
//  Created by Danish Ghauri on 06/03/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit

class PushDetailsViewController: BaseViewController {

    @IBOutlet weak var webViewDetails: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackBtn()
        
        self.title = "Forbes"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        webViewDetails.loadRequest(URLRequest(url: URL(string: "http://www.forbes.com/sites/luisakroll/2016/03/01/forbes-2016-worlds-billionaires-meet-the-richest-people-on-the-planet/#93ddd2f41cbf")!))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.isHidden = false
    }

    //MARK: IBActions
    var newBtn : UIButton = UIButton();
    @IBAction func actionShare(_ sender: AnyObject) {
         self.newBtn = sender as! UIButton
        let shareContent:String = "http://www.forbes.com/sites/luisakroll/2016/03/01/forbes-2016-worlds-billionaires-meet-the-richest-people-on-the-planet/#93ddd2f41cbf"
        
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad{
            activityViewController.popoverPresentationController!.sourceView = self.newBtn;
            activityViewController.popoverPresentationController!.permittedArrowDirections    = .right
            activityViewController.popoverPresentationController?.sourceRect = self.newBtn.bounds
        }
        present(activityViewController, animated: true, completion: {})
    }
    
    @IBAction func actionPush(_ sender: AnyObject) {
        
        let pushView:PushView = PushView.instanceFromNib()
        pushView.animateView()
        self.view.addSubview(pushView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
