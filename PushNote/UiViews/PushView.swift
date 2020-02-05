//
//  PushView.swift
//  PushNote
//
//  Created by Danish Ghauri on 07/03/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit

class PushView: UIView {
    
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var viewLoader: UIView!
    class func instanceFromNib() -> PushView {
        
        let pushView = UINib(nibName: "PushView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PushView
        var frame = pushView.frame
        
        frame.size.width = UIScreen.main.bounds.size.width
        frame.size.height = UIScreen.main.bounds.size.height
        
        pushView.frame = frame
        return pushView
        
        
    }
    
    func animateView (){
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            
            self.viewLoader.frame = CGRect(x: 0.0, y: +150, width: self.viewLoader.frame.size.width, height: self.viewLoader.frame.size.height)
            
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
    }
    
    @IBAction func actionCancel(_ sender: AnyObject) {
        self.removeFromSuperview()
    }
}
