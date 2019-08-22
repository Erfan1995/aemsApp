//
//  Helper.swift
//  aems
//
//  Created by aems1 aems on 8/22/19.
//  Copyright © 2019 aems aems. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

class Helper {
    static func  showSnackBar(messageString:String) {
        let message=MDCSnackbarMessage()
        message.text = messageString
        MDCSnackbarManager.show(message)
    }
    
}
