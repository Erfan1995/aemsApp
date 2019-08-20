//
//  ViewController.swift
//  aems
//
//  Created by aems aems on 5/15/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet var txtDownload: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       AppDatabase()
        var loginDate : LoginData? = User().getLoginUserDefault()
        if loginDate != nil {
            print("ok")
        }
        else{
            print("not")
        }
        
        
//        txtDownload.isUserInteractionEnabled=true
//         let downloadGesture = UITapGestureRecognizer(target: self, action: #selector(txtDownload_Click(sender:)));        txtDownload.addGestureRecognizer(downloadGesture)
        
        let newReportTapGetsture = UITapGestureRecognizer(target: self, action: #selector(txtDownload_Click(sender:)));        txtDownload.addGestureRecognizer(newReportTapGetsture)
        
    }

    
    @objc func txtDownload_Click(sender: UITapGestureRecognizer){
        let newReportController = storyboard?.instantiateViewController(withIdentifier: "NewReportViewController") as! NewReportViewController
        
        present(newReportController, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func registerBtnPressed(_ sender: Any) {
        
//        let registerViewController = storyboard?.instantiateViewController(
//            withIdentifier: "RegisterViewController") as! RegisterViewController
//        present(registerViewController, animated: true, completion: nil)
        
        
        
        Alamofire.request(AppDatabase.DOMAIN_ADDRESS+"/api/commondatacollection/get-common-data-for-mobile",
                          method: .get)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    return
                }
                
                let json=JSON(response.value)
                var condidateData : Array<Candidate> = Array()
                var provinceData : Array<Province> = Array()
                var districtData : Array<District> = Array();
                var pollingCenterData : Array<PollingCenter> = Array();
                
                json["candidates"].array?.forEach({
                    (condidate) in let condidate = Candidate(election_no: condidate["election_number"].int32Value, candidate_name: condidate["candidate_name"].stringValue)
                    condidateData.append(condidate)
                })
                
                json["provinces"].array?.forEach({
                    (province) in let province = Province(province_id: province["province_id"].int, name: province["province_name"].stringValue)
                    provinceData.append(province)
                })
                
                
                json["districts"].array?.forEach({
                    (district) in let district = District(district_id: district["district_id"].intValue, province_id: district["province_id"].intValue, name: district["district_name"].stringValue)
                    districtData.append(district)
                })
                
                
                json["polling_centers"].array?.forEach({
                    (center) in let center = PollingCenter(polling_center_id: center["id"].intValue, polling_center_code: center["polling_center_name"].stringValue, district_id: center["district_id"].intValue)
                    pollingCenterData.append(center)
                })

                AppDatabase().downloadFileFromServer(condidates: condidateData, provinces: provinceData, districts: districtData, centers: pollingCenterData)
        }
    }
    


    @IBAction func loginBtnPressed(_ sender: Any) {
      
//        let tabBarViewController =
//            storyboard?.instantiateViewController(
//                withIdentifier: "TabBarViewController") as! TabBarViewController
//        
//          present(tabBarViewController, animated: true, completion: nil)
      
        
        Alamofire.request(AppDatabase.DOMAIN_ADDRESS+"/api/authentication/mobile-login",
                          method: .post,
                          parameters: ["phone": "0700808080","password":"123456"])
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    return
                }
          let json=JSON(response.value)
                if json["response"]==1{
                    var responseData = json["data"]
                    var loginData = LoginData(complete_name: responseData["complete_name"].stringValue, observer_id: responseData["observer_id"].intValue, polling_center_id: responseData["polling_center_id"].intValue, province_id: responseData["province_id"].intValue, token: responseData["token"].stringValue, pc_amount_of_vote: responseData["pc_amount_of_vote"].intValue)
                    User().setLoginUserDefault(loginData: loginData)
                }
                else{
                    print("you authontication field please try again")
                }
        }
    }
}

