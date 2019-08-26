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
    //static let DOMAIN_ADDRESS="http://192.168.43.175:3000";
    
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
                    try database!.executeUpdate(ReportCondidates.TABLE_NAME, values: nil)
                    try database!.executeUpdate(ReportImage.TABLE_NAME, values: nil)
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
    
    
    
    func insertCandidates(candidate:Array<Candidate>) {
        
        let con = openDatabase()
        con!.open()
        var isFirst : Bool = true
        var values : String = ""
        for can:Candidate in candidate{
            if isFirst {
             values = " ( \(can.election_no ?? 0), '\(can.candidate_name!)' )"
               isFirst=false
            }
            else{
             values += " , ( \(can.election_no ?? 0), '\(can.candidate_name!)' )"
            }
        }
        let insertStatment = " INSERT INTO  \(Candidate.TABLE_NAME) ( \(Candidate.COL_ID),\(Candidate.COL_NAME) ) VALUES \(values);"
        do{
            try con!.executeUpdate(insertStatment, values: nil)
            Candidate().setCondidateUserDefault(uploaded: true)
        }catch{
            print( error)
            print("condidate insertion field ")
        }
        con!.close()
    }
    
    
    func insertProvinces(provinces:Array<Province>) {
        let con = openDatabase()
        con!.open()
        var isFists : Bool = true
        var values : String = ""
        for can:Province in provinces{
            if isFists {
                values = " ( \(can.province_id ?? 0), '\(can.name!)' )"
                isFists=false
            }
            else{
                values += " , ( \(can.province_id ?? 0), '\(can.name!)' )"
            }
        }
        let insertStatment = " INSERT INTO  \(Province.TABLE_NAME) ( \(Province.COL_ID),\(Province.COL_NAME) ) VALUES \(values);"
        do{
            print(insertStatment)
            try con!.executeUpdate(insertStatment, values: nil)
            Province().setProvinceUserDefault(uploaded: true)
            
        }catch{
            print( error)
            print("province insertion field ")
        }
        con!.close()
    }
    
    
    
    func insertDistricts(districts:Array<District>) {
        let con = openDatabase()
        con!.open()
        var isFirst : Bool = true
        var values : String = ""
        for can:District in districts{
            if  isFirst {
                values = " ( \(can.district_id ?? 0),\(can.province_id ?? 0) , '\(can.name!)' )"
                isFirst=false
            }
            else{
                values += " , ( \(can.district_id ?? 0),\(can.province_id ?? 0) , '\(can.name!)' )"
            }
        }
        let insertStatment = " INSERT INTO  \(District.TABLE_NAME) ( \(District.COL_ID),\(District.COL_PROVINCE_ID),\(District.COL_NAME) ) VALUES \(values);"
        do{
            try con!.executeUpdate(insertStatment, values: nil)
            District().setDistrictUserDefault(uploaded: true)
        }catch{
            print( error)
            print("district insertion field ")
        }
        con!.close()
    }
    
    
    
    func insertPollingCenters(centers:Array<PollingCenter>) {
        let con = openDatabase()
        con!.open()
        var isFirst : Bool = true
        var values : String = ""
        for can:PollingCenter in centers{
            if  isFirst {
                values = " ( \(can.polling_center_id ?? 0),\(can.district_id ?? 0) , '\(can.polling_center_code!)' )"
                isFirst=false
            }
            else{
                values += " , ( \(can.polling_center_id ?? 0),\(can.district_id ?? 0) , '\(can.polling_center_code!)' )"
            }
        }
        let insertStatment = " INSERT INTO  \(PollingCenter.TABLE_NAME) ( \(PollingCenter.COL_ID),\(PollingCenter.COL_DISTRICT_ID),\(PollingCenter.POLLING_CENTER_CODE) ) VALUES \(values);"
        do{
            try con!.executeUpdate(insertStatment, values: nil)
            PollingCenter().setPollingCenterUserDefault(uploaded: true)
        }catch{
            print( error)
            print("polling center insertion field ")
        }
        con!.close()
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
    
    
    func getProvinces() -> Array<Province> {
        let con = openDatabase()
        con!.open()
        var provinceLists : Array<Province> = Array()
        let selectStatment = "SELECT * FROM \(Province.TABLE_NAME) "
        let fmresult = con!.executeQuery(selectStatment, withParameterDictionary: nil)
        while fmresult!.next()
        {
            let id = fmresult!.int(forColumn: "\(Province.COL_ID)")
            let title = fmresult?.string(forColumn: "\(Province.COL_NAME)")
            let province : Province = Province(province_id: id, name: title)
            provinceLists.append(province)
        }
        if con!.isOpen{
            con!.close()
        }
        return provinceLists
    }
    
    
    func getDistrict(province_id : Int32) -> Array<District> {
        let con = openDatabase()
        con!.open()
        var districtLists : Array<District> = Array()
        let selectStatment = "SELECT * FROM \(District.TABLE_NAME) WHERE \(District.COL_PROVINCE_ID) = '\(province_id)' "
        let fmresult = con!.executeQuery(selectStatment, withParameterDictionary: nil)
        while fmresult!.next()
        {
            let id = fmresult!.int(forColumn: "\(District.COL_ID)")
            let title = fmresult?.string(forColumn: "\(District.COL_NAME)")
            let district : District = District(district_id: id, name: title!)
            districtLists.append(district)
    
        }
        if con!.isOpen{
            con!.close()
        }
        return districtLists
    }
    
    
    func getPollingCenters(district_id : Int32) -> Array<PollingCenter> {
        let con = openDatabase()
        con!.open()
        var pollingCenterLists : Array<PollingCenter> = Array()
        let selectStatment = "SELECT * FROM \(PollingCenter.TABLE_NAME) WHERE \(PollingCenter.COL_DISTRICT_ID) = '\(district_id)' "
        let fmresult = con!.executeQuery(selectStatment, withParameterDictionary: nil)
        while fmresult!.next()
        {
            let id = fmresult!.int(forColumn: "\(PollingCenter.COL_ID)")
            let title = fmresult?.string(forColumn: "\(PollingCenter.POLLING_CENTER_CODE)")
            let pollingCenter : PollingCenter = PollingCenter(polling_center_id: id, polling_center_code: title!)
            pollingCenterLists.append(pollingCenter)
        }
        if con!.isOpen{
            con!.close()
        }
        return pollingCenterLists
    }
    
    
    func downloadFileFromServer(condidates : Array<Candidate> = Array(),provinces : Array<Province> = Array(),districts : Array<District> = Array(),centers : Array<PollingCenter> = Array())  {
        if  !Candidate().getCondidateUserDefault(){
            insertCandidates(candidate: condidates)
        }
        
        if !Province().getProvinceUserDefault() {
            insertProvinces(provinces: provinces)
        }
        
        if !District().getDistrictUserDefault() {
            insertDistricts(districts: districts)
        }
        
        if !PollingCenter().getPollingCenterUserDefault() {
            insertPollingCenters(centers: centers)
        }
    }
    
    
}
