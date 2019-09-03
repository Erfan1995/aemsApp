//
//  RegisterViewController.swift
//  aems
//
//  Created by aems aems on 5/15/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblRegisterTitle: UILabel!
    @IBOutlet weak var province: UITextField!
    @IBOutlet weak var district: UITextField!
    @IBOutlet weak var pollingCenter: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var pollsterCode: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var polesterCodeLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var pollingCenterLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPassLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    var provincePickerData : Array<String> = Array()
    var districtPickerData : Array<String> = Array()
    var pollingCenterData : Array<String> = Array()
    var activeTextField = 0
    let picker = UIPickerView()
    var provinces : Array<Province> = Array();
    var districts : Array<District> = Array();
    var centers : Array<PollingCenter> = Array();
    let login = LoginViewController()
    var selectedDaty:String?
    var passwordText: String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        provinces = AppDatabase().getProvinces()
        for province in provinces{
            provincePickerData.append(province.name!)
        }
        localize()
        fullName.addTarget(self, action: #selector(validateFullName), for: .editingChanged )
        pollsterCode.addTarget(self, action: #selector(validatePollsterCode(_sender:)), for: .editingChanged )
        phoneNumber.addTarget(self, action: #selector(validatePhoneNumber(_sender:)), for: .editingChanged )
        province.addTarget(self, action: #selector(validateProvince(_sender:)), for: .editingChanged )
        district.addTarget(self, action: #selector(validateDistrict(_sender:)), for: .editingChanged )
        pollingCenter.addTarget(self, action: #selector(validatePollingCenter(_sender:)), for: .editingChanged )
        password.addTarget(self, action: #selector(validatePassword(_sender:)), for: .editingChanged )
        confirmPassword.addTarget(self, action: #selector(validateConfPassword(_sender:)), for: .editingChanged )
        hideKeyboardWhenTappedAround()
        province.delegate = self
        district.delegate = self
        pollingCenter.delegate = self
        creatProvincePicker()
        createToolbar()
        scrollForKeyboard()
        
    }
    // moves the the view up so the the textfield be visible while the keyboard appears
    
    
    func localize() {
        btnRegister.setTitle(AppLanguage().Locale(text: "save"), for: .normal)
        lblRegisterTitle.text=AppLanguage().Locale(text: "registerTitle")
        province.placeholder=AppLanguage().Locale(text: "province")
        district.placeholder=AppLanguage().Locale(text: "district")
        pollingCenter.placeholder=AppLanguage().Locale(text: "pollingCenter")
        fullName.placeholder=AppLanguage().Locale(text: "completeName")
        pollsterCode.placeholder=AppLanguage().Locale(text: "observerCode")
        phoneNumber.placeholder=AppLanguage().Locale(text: "phone")
        password.placeholder=AppLanguage().Locale(text: "password")
        confirmPassword.placeholder=AppLanguage().Locale(text: "confirmPassword")
    }
    
    func scrollForKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:  nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else{
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification{
            let keyboardRect = keyboardFrame.cgRectValue
            
            view.frame.origin.y = -100
            
        }else{
            view.frame.origin.y = 0
        }
    }
    
    
    func creatProvincePicker(){
        picker.delegate = self
        province.inputView = picker
        district.inputView = picker
        pollingCenter.inputView = picker
        picker.backgroundColor = .gray
    }
    
    
    func createToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = .black
        toolbar.tintColor  = .white    
        toolbar.isUserInteractionEnabled = true
        province.inputAccessoryView = toolbar
        district.inputAccessoryView = toolbar
        pollingCenter.inputAccessoryView = toolbar
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case province:
            activeTextField = 1
            picker.reloadAllComponents()
            break
        case district:
            activeTextField = 2
            picker.reloadAllComponents()
            break
        case pollingCenter:
            activeTextField = 3
            picker.reloadAllComponents()
            break
        default:
            activeTextField = 0
        }
    }
    
    
    @IBAction func validateFullName( _sender: UITextField){
        do{
            try _sender.validatedText(validationType: ValidatorType.username)
            fullNameLabel.text = nil
            _sender.layer.borderColor = UIColor.gray.cgColor
        }catch(let error){
            _sender.layer.borderWidth = 1.0
            _sender.layer.borderColor = UIColor.red.cgColor
            fullNameLabel.textColor = .red
            fullNameLabel.text = (error as! ValidationError ).message
        }
    }
    
    
    @IBAction func validatePollsterCode( _sender: UITextField){
        do{
            try _sender.validatedText(validationType: ValidatorType.pollsterCode)
            _sender.layer.borderColor = UIColor.gray.cgColor
            polesterCodeLabel.text = nil
        }catch(let error){
            _sender.layer.borderColor = UIColor.red.cgColor
            _sender.layer.borderWidth = 1.0
            polesterCodeLabel.textColor = .red
            polesterCodeLabel.text = (error as! ValidationError ).message
        }
    }
    
    
    @IBAction func validatePhoneNumber( _sender: UITextField){
        do{
            try _sender.validatedText(validationType: ValidatorType.phone)
            _sender.layer.borderColor = UIColor.gray.cgColor
            phoneNumberLabel.text = nil
        }catch(let error){
            _sender.layer.borderColor = UIColor.red.cgColor
            _sender.layer.borderWidth = 1.0
            phoneNumberLabel.textColor = .red
            phoneNumberLabel.text = (error as! ValidationError ).message
        }
    }
    
    
    @IBAction func validateProvince( _sender: UITextField){
        do{
            try _sender.validatedText(validationType: ValidatorType.requiredField(field: "Province"))
            _sender.layer.borderColor = UIColor.gray.cgColor
            provinceLabel.text = nil
        }catch(let error){
            _sender.layer.borderColor = UIColor.red.cgColor
            _sender.layer.borderWidth = 1.0
            provinceLabel.textColor = .red
            provinceLabel.text = (error as! ValidationError ).message
        }
    }
    
    
    @IBAction func validateDistrict( _sender: UITextField){
        do{
            try _sender.validatedText(validationType: ValidatorType.requiredField(field: "District"))
            _sender.layer.borderColor = UIColor.gray.cgColor
            districtLabel.text = nil
        }catch(let error){
            _sender.layer.borderColor = UIColor.red.cgColor
            _sender.layer.borderWidth = 1.0
            districtLabel.textColor = .red
            districtLabel.text = (error as! ValidationError ).message
        }
    }
    
    
    @IBAction func validatePollingCenter( _sender: UITextField){
        do{
            try _sender.validatedText(validationType: ValidatorType.requiredField(field: "PollingCenter"))
            _sender.layer.borderColor = UIColor.gray.cgColor
            pollingCenterLabel.text = nil
        }catch(let error){
            _sender.layer.borderColor = UIColor.red.cgColor
            _sender.layer.borderWidth = 1.0
            pollingCenterLabel.textColor = .red
            pollingCenterLabel.text = (error as! ValidationError ).message
        }
    }
    
    
    @IBAction func validatePassword( _sender: UITextField){
        do{
            try _sender.validatedText(validationType: ValidatorType.password)
            self.passwordText = _sender.text
            _sender.layer.borderColor = UIColor.gray.cgColor
            passwordLabel.text = nil
        }catch(let error){
            _sender.layer.borderColor = UIColor.red.cgColor
            _sender.layer.borderWidth = 1.0
            passwordLabel.textColor = .red
            passwordLabel.text = (error as! ValidationError ).message
        }
    }
    
    
    @IBAction func validateConfPassword( _sender: UITextField){
        do{
            try _sender.validatedText(validationType: ValidatorType.matchPassword(password: passwordText!))
            _sender.layer.borderColor = UIColor.gray.cgColor
            confirmPassLabel.text = nil
        }catch(let error){
            _sender.layer.borderColor = UIColor.red.cgColor
            _sender.layer.borderWidth = 1.0
            confirmPassLabel.textColor = .red
            confirmPassLabel.text = (error as! ValidationError ).message
        }
    }
    
    @IBAction func register(_ sender: Any) {
        do{
            let userName  = try fullName.validatedText(validationType: ValidatorType.username)
            let pollster = try pollsterCode.validatedText(validationType: ValidatorType.pollsterCode)
            let phone = try phoneNumber.validatedText(validationType: ValidatorType.phone)
            let provinceName = try province.validatedText(validationType: ValidatorType.requiredField(field: "Province"))
            let districtName = try district.validatedText(validationType: ValidatorType.requiredField(field: "District"))
            let pollingCenterName = try pollingCenter.validatedText(validationType: ValidatorType.requiredField(field: "polling center"))
            let pass = try password.validatedText(validationType: ValidatorType.password)
            let confPass = try confirmPassword.validatedText(validationType: ValidatorType.matchPassword(password: pass))
            if CheckInternetConnection.isConnectedToInternet(){
                Loader.start(style: .whiteLarge, backColor: .gray, baseColor: UIColor.blue)
                var province_id : Int32 = 0
                var pollingCenter_id : Int32 = 0
                let complete_name : String = fullName.text!
                let observer_code : String = pollsterCode.text!
                let phone : String = phoneNumber.text!
                let pass : String = password.text!
                
                for pro in provinces{
                    if pro.name == province.text!{
                        province_id=pro.province_id!
                    }
                }
                
                for cen in centers{
                    if cen.polling_center_code == pollingCenter.text!{
                        pollingCenter_id=cen.polling_center_id!
                    }
                }
                
                
                
                let user: Dictionary = ["complete_name": complete_name, "observer_code": observer_code,"phone":phone,"password":pass,"polling_center_id":pollingCenter_id] as [String : Any]
                let manager = Alamofire.SessionManager.default
                manager.session.configuration.timeoutIntervalForRequest = 120
                manager.request(AppDatabase.DOMAIN_ADDRESS+"/api/observers/register", method: .post, parameters:user, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        guard response.result.isSuccess else {
                            return
                        }
                        Loader.stop()
                        let json=JSON(response.value)
                        if  json["response"]==1{
                            Helper.showSnackBar(messageString: AppLanguage().Locale(text: "registredSuccessfuly"))
                            self.dismiss( animated: true, completion: nil)
                        }
                        else if json["response"]==2{
                            Helper.showSnackBar(messageString: AppLanguage().Locale(text: "duplicatePhone"))
                        }
                        else if json["response"]==3{
                            Helper.showSnackBar(messageString: AppLanguage().Locale(text: "occuredSomeProblem"))
                        }
                }
            }else{
                Helper.showSnackBar(messageString: AppLanguage().Locale(text: "checkInternetConnection"))
            }
            
        }catch(let error){
            Helper.showSnackBar(messageString: (error as! ValidationError).message)
        }
       
     }
}


extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource{
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch activeTextField {
        case 1 :
            return provincePickerData.count
        case 2:
            return districtPickerData.count
        case 3:
            return pollingCenterData.count
        default:
            return provincePickerData.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch activeTextField {
        case 1:
            province.text = provincePickerData[row]
            for pro in provinces{
                var district_id:Int=0
                var isDistrictSelected : Bool = false
                if pro.name == province.text! {
                    isDistrictSelected=true
                   districtPickerData.removeAll()
                   districts = AppDatabase().getDistrict(province_id: pro.province_id!)
                    for dis in districts{
                        districtPickerData.append(dis.name!)
                        if isDistrictSelected{
                            district_id=Int(dis.district_id!)
                            isDistrictSelected=false
                        }
                    }
                    district.text=districtPickerData[0]
                    
                    
                    if  district_id != 0 {
                        print("selected district \(district_id)")
                        centers=AppDatabase().getPollingCenters(district_id: Int32(district_id))
                        for cen in centers{
                            pollingCenterData.append(cen.polling_center_code!)
                        }
                    }
                    if pollingCenterData.count>0{
                        print("print \(pollingCenterData[0])")
                        pollingCenter.text=pollingCenterData[0]
                    }
                    
                    
                }
            }
            break
        case 2:
            if districtPickerData.count>0{
            district.text = districtPickerData[row]
            for dis in districts{
                if dis.name == district.text! {
                    pollingCenterData.removeAll()
                    centers = AppDatabase().getPollingCenters(district_id: dis.district_id!)
                    for center in centers{
                        pollingCenterData.append(center.polling_center_code!)
                    }
                    if  pollingCenterData.count>0{
                        pollingCenter.text=pollingCenterData[0]
                        }
                    }
                }
            }
            break
        case 3:
            if pollingCenterData.count>0{
               pollingCenter.text = pollingCenterData[row]
            }
            break
        default:
            province.text = provincePickerData[row]
            break
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
        }
        label.textColor = .green
        label.textAlignment = .center

        switch activeTextField {
        case 1:
            label.text = provincePickerData[row]
            break
        case 2:
            label.text = districtPickerData[row]
            break
        case 3:
            label.text = pollingCenterData[row]
            break
        default:
            label.text  = districtPickerData[row]
        }
        return label
    }

}
