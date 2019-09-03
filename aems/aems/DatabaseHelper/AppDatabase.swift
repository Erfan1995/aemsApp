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
    //static let DOMAIN_ADDRESS="http://192.168.20.245:3000";

    
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
                    try database!.executeUpdate(ReportCondidates.CREATE_TABLE, values: nil)
                    try database!.executeUpdate(ReportImage.CREATE_TABLE, values: nil)
                    
                }catch{
                    print( " TABLE INSERTION ERROR \(error) ")
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
    
    
    func getReport(station_id:Int) -> Report?{
        let con = openDatabase()
        con!.open()
        var report : Report?
        let selectStatment = "SELECT * FROM \(Report.TABLE_NAME) WHERE \(Report.COL_STATION)='\(station_id)'"
        let fmresult = con!.executeQuery(selectStatment, withParameterDictionary: nil)
        while fmresult!.next()
        {
            let id = fmresult!.int(forColumn: "\(Report.COL_ID)")
            let polling_center_id = fmresult!.int(forColumn: "\(Report.COL_POLLING_CENTER)")
            let station_id = fmresult!.int(forColumn: "\(Report.COL_STATION)")
            let observer_id = fmresult!.int(forColumn: "\(Report.COL_OBSERVER_ID)")
            let void_vote = fmresult!.int(forColumn: "\(Report.COL_VOID_VOTE)")
            let white_vote = fmresult!.int(forColumn: "\(Report.COL_WHITE_VOTE)")
            let right_vote = fmresult!.int(forColumn: "\(Report.COL_RIGHT_VOTE)")
            let date_time = fmresult!.string(forColumn: "\(Report.COL_DATE_TIME)")
            let latitude = fmresult!.double(forColumn: "\(Report.COL_LATITUDE)")
            let longitude = fmresult!.double(forColumn: "\(Report.COL_LONGITUDE)")
            let province_id = fmresult!.int(forColumn: "\(Report.COL_PROVINCE_ID)")
            report = Report(id:Int(id),latitude: latitude, longitude: longitude, observer_id: Int(observer_id), void_vote: Int(void_vote), white_vote:Int(white_vote), right_vote: Int(right_vote), province_id: Int(province_id), polling_center_id: Int(polling_center_id), pc_station_nummber: Int(station_id), date_time: date_time)
        }
        if con!.isOpen{
            con!.close()
        }
        return report
    }
    
    
    func getCandidateReport(report_id:Int) -> [[Int]] {
        let con = openDatabase()
        con!.open()
         var candidateArray = Array(repeating: Array(repeating: 0, count: 2), count: 19)
        let selectStatment = "SELECT * FROM \(ReportCondidates.TABLE_NAME) WHERE \(ReportCondidates.COL_REPORT_ID)='\(report_id)'"
        let fmresult = con!.executeQuery(selectStatment, withParameterDictionary: nil)
        while fmresult!.next()
        {
            
            let number_of_vote = fmresult!.int(forColumn: "\(ReportCondidates.COL_NUMBER_OF_VOTE)")
            let candidate_number = fmresult!.int(forColumn: "\(ReportCondidates.COL_CONDIDATE_NUMBER)")
            candidateArray[Int(candidate_number)][0]=Int(candidate_number)
            candidateArray[Int(candidate_number)][1]=Int(number_of_vote)
        }
        if con!.isOpen{
            con!.close()
        }
        return candidateArray
    }
    
    
    func getImageReport(report_id:Int) -> Array<String> {
        let con = openDatabase()
        con!.open()
        var images : Array<String> = Array()
        let selectStatment = "SELECT * FROM \(ReportImage.TABLE_NAME) WHERE \(ReportImage.COL_REPORT_ID)='\(report_id)'"
        let fmresult = con!.executeQuery(selectStatment, withParameterDictionary: nil)
        while fmresult!.next()
        {
            let image_path = fmresult!.string(forColumn: "\(ReportImage.COL_IMAGE_PATH)")
            images.append(image_path!)
        }
        if con!.isOpen{
            con!.close()
        }
        return images
    }
    
    
    func isSentReport(station_id:Int) -> Bool {
        
        let con = openDatabase()
        con!.open()
        var result=false
        var reportLists : Array<Report> = Array()
        let selectStatment = "SELECT * FROM \(Report.TABLE_NAME) WHERE \(Report.COL_STATION)='\(station_id)' AND \(Report.COL_IS_SENT)='1'"
        let fmresult = con!.executeQuery(selectStatment, withParameterDictionary: nil)
        while fmresult!.next(){
            result=true
        }
        if con!.isOpen{
            con!.close()
        }
        return result
    }
    
    
    func deleteReport(station_id:Int) {
        
        let con = openDatabase()
        con!.open()
        var sqlStatement = "DELETE FROM \(Report.TABLE_NAME) WHERE \(Report.COL_STATION) ='\(station_id)'"
        do{
            try con!.executeUpdate(sqlStatement, values: nil)
            print("successfuly deleted ")
        }catch{
            
            print("problem in deletion")
            print( error)
        }
        if con!.isOpen{
            con!.close()
        }
   
    }
    
    
    func getDraftOrSentReports(isSent:Int) -> Array<Int> {
        let con = openDatabase()
        con!.open()
        var reportLists : Array<Int> = Array()
        let selectStatment = "SELECT \(Report.COL_STATION) FROM \(Report.TABLE_NAME) WHERE \(Report.COL_IS_SENT)='\(isSent)' "
        let fmresult = con!.executeQuery(selectStatment, withParameterDictionary: nil)
        while fmresult!.next()
        {
            let station_id = fmresult!.int(forColumn: "\(Report.COL_STATION)")
            reportLists.append(Int(station_id))
        }
        if con!.isOpen{
            con!.close()
        }
        return reportLists
    }
    
    
    
    func getLastReportId(con:FMDatabase) -> Int32 {
        var id : Int32 = 0
        let selectStatment = "SELECT \(Report.COL_ID) FROM \(Report.TABLE_NAME) WHERE \(Report.COL_ID) = (SELECT MAX(\(Report.COL_ID))  FROM \(Report.TABLE_NAME) )"
        let fmresult = con.executeQuery(selectStatment, withParameterDictionary: nil)
        while fmresult!.next()
        {
            id = fmresult!.int(forColumn: "\(Report.COL_ID)")
        }
        return id
    }
    
    
 
    
    func storeFileToLocal(files : Array<ImageFile>,report:Report,candidatesVote: [[Int]]) {
        let con = openDatabase()
        con!.open()

        let insertStatment = " INSERT INTO  \(Report.TABLE_NAME) ( \(Report.COL_POLLING_CENTER),\(Report.COL_STATION),\(Report.COL_OBSERVER_ID),\(Report.COL_VOID_VOTE),\(Report.COL_WHITE_VOTE),\(Report.COL_RIGHT_VOTE),\(Report.COL_DATE_TIME),\(Report.COL_LATITUDE),\(Report.COL_LONGITUDE),\(Report.COL_IS_SENT),\(Report.COL_PROVINCE_ID) ) VALUES ( \(report.polling_center_id!),\(report.pc_station_number!),\(report.observer_id!),\(report.void_vote!),\(report.white_vote!),\(report.right_vote!),'\(report.date_time!)',\(report.latitude!),\(report.longitude!),\(report.is_sent!),\(report.province_id!) );"
        
        do{
            try con!.executeUpdate(insertStatment, values: nil)
            var report_id=getLastReportId(con: con!)
            
            
            for file in files{
                let fileInsertStatment = " INSERT INTO  \(ReportImage.TABLE_NAME) ( \(ReportImage.COL_IMAGE_PATH),\(ReportImage.COL_REPORT_ID)) VALUES ( '\(file.fileName!)',\(report_id));"
                try con!.executeUpdate(fileInsertStatment, values: nil)
            }
            
            
            for candidate in candidatesVote{
                let candidateInsertStatment = " INSERT INTO  \(ReportCondidates.TABLE_NAME) ( \(ReportCondidates.COL_NUMBER_OF_VOTE),\(ReportCondidates.COL_CONDIDATE_NUMBER),\(ReportCondidates.COL_REPORT_ID)) VALUES ( \(candidate[1]),\(candidate[0]),\(report_id) );"
                try con!.executeUpdate(candidateInsertStatment, values: nil)
            }
            
       
        }catch{
            print( error)
            print("storeLocaleFile your insertion field ")
        }
        con!.close()
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
