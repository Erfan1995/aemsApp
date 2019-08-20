//
//  GeneralActivities.swift
//  aems
//
//  Created by aems aems on 5/26/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import Foundation
import UIKit
class GeneralActivities: UITextFieldDelegate {
    func hideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
    }
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
}
