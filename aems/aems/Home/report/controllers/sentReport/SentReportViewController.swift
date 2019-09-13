//
//  SentReportViewController.swift
//  aems
//
//  Created by aems aems on 5/23/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class SentReportViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var sentReportTable: UITableView!
    var sentContent: [DraftAndSentReportContent] = []
    var setLocationName : Array<Int> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton()
        sentReportTable.delegate = self
        sentReportTable.dataSource = self
        setLocationName=AppDatabase().getDraftOrSentReports(isSent: 1)
        sentContent = creatArry()
        
    }

    @objc func loadList(){
        setLocationName=AppDatabase().getDraftOrSentReports(isSent: 1)
        sentContent = creatArry()
        self.sentReportTable.reloadData()
    }
    
    func creatArry()->[DraftAndSentReportContent]{
        var temptSent: [DraftAndSentReportContent] = []
        for indedx in 0..<setLocationName.count{
            temptSent.append(DraftAndSentReportContent(iconImage: #imageLiteral(resourceName: "image"), locationName: " \(AppLanguage().Locale(text: "pollingCenterNo")) \(setLocationName[indedx])"))
        }
        return temptSent
    }
    
    
    func addBarButton(){
        let buttonSend = UIButton(type: .custom)
        buttonSend.setImage(UIImage(named: "delete_24"), for: .normal)
        buttonSend.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        buttonSend.frame = CGRect(x: 0, y: 0, width: 15, height: 20)
        let barButtonSend = UIBarButtonItem(customView: buttonSend)
        self.navigationItem.rightBarButtonItem = barButtonSend
    }
    
    
    @objc func tapButton(){
        let alert = UIAlertController(title: AppLanguage().Locale(text: "delete"), message: AppLanguage().Locale(text: "deleteSentReport"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppLanguage().Locale(text: "no"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: AppLanguage().Locale(text: "yes"), style: .default, handler: { action in
            AppDatabase().deleteAllReport(is_sent: 1)
            self.loadList()
        }))
        self.present(alert, animated: true)
    }
    

}
extension SentReportViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setLocationName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentReportTableViewCell") as! SentReportTableViewCell
        cell.setSentReports(sentReport: sentContent[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "sentReportDetailsViewController") as! sentReportDetailsViewController
        vc.locName = String(setLocationName[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
