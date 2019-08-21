//
//  Candidate.swift
//  aems
//
//  Created by aems1 aems on 5/27/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class Candidate {
    static let TABLE_NAME = "candidates"
    static let COL_ID = "election_no"
    static let COL_NAME = "candidate_name"
    let CONDIDATE_USER_DEFAULT="condidate_user_default"

    var election_no : Int32?
    var candidate_name : String?

    static let CREATE_TABLE = "CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER , \(COL_NAME) TEXT);"

    init(election_no:Int32?,candidate_name:String?) {
        self.election_no=election_no
        self.candidate_name=candidate_name
    }

    init() {
    }
    
    
    func setCondidateUserDefault(uploaded:Bool)  {
        let defaults = UserDefaults.standard
        defaults.set(uploaded, forKey: CONDIDATE_USER_DEFAULT)
    }
    
    func getCondidateUserDefault() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: CONDIDATE_USER_DEFAULT)
    }
    

}
