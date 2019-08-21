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
    let DISTRICT_USER_DEFAULT="district_user_default"

    var district_id:Int32?
    var province_id:Int32?
    var name:String?

    static let CREATE_TABLE=" CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER ,\(COL_PROVINCE_ID) INTEGER , \(COL_NAME) TEXT ); "
    
    init(district_id:Int32,province_id:Int32,name:String) {
        self.district_id=district_id
        self.province_id=province_id
        self.name=name
    }
    
    init(district_id:Int32,name:String) {
        self.district_id=district_id
        self.name=name
    }
    
    init() {
        
    }
    
    func setDistrictUserDefault(uploaded:Bool)  {
        let defaults = UserDefaults.standard
        defaults.set(uploaded, forKey: DISTRICT_USER_DEFAULT)
    }
    
    func getDistrictUserDefault() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: DISTRICT_USER_DEFAULT)
    }
    

}
