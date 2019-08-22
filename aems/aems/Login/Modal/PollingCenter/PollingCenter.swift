//
//  PollingCenter.swift
//  aems
//
//  Created by aems1 aems on 5/27/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class PollingCenter {
    
    static let TABLE_NAME="polling_centers";
    static let COL_ID="polling_center_id";
    static let COL_DISTRICT_ID="district_id";
    static let POLLING_CENTER_CODE="polling_center_code";
    let POLLING_CENTER_USER_DEFAULT="polling_center_user_default"
    
    var polling_center_id:Int32?
    var polling_center_code:String?
    var district_id:Int32?
    
    static let CREATE_TABLE=" CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER , \(COL_DISTRICT_ID) INTEGER , \(POLLING_CENTER_CODE) INTEGER ); "

    init(polling_center_id:Int32,polling_center_code:String,district_id:Int32) {
        self.polling_center_id=polling_center_id
        self.polling_center_code=polling_center_code
        self.district_id=district_id
    }
    
    init(polling_center_id:Int32,polling_center_code:String) {
        self.polling_center_id=polling_center_id
        self.polling_center_code=polling_center_code
    }
    
    init() {
        
    }
    
    func setPollingCenterUserDefault(uploaded:Bool)  {
        let defaults = UserDefaults.standard
        defaults.set(uploaded, forKey: POLLING_CENTER_USER_DEFAULT)
    }
    
    func getPollingCenterUserDefault() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: POLLING_CENTER_USER_DEFAULT)
    }

}
