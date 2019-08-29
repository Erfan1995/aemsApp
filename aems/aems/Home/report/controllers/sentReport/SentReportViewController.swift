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
        sentReportTable.delegate = self
        sentReportTable.dataSource = self
        setLocationName=AppDatabase().getDraftOrSentReports(isSent: 1)
        sentContent = creatArry()
        
    }

    func creatArry()->[DraftAndSentReportContent]{
        var temptSent: [DraftAndSentReportContent] = []
        for indedx in 0..<setLocationName.count{
            temptSent.append(DraftAndSentReportContent(iconImage: #imageLiteral(resourceName: "image"), locationName: " محل شماره \(setLocationName[indedx])"))
        }
        return temptSent
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
