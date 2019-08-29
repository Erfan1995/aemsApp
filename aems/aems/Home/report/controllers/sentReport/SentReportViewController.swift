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
    var setLocationName = ["محل شماره 1","محل شماره دوم","محل شماره سوم","محل شماره جهارم","محل شماره پنچم","محل شماره ششم","هفتم","هشتم","نهم","دهم","یازدهم"]
    override func viewDidLoad() {
        super.viewDidLoad()
        sentReportTable.delegate = self
        sentReportTable.dataSource = self
        sentContent = creatArry()
    }

    func creatArry()->[DraftAndSentReportContent]{
        var temptSent: [DraftAndSentReportContent] = []
        for indedx in 0..<setLocationName.count{
            temptSent.append(DraftAndSentReportContent(iconImage: #imageLiteral(resourceName: "image"), locationName: setLocationName[indedx]))
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
        vc.locName = setLocationName[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
