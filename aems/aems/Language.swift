//
//  Language.swift
//  aems
//
//  Created by aems1 aems on 8/31/19.
//  Copyright © 2019 aems aems. All rights reserved.
//

import UIKit

class Language {
    
    var languageBundle : Bundle?
    
    func lang(loc:String) {
        let languageCode = UserDefaults.standard
        if UserDefaults.standard.value(forKey: "language") != nil {
            let language = languageCode.string(forKey: "language")!
            if let path  = Bundle.main.path(forResource: language, ofType: "lproj") {
                languageBundle =  Bundle(path: path)
            }
            else{
                languageBundle = Bundle(path: Bundle.main.path(forResource: "fa-AF", ofType: "lproj")!)
            }
        }
        else {
            languageCode.set("fa-AF", forKey: "language")
            languageCode.synchronize()
            let language = languageCode.string(forKey: "language")!
            if let path  = Bundle.main.path(forResource: language, ofType: "lproj") {
                languageBundle =  Bundle(path: path)
            }
            else{
                languageBundle = Bundle(path: Bundle.main.path(forResource: "fa-AF", ofType: "lproj")!)
            }
        }
        print("language \(languageBundle!.localizedString(forKey: "appName", value: "", table: ""))")
    }
    
    
    
}
