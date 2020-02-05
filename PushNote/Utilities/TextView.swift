//
//  TextView.swift
//  PushNote
//
//  Created by Danish Ghauri on 13/03/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import UIKit

class TextView: UITextView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.baseInit()
        
    }
    
    func baseInit() {
        
        let fontName = self.font!.fontName
        var fontSize = self.font!.pointSize
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad){
            
            fontSize = fontSize * IPAD_SCALING_FACTOR
            
            self.font = UIFont(name: fontName, size: fontSize)
        }
        
    }
}
