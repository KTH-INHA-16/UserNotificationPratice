//
//  UIButton.swift
//  UserNotification
//
//  Created by Nick on 2022/02/22.
//

import UIKit

@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let borderColor = newValue else {
                return
            }
            layer.borderColor = borderColor.cgColor
        }
        get {
            guard let borderColor = layer.borderColor else {
                return nil
            }
            
            return UIColor(cgColor: borderColor)
        }
    }
}
