//
//  Report.swift
//  aems
//
//  Created by aems1 aems on 5/27/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class Report {
    
    static let TABLE_NAME="reports";
    static let COL_ID="id";
    static let COL_POLLING_CENTER="polling_center_id";
    static let COL_OBSERVER_ID="observer_id";
    static let COL_VOID_VOTE="void_vote";
    static let COL_WHITE_VOTE="white_vote";
    static let COL_RIGHT_VOTE="right_vote";
    static let COL_DATE_TIME="date_time";
    static let COL_LATITUDE="latitude";
    static let COL_LONGITUDE="longitude";
    static let COL_IS_SENT="is_sent";
    static let COL_PROVINCE_ID="province_id";
    
    
    var id:Int?
    var polling_center_id:Int?
    var observer_id:Int?
    var void_vote:Int?
    var white_vote:Int?
    var right_vote:Int?
    var province_id:Int?
    var date_time:String?
    var latitude:Double?
    var longitude:Double?
    var is_sent:Bool?;
    
    static let CREATE_TABLE=" CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER PRIMARY KEY AUTOINCREMENT ,\(COL_POLLING_CENTER) INTEGER , \(COL_OBSERVER_ID) INTEGER , \(COL_VOID_VOTE) INTEGER , \(COL_WHITE_VOTE) INTEGER ,\(COL_RIGHT_VOTE) INTEGER , \(COL_DATE_TIME) TIMESTAMP , \(COL_LATITUDE) DOUBLE , \(COL_LONGITUDE) DOUBLE , \(COL_PROVINCE_ID) INTEGER , \(COL_IS_SENT) BOOLEAN DEFAULT FALSE ); "


}
