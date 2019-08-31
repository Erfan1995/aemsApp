//
//  HideKeyboardExtension.swift
//  aems
//
//  Created by aems aems on 6/8/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
}
