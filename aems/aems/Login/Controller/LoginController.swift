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


    @IBOutlet weak var txtDownload: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
//     var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginDate : LoginData? = User().getLoginUserDefault()
        if  loginDate != nil {
            if loginDate!.polling_center_id != 0{
                let tabBarViewController = storyboard?.instantiateViewController(
                    withIdentifier: "TabBarViewController") as! TabBarViewController
                present(tabBarViewController, animated: true, completion: nil)

            }
            else{
                var data : LoginData = LoginData(complete_name: "", observer_id: 0, polling_center_id: 0, province_id: 0, token: "", pc_station_number: 0)
            }
        }
        hideKeyboardWhenTappedAround()
        appearKeyboard()
    }
    func appearKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
       
    }
    
    @objc func keyboardWillShow(notification: Notification){
 
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else{
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification{
            let keyboardRect = keyboardFrame.cgRectValue
            
            view.frame.origin.y = -30
            
        }else{
            view.frame.origin.y = 0
        }
    }


    
    @IBAction func registerBtnPressed(_ sender: Any) {
        
        if Candidate().getCondidateUserDefault() && Province().getProvinceUserDefault() && District().getDistrictUserDefault() && PollingCenter().getPollingCenterUserDefault() {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let registerViewController = mainStoryboard.instantiateViewController(withIdentifier: "RegisterViewController" ) as? RegisterViewController else{
                print("could not find controller")
                return
            }
            navigationController?.pushViewController(registerViewController, animated: true)
        }
        else{
            Helper.showSnackBar(messageString: "please download needed file at the first ")
        }
        
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        
        let phone : String = txtPhone.text!
        let password : String = txtPassword.text!
        do{
           let phones =  try txtPhone.validatedText(validationType: ValidatorType.phone)
        
            
            let pass =   try txtPassword.validatedText(validationType: ValidatorType.password)
            if CheckInternetConnection.isConnectedToInternet(){
                Loader.start(style: .whiteLarge, backColor: UIColor.white, baseColor: UIColor.blue)
                Alamofire.request(AppDatabase.DOMAIN_ADDRESS+"/api/authentication/mobile-login",
                                  method: .post,
                                  parameters: ["phone": phone,"password":password])
                    .validate()
                    .responseJSON { response in
                        guard response.result.isSuccess else {
                            return
                        }
                        let json=JSON(response.value)
                        Loader.stop()
                        if json["response"]==1{
                            var responseData = json["data"]
                            var loginData = LoginData(complete_name: responseData["complete_name"].stringValue, observer_id: responseData["observer_id"].intValue, polling_center_id: responseData["polling_center_id"].intValue, province_id: responseData["province_id"].intValue, token: responseData["token"].stringValue, pc_station_number: responseData["pc_amount_of_polling_station"].intValue)
                            
                            User().setLoginUserDefault(loginData: loginData)
                            
                            let tabBarViewController =
                                self.storyboard?.instantiateViewController(
                                    withIdentifier: "TabBarViewController") as! TabBarViewController
                            self.present(tabBarViewController, animated: true, completion: nil)
                        }
                        else if json["response"]==2{
                            
                            Helper.showSnackBar(messageString: "yout acount not approved ")
                        }
                        else if json["response"]==3{
                            
                            
                            Helper.showSnackBar(messageString: "your phone or password in wrong")
                        }
                        else if json["response"]==4{
                            
                            Helper.showSnackBar(messageString: "occured some problem try again")
                        }
                }
            }
            else{
                Helper.showSnackBar(messageString: "connect to the internt first")
            }
        }catch(let error){
            Helper.showSnackBar(messageString: "enter correcto phone and password")
        }
        
    }
    
    
    
    
    func downloadFiles() {
        if CheckInternetConnection.isConnectedToInternet(){
            Loader.start(style: .whiteLarge, backColor: .white, baseColor: UIColor.blue)
            Alamofire.request(AppDatabase.DOMAIN_ADDRESS+"/api/commondatacollection/get-common-data-for-mobile",
                              method: .get)
                .validate()
                .responseJSON { response in
                    guard response.result.isSuccess else {
                        return
                    }
                    Loader.stop()
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
                        (province) in let province = Province(province_id: province["province_id"].int32Value, name: province["province_name"].stringValue)
                        provinceData.append(province)
                    })
                    
                    
                    json["districts"].array?.forEach({
                        (district) in let district = District(district_id: district["district_id"].int32Value, province_id: district["province_id"].int32Value, name: district["district_name"].stringValue)
                        districtData.append(district)
                    })
                    
                    
                    json["polling_centers"].array?.forEach({
                        (center) in let center = PollingCenter(polling_center_id: center["id"].int32Value, polling_center_code: center["polling_center_name"].stringValue, district_id: center["district_id"].int32Value)
                        pollingCenterData.append(center)
                    })
                    
                    AppDatabase().downloadFileFromServer(condidates: condidateData, provinces: provinceData, districts: districtData, centers: pollingCenterData)
                    
            }

        }else{
            Helper.showSnackBar(messageString: "Connect to the internet first")
        }
    }
    @IBAction func downloadPressed(_ sender: Any) {
        if !Candidate().getCondidateUserDefault() && !Province().getProvinceUserDefault() && !District().getDistrictUserDefault() && !PollingCenter().getPollingCenterUserDefault() {
            downloadFiles()
        }
        else{
            Helper.showSnackBar(messageString: "download operation completed successfuly ")
        }
    }
}



    


