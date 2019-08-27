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
        if !hasLocationPermission() {
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
        
    }
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            default:
                print("<#T##items: Any...##Any#>")
            }
        } else {
            hasPermission = false
        }
        
        return hasPermission
    }
    
//   func getLocation(){
//         let status = CLLocationManager.authorizationStatus()
//        switch status {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//            return
//        case .denied:
//            let alert = UIAlertController(title: "location service diabled", message: "please enable location service in settings", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(okAction)
//            present(alert, animated: true, completion: nil)
//            return
//        case .authorizedAlways, .authorizedWhenInUse:
//            break
//        default:
//            print("<#T##items: Any...##Any#>")
//        }
//        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
//    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            print("Current location: \(currentLocation)")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
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
