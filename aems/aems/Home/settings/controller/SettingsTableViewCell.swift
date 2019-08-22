//
//  SettingsTableViewCell.swift
//  aems
//
//  Created by aems aems on 5/29/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var forwardIcon: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
   
    func setSettings (settings: SettingsContent){
        settingNameLabel.text = settings.settingName
        forwardIcon.image =  settings.forwardIcon
        iconImage.image = settings.contentIcon
    }
}
