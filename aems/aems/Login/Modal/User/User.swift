//
//  User.swift
//  aems
//
//  Created by aems1 aems on 5/27/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class User {

    let COL_USER_ID="id";
    let COL_COMPLETE_NAME="complete_name";
    let COL_OBSERVER_CODE="observer_code";
    let COL_PHONE="phone";
    let COL_PASSWORD="password";
    let COL_POLLING_CENTER_ID="polling_center_id";
    

    let LOGIN_USER_DEFAULT="login_user_default";
    let SHARED_PREFRENCE_PASSWORD="password_shared_preference";
    let SHARED_PASSWORD="password";
    
    
    
    var id : Int?
    var complete_name : String?
    var observer_code : String?
    var phone : String?
    var password : String?
    var polling_center_id : Int32?
    init(id:Int? , complete_name:String?,observer_code:String?,phone:String?,password:String?,polling_center_id:Int32?) {
        self.id=id
        self.complete_name=complete_name
        self.observer_code=observer_code
        self.phone=phone
        self.password=password
        self.polling_center_id=polling_center_id
    }
    
    init() {
    
    }
    
    
    
    func setLoginUserDefault(loginData : LoginData)  {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(loginData) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: LOGIN_USER_DEFAULT)
        }
    }

    
     func getLoginUserDefault() -> LoginData? {
        var loginData : LoginData? = nil
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: LOGIN_USER_DEFAULT) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(LoginData.self, from: savedPerson) {
                loginData = LoginData(complete_name: loadedPerson.complete_name, observer_id: loadedPerson.observer_id, polling_center_id: loadedPerson.polling_center_id, province_id: loadedPerson.province_id, token: loadedPerson.token, pc_amount_of_vote: loadedPerson.pc_amount_of_vote)
            }
        }
        return loginData
    }
    
}
