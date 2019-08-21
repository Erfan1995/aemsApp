//
//  SettingsContent.swift
//  aems
//
//  Created by aems aems on 5/29/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import Foundation
import UIKit
class SettingsContent{
    var contentIcon : UIImage
    var settingName: String
    var forwardIcon: UIImage
    
    init(contentIcon: UIImage, settingName: String, forwardIcon: UIImage) {
        self.contentIcon = contentIcon
        self.settingName = settingName
        self.forwardIcon = forwardIcon
    }
}
