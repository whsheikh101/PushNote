//
//  UITextFieldExtensions.swift
//  PushNote
//
//  Created by Waqas Haider Sheikh on 09/02/2020.
//  Copyright © 2020 Ihsan Bhatti. All rights reserved.
//

import Foundation
import  UIKit

extension UITextField {
    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
}
