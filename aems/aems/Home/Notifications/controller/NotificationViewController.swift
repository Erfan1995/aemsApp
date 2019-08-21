//
//  NotificationViewController.swift
//  aems
//
//  Created by aems aems on 5/22/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var notificationCell: UITableView!
    var notifications: [NotificationTab] = []
    var date = "Dddd"
    var message = ["سلام خوبی","سلام خوبی","سلام خوبی","سلام خوبی","سلام خوبی","سلام خوبی","سلام خوبی","سلام خوبی","سلام خوبی","سلام خوبی"]
    override func viewDidLoad() {
        super.viewDidLoad()
        notifications = creatArray()
//        notificationCell.delegate = self
//        notificationCell.dataSource = self
    }

    func  creatArray() -> [NotificationTab] {
        var tempNotification: [NotificationTab] = []
        for i in message{
            tempNotification.append(NotificationTab(image: #imageLiteral(resourceName: "user (2)"), date: self.date, message: i ))
        }

        return tempNotification
    }

}
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.setNotification(notification: notifications[indexPath.row])
        
        return cell
    }
    
    
    
}




