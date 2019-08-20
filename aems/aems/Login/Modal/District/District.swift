//
//  District.swift
//  aems
//
//  Created by aems1 aems on 5/27/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class District {

    
    static let TABLE_NAME="districts";
    static let COL_ID="district_id";
    static let COL_PROVINCE_ID="province_id";
    static let COL_NAME="name";

    var district_id:Int?
    var province_id:Int?
    var name:String?

    static let CREATE_TABLE=" CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER ,\(COL_PROVINCE_ID) INTEGER , \(COL_NAME) TEXT ); "
    
    init(district_id:Int,province_id:Int,name:String) {
        self.district_id=district_id
        self.province_id=province_id
        self.name=name
    }
    

}
