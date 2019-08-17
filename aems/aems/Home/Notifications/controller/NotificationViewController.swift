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
    var notifications: [Notification] = []
    var date = "Dddd"
    var message = ["سلام خوبی","سلام خوبی","سلام خوبی","سلام خوبی","سلام خوبی"]
    override func viewDidLoad() {
        super.viewDidLoad()
        notifications = creatArray()
//        notificationCell.delegate = self
//        notificationCell.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  creatArray() -> [Notification] {
        var tempNotification: [Notification] = []
//        for i in message{
//            tempNotification.append(Notification(image: #imageLiteral(resourceName: "user (2)"), date: self.date, message: i ))
//        }
        let n1 = Notification(image: #imageLiteral(resourceName: "user (2)"), date: "dd", message: "helllo")
        let n2 = Notification(image: #imageLiteral(resourceName: "user (2)"), date: "dd", message: "helllo")
        let n3 = Notification(image: #imageLiteral(resourceName: "user (2)"), date: "dd", message: "helllo")
        let n4 = Notification(image: #imageLiteral(resourceName: "user (2)"), date: "dd", message: "helllo")
        
        tempNotification.append(n1)
        tempNotification.append(n2)
        tempNotification.append(n3)
        tempNotification.append(n4)
        return tempNotification
    }

}





