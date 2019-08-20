//
//  LoginData.swift
//  aems
//
//  Created by aems1 aems on 8/19/19.
//  Copyright © 2019 aems aems. All rights reserved.
//

import UIKit

class LoginData: Codable {
    var complete_name : String
    var observer_id : Int
    var polling_center_id : Int
    var province_id : Int
    var token : String
    var pc_amount_of_vote : Int
    
    init(complete_name:String,observer_id:Int,polling_center_id:Int,province_id:Int,token:String,pc_amount_of_vote:Int) {
        self.complete_name=complete_name
        self.observer_id=observer_id
        self.polling_center_id=polling_center_id
        self.province_id=province_id
        self.token=token
        self.pc_amount_of_vote=pc_amount_of_vote
    }
}
