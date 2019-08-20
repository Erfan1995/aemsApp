//
//  ReportViewController.swift
//  aems
//
//  Created by aems aems on 5/22/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var newReportView: UIView!
    @IBOutlet weak var sentReportView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newReportTapGetsture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)));        newReportView.addGestureRecognizer(newReportTapGetsture)
        
    }

    @objc func handleTap(sender: UITapGestureRecognizer){
//      let newReportController = storyboard?.instantiateViewController(withIdentifier: "NewReportViewController") as! NewReportViewController
//
//        present(newReportController, animated: true, completion: nil)
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let newReportViewController = mainStoryboard.instantiateViewController(withIdentifier: "NewReportViewController") as? NewReportViewController else {
            print("couldn't find the view controller")
            return
        }
        navigationController?.pushViewController(newReportViewController, animated: true)

    }

 
 

}
