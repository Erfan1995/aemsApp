//
//  ReportViewController.swift
//  aems
//
//  Created by aems aems on 5/22/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit
import CoreLocation
class ReportViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var newReportView: UIView!
    @IBOutlet weak var sentReportView: UIView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        let newReportTapGetsture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)));        newReportView.addGestureRecognizer(newReportTapGetsture)
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus(){
            case .notDetermined, .restricted, .denied :
                print("no ACCESSSSSSSSSS >>>>>>>>>>>>>>.")
                
            case .authorizedAlways:
                print("accesss >>>>>>>>>>>>")
            case .authorizedWhenInUse:
                print("Access >>>>>>>>>>>>>>>>>>")
            @unknown default:
                print("<#T##items: Any...##Any#>")
            }
        }else{
            turnOnLocationSerives()
        }
        
    }
    func turnOnLocationSerives(){
        let alertController = UIAlertController(title: "Location Permission is required", message: "please enable your location service in settings", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "settings", style: .default, handler:  {
            (action)->Void in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }


    @objc func handleTap(sender: UITapGestureRecognizer){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let newReportViewController = mainStoryboard.instantiateViewController(withIdentifier: "NewReportViewController") as? NewReportViewController else {
            print("couldn't find the view controller")
            return
        }
        navigationController?.pushViewController(newReportViewController, animated: true)

    }

 
 

}
