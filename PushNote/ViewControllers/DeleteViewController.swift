//
//  DeleteViewController.swift
//  PushNote
//
//  Created by Khurram Iqbal on 26/02/2020.
//  Copyright © 2020 Ihsan Bhatti. All rights reserved.
//

import UIKit

class DeleteViewController: UIViewController {
    var cancelButtonPressed:(()->Void)?
    var yesButtonPressed:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func yesButtonPressed(_ sender: Any){
        self.yesButtonPressed?()
    }
    
    @IBAction func noButtonPressed(_ sender: Any){
        self.cancelButtonPressed?()
    }

}
