//
//  CustomTableCell.swift
//  PushNote
//
//  Created by Bhatti on 27/03/2016.
//  Copyright © 2016 Danish Ghauri. All rights reserved.
//

import Foundation
import UIKit
class CustomTableCell: UITableViewCell {
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var contactPhone: Label!
    @IBOutlet weak var contactName: Label!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var unblockBtn: UIButton!
    
    
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
    }
    
}
