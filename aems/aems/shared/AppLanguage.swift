//
//  AppLanguage.swift
//  aems
//
//  Created by aems1 aems on 8/31/19.
//  Copyright © 2019 aems aems. All rights reserved.
//

import UIKit

class AppLanguage: NSObject {

    var languageBundle : Bundle?    
    
    func setLanguage(lang:String)  {
        UserDefaults.standard.setValue(lang, forKey: "language")
    }
    
    
    func Locale(text:String) -> String {
        var languageBundel:Bundle?
        
        let languageCode = UserDefaults.standard
        if languageCode.value(forKey: "language") != nil && (languageCode.value(forKey: "language")as? String != "en" ) {
            let language=languageCode.string(forKey: "language")
            let path = Bundle.main.path(forResource: language, ofType: "lproj")
            languageBundel = Bundle(path: path!)
        }
        else{
            let path = Bundle.main.path(forResource: "fa-AF", ofType: "lproj")
            languageBundel = Bundle(path: path!)
            
        }
        return languageBundel!.localizedString(forKey: text, value: "", table: nil)
    }
    
}
