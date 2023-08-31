//
//  UIView Extension.swift
//  FoodieFy
//
//  Created by Siarhei Anoshka on 21.08.23.
//

import UIKit

extension UIView {
   @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
