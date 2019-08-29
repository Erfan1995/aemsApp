//
//  ReportImage.swift
//  aems
//
//  Created by aems1 aems on 8/26/19.
//  Copyright © 2019 aems aems. All rights reserved.
//

import Foundation

class ReportImage {
    
    static let TABLE_NAME="report_images";
    static let COL_ID="id";
    static let COL_REPORT_ID="report_id";
    static let COL_IMAGE_PATH="image_path"

    var id : Int?
    var report_id : Int?
    var image_path : String?
 
    static let CREATE_TABLE=" CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER PRIMARY KEY AUTOINCREMENT ,\(COL_REPORT_ID) INTEGER , \(COL_IMAGE_PATH) TEXT , FOREIGN KEY ( \(COL_REPORT_ID) ) REFERENCES \(Report.TABLE_NAME) (\(Report.COL_ID)) ON DELETE CASCADE )"
    
}
