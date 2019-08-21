//
//  InformationViewController.swift
//  aems
//
//  Created by aems aems on 5/22/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    var settings: [SettingsContent] = []
    var setName = ["مشخصات","تغییر رمز","خروج"]
    var setImage = [#imageLiteral(resourceName: "user (2)"),#imageLiteral(resourceName: "lock (2)"),#imageLiteral(resourceName: "logout (1)")]
    override func viewDidLoad() {
        super.viewDidLoad()
//        settingsTableView.delegate = self
//        settingsTableView.dataSource = self
        settings = createArray()
      
    }
    func createArray()-> [SettingsContent]{
        var tempSettings: [SettingsContent] = []
        for index in 0..<setName.count{
            tempSettings.append(SettingsContent(contentIcon: setImage[index], settingName: setName[index], forwardIcon: #imageLiteral(resourceName: "back")             ))
        }
        
        
        return tempSettings
    }
}
extension SettingsViewController:   UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell" ) as! SettingsTableViewCell
        cell.setSettings(settings: settings[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
