//
//  HelpViewController.swift
//  aems
//
//  Created by aems aems on 6/2/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    var parentName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((parentName.elementsEqual("Login")) == true){
            self.navigationController?.navigationBar.topItem?.title = "صفحه ورودی"
        }else if((parentName.elementsEqual("Info")) == true){
            self.navigationController?.navigationBar.topItem?.title = "صفحه مشخصات"
        }
        
        // Do any additional setup after loading the view.
    }


}
