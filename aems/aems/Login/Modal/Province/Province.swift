//
//  Province.swift
//  aems
//
//  Created by aems1 aems on 5/27/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class Province {
    
    static let TABLE_NAME="provinces"
    static let COL_ID="province_id"
    static let  COL_NAME="name"
    let PROVINCE_USER_DEFAULT="province_user_default"
    
    var province_id : Int32?
    var name : String?
    
    static let CREATE_TABLE=" CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER , \(COL_NAME) TEXT ); "
    
    init(province_id:Int32?,name:String?) {
        self.province_id=province_id
        self.name=name
    }
    
    func setProvinceUserDefault(uploaded:Bool)  {
        let defaults = UserDefaults.standard
        defaults.set(uploaded, forKey: PROVINCE_USER_DEFAULT)
    }
    
    func getProvinceUserDefault() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: PROVINCE_USER_DEFAULT)
    }
    
    init() {
        
    }

}
