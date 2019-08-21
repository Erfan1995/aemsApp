//
//  AppDatabase.swift
//  aems
//
//  Created by aems1 aems on 5/27/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class AppDatabase: NSObject {
    
    static let DOMAIN_ADDRESS="http://18.214.22.234:3000";
    //public static final String DOMAIN_ADDRESS="http://192.168.43.175:3000";

    
    override init() {
        do{
            super.init()
     
            let database = openDatabase()
            if (database!.open()) {
                do{
                    try database!.executeUpdate(Candidate.CREATE_TABLE , values: nil)
                    try database!.executeUpdate(Province.CREATE_TABLE, values: nil)
                    try database!.executeUpdate(District.CREATE_TABLE, values: nil)
                    try database!.executeUpdate(PollingCenter.CREATE_TABLE, values: nil)
                    try database!.executeUpdate(Report.CREATE_TABLE, values: nil)
                }catch{
                    print( error)
                }
            }
        }
    }
    
    
    
    
    func openDatabase() -> FMDatabase?{
        
        do{
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirectory.appendingPathComponent("aems").appendingPathExtension("sqlite")
        return FMDatabase(path: fileUrl.absoluteString)
        }
        catch{
            return nil
        }
    }
    
    
    
    func insertCandidates(candidate:Array<Candidate>) -> Bool {
        let con = openDatabase()
        con!.open()
        for can:Candidate in candidate{
            let insertStatment = " INSERT INTO  \(Candidate.TABLE_NAME) ( \(Candidate.COL_ID),\(Candidate.COL_NAME) ) VALUES ( 10, '\(can.candidate_name)' );"
            do{
                try con!.executeUpdate(insertStatment, values: nil)
            }catch{
                print( error)
            }
        }
        con!.close()
        return true
    }
    
    
    
    func getCandidates() -> Array<Candidate> {
        let con = openDatabase()
        con!.open()
        var candidateLists : Array<Candidate> = Array()
            let selectStatment = "SELECT * FROM \(Candidate.TABLE_NAME) "
            let fmresult = con!.executeQuery(selectStatment, withParameterDictionary: nil)
            while fmresult!.next()
                {
                    let id = fmresult!.int(forColumn: "\(Candidate.COL_ID)")
                    let title = fmresult?.string(forColumn: "\(Candidate.COL_NAME)")
                    let candidate : Candidate = Candidate(election_no: id, candidate_name: title)
                    candidateLists.append(candidate)
                }
        if con!.isOpen{
            con!.close()
        }
        return candidateLists
    }
    
    
    
    func downloadFileFromServer(condidates : Array<Candidate> = Array(),provinces : Array<Province> = Array(),districts : Array<District> = Array(),centers : Array<PollingCenter> = Array())  {
        insertCandidates(candidate: condidates)
    }

}
