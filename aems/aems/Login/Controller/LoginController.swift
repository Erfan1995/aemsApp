//
//  ViewController.swift
//  aems
//
//  Created by aems aems on 5/15/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerBtnPressed(_ sender: Any) {
        
        let registerViewController = storyboard?.instantiateViewController(
            withIdentifier: "RegisterViewController") as! RegisterViewController
        
        present(registerViewController, animated: true, completion: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        let tabBarViewController =
            storyboard?.instantiateViewController(
                withIdentifier: "TabBarViewController") as! TabBarViewController
        
          present(tabBarViewController, animated: true, completion: nil)
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
    
//    func scrollForKeyboard( scrollView: UIScrollView){
//       var scrollView = scrollView
//        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: Notification.Name.UIKeyboardWillHide , object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: Notification.Name.UIKeyboardWillChangeFrame , object:  nil)
//        }
//        @objc func Keyboard(notification: Notification){
//            let userInfo = notification.userInfo
//            let keyboardScreenEndFrame = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//            if notification.name == Notification.Name.UIKeyboardWillHide{
//                scrollView.contentInset = UIEdgeInsets.zero
//            }else{
//                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
//            }
//            scrollView.scrollIndicatorInsets = scrollView.contentInset
//        }
}

