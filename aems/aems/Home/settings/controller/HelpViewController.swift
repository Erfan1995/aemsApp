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
    @IBOutlet weak var txtSecondOption: UITextView!
    @IBOutlet weak var imgSecondOption: UIImageView!
    @IBOutlet weak var lblThirdOption: UILabel!
    @IBOutlet weak var lblSecondOption: UILabel!
    @IBOutlet weak var txtThirdOption: UITextView!
    @IBOutlet weak var imgThirdOption: UIImageView!
    @IBOutlet weak var lblMainPageThirdOption: UILabel!
    @IBOutlet weak var txtNote: UITextView!
    
    
    func localizeView() {
        txtLoginPageGuide.text=AppLanguage().Locale(text: "login_guid_content")
        lblLoginTitle.text=AppLanguage().Locale(text: "login_guid_title")
        txtDownloadFileGuide.text=AppLanguage().Locale(text: "login_content_2")
        lblDownloadTitle.text=AppLanguage().Locale(text: "login_option_2")
        txtSelectLanguageGuide.text=AppLanguage().Locale(text: "login_content_1")
        txtCreateAcountGuide.text=AppLanguage().Locale(text: "login_content_3")
        lblCreateAcountTitle.text=AppLanguage().Locale(text: "login_option_3")
        lblLoginToSystem.text=AppLanguage().Locale(text: "login_option_4")
        txtLoginToSystemGuide.text=AppLanguage().Locale(text: "login_content_4")
        lblRegisterTitle.text=AppLanguage().Locale(text: "register_guide")
        lblSelectLanguageTitle.text=AppLanguage().Locale(text: "login_option_1")
        txtRegisterGuide.text=AppLanguage().Locale(text: "register_content_1")
        lblMainPageGuide.text=AppLanguage().Locale(text: "main_page_guid_title")
        txtMainPageGuide.text=AppLanguage().Locale(text: "guide_title_text")
        lblMainPageFirstOption.text=AppLanguage().Locale(text: "option_1")
        lblMainPageSecondOption.text=AppLanguage().Locale(text: "option_2")
        lblMainPageThirdOption.text=AppLanguage().Locale(text: "option_3")
        lblFirstOption.text=AppLanguage().Locale(text: "option_new_report")
        txtFirstOption.text=AppLanguage().Locale(text: "description_new_report")
        txtSecondOption.text=AppLanguage().Locale(text: "description_draft_report")
        lblThirdOption.text=AppLanguage().Locale(text: "option_sent_report")
        lblSecondOption.text=AppLanguage().Locale(text: "option_draft")
        txtThirdOption.text=AppLanguage().Locale(text: "description_sent_report")
        txtNote.text=AppLanguage().Locale(text: "guide_note")
        
        
//        imgLogin.image=""
//        imgRegister.image=""
//        imgMainPage.image=""
//        imgFistOption.image=""
//        imgSecondOption.image=""
//        imgThirdOption.image=""
        
        
        let lang = UserDefaults.standard.string(forKey: "language")
        if lang=="ps-AF"{
                imgLogin.image=#imageLiteral(resourceName: "login_image_ps.jpg")
                imgRegister.image=#imageLiteral(resourceName: "register_image_ps.jpg")
                imgMainPage.image=#imageLiteral(resourceName: "main_image_ps.jpg")
                imgFistOption.image=#imageLiteral(resourceName: "final_result_image_ps")
                imgSecondOption.image=#imageLiteral(resourceName: "sent_image_ps.jpg")
                imgThirdOption.image=#imageLiteral(resourceName: "draft_image_ps.jpg")
        }
        else{
            imgLogin.image=#imageLiteral(resourceName: "login_image_fa.jpg")
            imgRegister.image=#imageLiteral(resourceName: "register_image_fa.jpg")
            imgMainPage.image=#imageLiteral(resourceName: "main_image_fa.jpg")
            imgFistOption.image=#imageLiteral(resourceName: "final_result_image_fa")
            imgSecondOption.image=#imageLiteral(resourceName: "draft_image_fa.jpg")
            imgThirdOption.image=#imageLiteral(resourceName: "sent_image_fa.jpg")
        }
        
    }
    
    var parentName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if ((parentName.elementsEqual("Login")) == true){
            self.navigationController?.navigationBar.topItem?.title = AppLanguage().Locale(text: "loginPage")
        }else if((parentName.elementsEqual("Info")) == true){
            self.navigationController?.navigationBar.topItem?.title = AppLanguage().Locale(text: "descriptionPage")
        }
        
        localizeView()
        
        // Do any additional setup after loading the view.
    }


}
