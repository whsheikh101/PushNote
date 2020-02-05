//
//  Button.swift
//  PushNote
//
//  Created by Danish Ghauri on 27/02/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit

class Button: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
    
        super.init(frame: frame)
        
        self.baseInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.baseInit()

    }
    
    func baseInit() {
        
        let fontName = self.titleLabel?.font.fontName
        var fontSize = self.titleLabel?.font.pointSize
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad){
            
            fontSize = fontSize! * IPAD_SCALING_FACTOR
            
            self.titleLabel?.font = UIFont(name: fontName!, size: fontSize!)
        }

    }
}
