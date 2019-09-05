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


   
    @IBOutlet weak var lblGuideTextView: UITextView!
    @IBOutlet weak var lblGuideText: UILabel!
    @IBOutlet weak var lblGuide: UIButton!
    @IBOutlet weak var txtDownload: UIButton!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var formTitle: UILabel!
    @IBOutlet weak var dobwloadTitle: UILabel!
    @IBOutlet weak var lblSelectLanguage: UILabel!
    @IBOutlet weak var lblDari: UIButton!
    @IBOutlet weak var lblPashot: UIButton!
    
//     var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
 self.navigationController?.navigationBar.topItem?.title = AppLanguage().Locale(text: "loginPage")
        
        let loginDate : LoginData? = User().getLoginUserDefault()
        if  loginDate != nil {
            if loginDate!.polling_center_id != 0{
                checkActivation(observer_id: loginDate!.observer_id, token: loginDate!.token)
            }
            else{
                var _ : LoginData = LoginData(complete_name: "", observer_id: 0, polling_center_id: 0, province_id: 0, token: "", pc_station_number: 0)
            }
        }
        hideKeyboardWhenTappedAround()
        appearKeyboard()

        localizeLogin()
    }
    

    @IBAction func btnDari(_ sender: UIButton) {
        AppLanguage().setLanguage(lang: "fa-AF")
        viewDidLoad()
    }
    
    @IBAction func btnPashto(_ sender: UIButton) {
        AppLanguage().setLanguage(lang: "ps-AF")
        viewDidLoad()
        
    }
    
    
    func localizeLogin() {
        txtDownload.setTitle(AppLanguage().Locale(text: "download"), for: .normal)
        formTitle.text=AppLanguage().Locale(text: "loginTitle")
        txtPhone.placeholder=AppLanguage().Locale(text: "phone")
        txtPassword.placeholder=AppLanguage().Locale(text: "password")
        btnRegister.setTitle(AppLanguage().Locale(text: "register"), for: .normal)
        btnLogin.setTitle(AppLanguage().Locale(text: "login"), for: .normal)
        dobwloadTitle.text=AppLanguage().Locale(text: "downloadTitle")
        lblSelectLanguage.text=AppLanguage().Locale(text: "selectLanguage")
        lblDari.setTitle(AppLanguage().Locale(text: "dari"), for: .normal)
        lblPashot.setTitle(AppLanguage().Locale(text: "pashto"), for: .normal)
        lblGuide.setTitle(AppLanguage().Locale(text: "guide"), for: .normal)
        lblGuideTextView.text=AppLanguage().Locale(text: "guid_text")
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
            _ = keyboardFrame.cgRectValue
            
            view.frame.origin.y = -30
            
        }else{
            view.frame.origin.y = 0
        }
    }


    
    @IBAction func registerBtnPressed(_ sender: Any) {
        
        if Candidate().getCondidateUserDefault() && Province().getProvinceUserDefault() && District().getDistrictUserDefault() && PollingCenter().getPollingCenterUserDefault() {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let registerViewController = mainStoryboard.instantiateViewController(withIdentifier: "RegisterViewController" ) as? RegisterViewController else{
                return
            }
            navigationController?.pushViewController(registerViewController, animated: true)
        }
        else{
            Helper.showSnackBar(messageString: AppLanguage().Locale(text: "downloadFile"))
        }
        
    }

    
    func checkActivation(observer_id:Int,token:String) {
        let headers: HTTPHeaders = [
            "authorization": token
        ]
        
        if CheckInternetConnection.isConnectedToInternet(){
            Loader.start(style: .whiteLarge, backColor: UIColor.white, baseColor: UIColor.blue)
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 100
           manager.request(AppDatabase.DOMAIN_ADDRESS+"/api/authentication/mobile-activation-check", method: .post, parameters: ["observer_id": observer_id], encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseJSON {
                    response in
                    switch (response.result) {
                    case .success: // succes path
                        let json=JSON(response.value as Any)
                        if json["response"]==1{
                            let tabBarViewController = self.storyboard?.instantiateViewController(
                                withIdentifier: "TabBarViewController") as! TabBarViewController
                            self.present(tabBarViewController, animated: true, completion: nil)
                        }
                        else if json["response"]==2{
                            let loginData = LoginData(complete_name: "", observer_id: 0, polling_center_id: 0, province_id: 0, token: "", pc_station_number: 0)
                            User().setLoginUserDefault(loginData: loginData)
                        }
                        Loader.stop()
                        break
           
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            Loader.stop()
                        }
                    break
                    }
            }
        }
        else{
            let tabBarViewController = self.storyboard?.instantiateViewController(
                withIdentifier: "TabBarViewController") as! TabBarViewController
            self.present(tabBarViewController, animated: true, completion: nil)
        }
    }
    
    
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if !Candidate().getCondidateUserDefault() || !Province().getProvinceUserDefault() || !District().getDistrictUserDefault() || !PollingCenter().getPollingCenterUserDefault() {
            Helper.showSnackBar(messageString: AppLanguage().Locale(text: "downloadFile"))
        }
        else{
        
        let phone : String = txtPhone.text!
        let password : String = txtPassword.text!
        do{
            _ =  try txtPhone.validatedText(validationType: ValidatorType.phone)
            _ =   try txtPassword.validatedText(validationType: ValidatorType.password)
            if CheckInternetConnection.isConnectedToInternet(){
                Loader.start(style: .whiteLarge, backColor: UIColor.white, baseColor: UIColor.blue)
                let manager = Alamofire.SessionManager.default
                manager.session.configuration.timeoutIntervalForRequest = 10
                manager.request(AppDatabase.DOMAIN_ADDRESS+"/api/authentication/mobile-login",
                                  method: .post,
                                  parameters: ["phone": phone,"password":password])
                    .validate()
                    .responseJSON { response in
                        switch(response.result){
                        case .success:
                            let json=JSON(response.value as Any)
                            Loader.stop()
                            if json["response"]==1{
                                var responseData = json["data"]
                                let loginData = LoginData(complete_name: responseData["complete_name"].stringValue, observer_id: responseData["observer_id"].intValue, polling_center_id: responseData["polling_center_id"].intValue, province_id: responseData["province_id"].intValue, token: responseData["token"].stringValue, pc_station_number: responseData["pc_amount_of_polling_station"].intValue)
                                
                                User().setLoginUserDefault(loginData: loginData)
                                
                                self.txtPhone.text=""
                                self.txtPassword.text=""
                                let tabBarViewController =
                                    self.storyboard?.instantiateViewController(
                                        withIdentifier: "TabBarViewController") as! TabBarViewController
                                self.present(tabBarViewController, animated: true, completion: nil)
                            }
                            else if json["response"]==2{
                                
                                Helper.showSnackBar(messageString: AppLanguage().Locale(text: "accountNotApproved"))
                            }
                            else if json["response"]==3{
                                
                                
                                Helper.showSnackBar(messageString: AppLanguage().Locale(text: "wrongUsernameAndPassword"))
                            }
                            else if json["response"]==4{
                                
                                Helper.showSnackBar(messageString: AppLanguage().Locale(text: "occuredSomeProblem"))
                            }
                            break
                            
                            case .failure(let error):
                                if error._code == NSURLErrorTimedOut {
                                    Loader.stop()
                                    
                                    
                                }
                            break
                            
                        }

                }
            }
            else{
                Helper.showSnackBar(messageString: AppLanguage().Locale(text: "checkInternetConnection"))
            }
        }catch( _){
            Helper.showSnackBar(messageString: AppLanguage().Locale(text: "enterCorrectPasswordAndUsername"))
        }
            
        }
        
    }

    
    
    
    func downloadFiles() {
        if CheckInternetConnection.isConnectedToInternet(){
            Loader.start(style: .whiteLarge, backColor: .white, baseColor: UIColor.blue)
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 120
            manager.request(AppDatabase.DOMAIN_ADDRESS+"/api/commondatacollection/get-common-data-for-mobile",
                              method: .get)
                .validate()
                .responseJSON { response in
                    switch (response.result){
                    case .success:
                        
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
                        Loader.stop()
                        break
                        
                    case .failure(let error):
                        if error._code == NSURLErrorTimedOut {
                            Loader.stop()

                        }
                        break
                    }

                    Loader.stop()
                    let json=JSON(response.value as Any)
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
            Helper.showSnackBar(messageString:AppLanguage().Locale(text: "checkInternetConnection"))
        }
    }
    
    
    @IBAction func downloadPressed(_ sender: Any) {
        
        if !Candidate().getCondidateUserDefault() || !Province().getProvinceUserDefault() || !District().getDistrictUserDefault() || !PollingCenter().getPollingCenterUserDefault() {
            downloadFiles()
        }
        else{
            Helper.showSnackBar(messageString: AppLanguage().Locale(text: "downloadComplated"))
        }
    }

    @IBAction func btnHelpPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let helpViewController = mainStoryboard.instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController else {
            print("couldn't find the view controller")
            return
            
        }
        helpViewController.parentName = "Login"
        navigationController?.pushViewController(helpViewController, animated: true)
    }
    

}





    


