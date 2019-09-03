//
//  HelpViewController.swift
//  aems
//
//  Created by aems aems on 6/2/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var txtLoginPageGuide: UITextView!
    @IBOutlet weak var lblLoginTitle: UILabel!
    @IBOutlet weak var imgLogin: UIImageView!
    @IBOutlet weak var txtDownloadFileGuide: UITextView!
    @IBOutlet weak var lblDownloadTitle: UILabel!
    @IBOutlet weak var txtSelectLanguageGuide: UITextView!
    
    @IBOutlet weak var txtCreateAcountGuide: UITextView!
    @IBOutlet weak var lblCreateAcountTitle: UILabel!
    @IBOutlet weak var lblLoginToSystem: UILabel!
    @IBOutlet weak var txtLoginToSystemGuide: UITextView!
    @IBOutlet weak var lblRegisterTitle: UILabel!
    @IBOutlet weak var lblSelectLanguageTitle: UILabel!
    @IBOutlet weak var txtRegisterGuide: UITextView!
    @IBOutlet weak var imgRegister: UIImageView!
    @IBOutlet weak var lblMainPageGuide: UILabel!
    @IBOutlet weak var txtMainPageGuide: UITextView!
    @IBOutlet weak var lblMainPageFirstOption: UILabel!
    @IBOutlet weak var lblMainPageSecondOption: UILabel!
    @IBOutlet weak var imgMainPage: UIImageView!
    @IBOutlet weak var lblFirstOption: UILabel!
    @IBOutlet weak var txtFirstOption: UITextView!
    @IBOutlet weak var imgFistOption: UIImageView!
    
    
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
