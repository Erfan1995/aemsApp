//
//  RegisterViewController.swift
//  aems
//
//  Created by aems aems on 5/15/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var province: UITextField!
    @IBOutlet weak var district: UITextField!
    @IBOutlet weak var pollingCenter: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var pollsterCode: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    var provincePickerData = ["کابل", "غزنی" , "قندهار", "هرات", "مزارشریف"]
    var districtPickerData = ["جاغوری", "یکاولنگ", "بهسود","استالیف","کابل" ,"پولخمری"]
    var pollingCenterData = ["مرکز۱","مرکز ۲","مرکز۳","مزکز۴","مرکز۵"]
    var activeTextField = 0
    let picker = UIPickerView()
    
    var selectedDaty:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        province.delegate = self
        district.delegate = self
        pollingCenter.delegate = self
        creatProvincePicker()
        createToolbar()
//        scrollForKeyboard(scrollView: self.scrollView)
        scrollForKeyboard()
    }
    func scrollForKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: Notification.Name.UIKeyboardWillHide , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: Notification.Name.UIKeyboardWillChangeFrame , object:  nil)
    }
    @objc func Keyboard(notification: Notification){
        let userInfo = notification.userInfo
        let keyboardScreenEndFrame = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide{
            scrollView.contentInset = UIEdgeInsets.zero
        }else{
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    func creatProvincePicker(){
       
        picker.delegate = self
        province.inputView = picker
        district.inputView = picker
        pollingCenter.inputView = picker
        
        picker.backgroundColor = .black
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
   
    @IBAction func register(_ sender: Any) {
        dismiss( animated: true, completion: nil)
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
            break
        case 2:
            district.text = districtPickerData[row]
            break
        case 3:
            pollingCenter.text = pollingCenterData[row]
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
