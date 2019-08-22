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
        hideKeyboardWhenTappedAround()

    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let registerViewController = mainStoryboard.instantiateViewController(withIdentifier: "RegisterViewController" ) as? RegisterViewController else{
                print("could not find controller")
                            return
                        }
                       navigationController?.pushViewController(registerViewController, animated: true)
        
    }
    


    @IBAction func loginBtnPressed(_ sender: Any) {
      
        let tabBarViewController =
            storyboard?.instantiateViewController(
                withIdentifier: "TabBarViewController") as! TabBarViewController

          present(tabBarViewController, animated: true, completion: nil)
       
        
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
    @IBAction func downloadPressed(_ sender: Any) {
        print("hello>>>>>>>>>")
    }
    
}
extension UIViewController{
   
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
//    func scrollPageKeyboarAppear(){
//        let center: NotificationCenter = NotificationCenter.default
//        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
//    }
//    @objc func keyboardDidShow(notification: Notification){
//        let info: NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        let keyboardY = self.view.frame.size.height - keyboardSize.height
//
//    }
}

