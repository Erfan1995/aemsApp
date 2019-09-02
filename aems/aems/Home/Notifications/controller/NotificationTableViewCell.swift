//
//  NotificationTableViewCell.swift
//  aems
//
//  Created by aems aems on 5/22/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageText: UILabel!
    
    func setNotification (notification: NotificationTab){
        userImage.image = notification.image
        dateLabel.text = notification.date
        messageText.text = notification.message
    }

}
