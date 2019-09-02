//
//  InformationViewController.swift
//  aems
//
//  Created by aems aems on 5/22/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingsTableView: UITableView!
    var settings: [SettingsContent] = []
    var setName = ["\(AppLanguage().Locale(text: "guide"))","\(AppLanguage().Locale(text: "logout"))"]
    var setImage = [#imageLiteral(resourceName: "questions-circular-button"),#imageLiteral(resourceName: "logout (3)")]
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settings = createArray()
        settingsTableView.allowsSelection = true
      
    }
    func createArray()-> [SettingsContent]{
        var tempSettings: [SettingsContent] = []
        for index in 0..<setName.count{
            tempSettings.append(SettingsContent(contentIcon: setImage[index], settingName: setName[index], forwardIcon: #imageLiteral(resourceName: "back")))
        }
        
        
        return tempSettings
    }
}
extension SettingsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell" ) as! SettingsTableViewCell
        cell.setSettings(settings: settings[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var index = indexPath.row
//        if(index == 0){
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            guard let userInfoViewController = mainStoryboard.instantiateViewController(withIdentifier: "UserInfoViewController") as? UserInfoViewController else {
//                print("couldn't find the view controller")
//             return
//
//            }
//            navigationController?.pushViewController(userInfoViewController, animated: true)
//        }
        if(index == 0){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let helpViewController = mainStoryboard.instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController else {
                print("couldn't find the view controller")
                return
                
            }
            navigationController?.pushViewController(helpViewController, animated: true)
        }
        
//            if(index == 2){
//                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                guard let changePasswordViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController else {
//                    print("couldn't find the view controller")
//                    return
//
//                }
//                navigationController?.pushViewController(changePasswordViewController, animated: true)
//        }
            if(index == 1){
                let dialogMessage = UIAlertController(title: AppLanguage().Locale(text: "logout"), message: AppLanguage().Locale(text: "logoutMessage"), preferredStyle: .alert)
                let ok = UIAlertAction(title: AppLanguage().Locale(text: "yes"), style: .default, handler:{
                    (action)->Void in
                    var loginData=LoginData(complete_name: "", observer_id: 0, polling_center_id: 0, province_id: 0, token: "", pc_station_number: 0)
                    User().setLoginUserDefault(loginData: loginData)
                    self.dismiss(animated: true, completion: nil)
                })
                let cancel = UIAlertAction(title: AppLanguage().Locale(text: "no"), style: .cancel)
                {(action)->Void in
            

                }
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                self.present(dialogMessage, animated: true, completion: nil)
        }
        
    }
   
}
