//
//  TextfieldShowBottomSingleLine.swift
//  aems
//
//  Created by aems aems on 6/9/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import Foundation
import UIKit
extension UITextField {
    func setBottomBorderOnlyWith(color: CGColor) {
        self.borderStyle = .none
        self.layer.masksToBounds = false
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
