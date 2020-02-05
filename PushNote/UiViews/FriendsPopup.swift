
//
//  FriendsPopup.swift
//  PushNote
//
//  Created by Danish Ghauri on 10/03/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit

class FriendsPopup: UIView,UITextViewDelegate{

    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var txtViewMsg: UITextView!
    class func instanceFromNib() -> FriendsPopup {
        
        let pushView = UINib(nibName: "FriendsPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FriendsPopup
        
        var frame = pushView.frame
        frame.size.width = UIScreen.main.bounds.size.width
        frame.size.height = UIScreen.main.bounds.size.height
        
        pushView.frame = frame
        return pushView
        
    }
    
    func animateView() {
        
        
        //self.viewPopup.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.viewPopup.transform = CGAffineTransform(a: self.viewPopup.transform.a/2.0, b: 0, c: 0, d: 1, tx: self.frame.size.width, ty: 0);
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            
            self.viewPopup.transform = CGAffineTransform.identity;
            
            }, completion: { (finished: Bool) -> Void in
                
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
      
        self.txtViewMsg.becomeFirstResponder()
    }
    
    func closeAnimate (){
        
        self.viewPopup.transform = CGAffineTransform.identity;

        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions(), animations: { () -> Void in
            
           // self.viewPopup.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.viewPopup.transform = CGAffineTransform(a: self.viewPopup.transform.a/2.0, b: 0, c: 0, d: 1, tx: self.frame.size.width, ty: 0);
            
            }, completion: { (finished: Bool) -> Void in
                self.removeFromSuperview()
                // you can do this in a shorter, more concise way by setting the value to its opposite, NOT value
        })
        self.txtViewMsg.resignFirstResponder()

    }
    
    @IBAction func actionClose(_ sender: AnyObject) {

        self.closeAnimate()
    }
    
    @IBAction func actionLocation(_ sender: AnyObject) {
    }
    
    @IBAction func actionSend(_ sender: AnyObject) {
        self.closeAnimate()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView){
        
        textView.text = ""
        
    }
}
