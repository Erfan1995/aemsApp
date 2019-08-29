//
//  sentReportDetailsViewController.swift
//  aems
//
//  Created by aems aems on 6/5/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class sentReportDetailsViewController: UIViewController {
    @IBOutlet weak var locationName: UILabel!
    var locName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        locationName.text = locName
    }
 

}
