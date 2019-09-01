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

    @IBOutlet weak var lblSent: UILabel!
    @IBOutlet weak var lblDraft: UILabel!
    @IBOutlet weak var lblNewReport: UILabel!
    @IBOutlet weak var draftReportView: UIView!
    @IBOutlet weak var newReportView: UIView!
    @IBOutlet weak var sentReportView: UIView!
    static var latitude : Double = 0.0
    static var longitude : Double = 0.0
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
     
        super.viewDidLoad()
        localized()
        
        let newReportTapGetsture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)));        newReportView.addGestureRecognizer(newReportTapGetsture)
        let sentReportTapGesture = UITapGestureRecognizer(target: self, action: #selector(sentReportTap(sender:)))
            sentReportView.addGestureRecognizer(sentReportTapGesture)
        let draftReportTapGesture = UITapGestureRecognizer(target: self, action: #selector(draftReportTap(sender:)));
        draftReportView.addGestureRecognizer(draftReportTapGesture)
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
    
    
    func localized() {
        lblSent.text=AppLanguage().Locale(text: "sent")
        lblDraft.text=AppLanguage().Locale(text: "draft")
        lblNewReport.text=AppLanguage().Locale(text: "newReport")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("unable to get location")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        ReportViewController.longitude = locations[0].coordinate.longitude
        ReportViewController.latitude = locations[0].coordinate.latitude
       
    }
    func turnOnLocationSerives(){
        let alertController = UIAlertController(title: AppLanguage().Locale(text: "locationPermission"), message: AppLanguage().Locale(text: "locatioMessage"), preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: AppLanguage().Locale(text: "settings"), style: .default, handler:  {
            (action)->Void in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        let cancelAction = UIAlertAction(title: AppLanguage().Locale(text: "cancel"), style: .cancel, handler: {
            (action)->Void in
            self.turnOnLocationSerives()
        })
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
    @objc func sentReportTap(sender: UITapGestureRecognizer){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let sentReportViewController = mainStoryboard.instantiateViewController(withIdentifier: "SentReportViewController") as? SentReportViewController else {
            print("couldn't find the view controller")
            return
        }
        navigationController?.pushViewController(sentReportViewController, animated: true)
        
    }
    @objc func draftReportTap(sender: UITapGestureRecognizer){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let draftReportViewController = mainStoryboard.instantiateViewController(withIdentifier: "DraftReportViewController") as? DraftReportViewController else {
            print("couldn't find the view controller")
            
            return
        }
        navigationController?.pushViewController(draftReportViewController, animated: true)
    }

 
 

}
