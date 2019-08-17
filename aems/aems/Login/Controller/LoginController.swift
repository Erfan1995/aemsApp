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

