//
//  Notification.swift
//  aems
//
//  Created by aems aems on 5/22/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import Foundation
import UIKit
class NotificationTab{
    var image: UIImage
    var date : String
    var message : String
    
    init(image: UIImage, date: String, message: String) {
        self.image = image
        self.date = date
        self.message = message
    }
}
