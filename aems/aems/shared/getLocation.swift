//
//  getLocation.swift
//  aems
//
//  Created by aems aems on 6/7/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
open class getLocation: NSObject, CLLocationManagerDelegate {
     let locationManager = CLLocationManager()
    public func getLocationLitLong(){
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined{
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action)->Void in
            self.turnOnLocationSerives()
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
