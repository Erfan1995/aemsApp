//
//  ReportCondidates.swift
//  aems
//
//  Created by aems1 aems on 8/26/19.
//  Copyright © 2019 aems aems. All rights reserved.
//

import Foundation


class ReportCondidates {
    
    static let TABLE_NAME="report_candidates";
    static let COL_ID="id";
    static let COL_CONDIDATE_NUMBER="candidate_number";
    static let COL_NUMBER_OF_VOTE="number_of_vote"
    static let COL_REPORT_ID="report_id";
    
    
    var id:Int?
    var candidate_number:Int?
    var number_of_vote:Int?
    var report_id:Int?
    
    
    static let CREATE_TABLE=" CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER PRIMARY KEY AUTOINCREMENT ,\(COL_REPORT_ID) INTEGER , \(COL_NUMBER_OF_VOTE) INTEGER , \(COL_CONDIDATE_NUMBER) INTEGER , FOREIGN KEY ( \(COL_REPORT_ID) ) REFERENCES \(Report.TABLE_NAME) (\(Report.COL_ID)) ON DELETE CASCADE ); "
    
}
