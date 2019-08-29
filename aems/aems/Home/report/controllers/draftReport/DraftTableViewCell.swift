//
//  DraftTableViewCell.swift
//  aems
//
//  Created by aems aems on 6/5/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class DraftTableViewCell: UITableViewCell {

    @IBOutlet weak var draftImage: UIImageView!
    @IBOutlet weak var locationName: UILabel!
    
    func setDraftReports(draftReport: DraftAndSentReportContent){
        draftImage.image = #imageLiteral(resourceName: "station_image")
        locationName.text = draftReport.locationName
        
    }

}
