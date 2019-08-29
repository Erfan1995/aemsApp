//
//  SentReportTableViewCell.swift
//  aems
//
//  Created by aems aems on 6/5/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class SentReportTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    
    func setSentReports(sentReport: DraftAndSentReportContent)
    {
        iconImage.image = #imageLiteral(resourceName: "station_image")
        locationName.text = sentReport.locationName
    }

}
