//
//  draftReportViewController.swift
//  aems
//
//  Created by aems aems on 6/5/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class DraftReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var draftTable: UITableView!
    var draftContent: [DraftAndSentReportContent] = []
    var setLocationName : Array<Int> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        draftTable.delegate = self
        draftTable.dataSource = self
        setLocationName=AppDatabase().getDraftOrSentReports(isSent: 0)
       draftContent = creatArry()
        // Do any additional setup after loading the view.
    }
    func creatArry()->[DraftAndSentReportContent]{
        var temptDraft: [DraftAndSentReportContent] = []
        for indedx in 0..<setLocationName.count{
            temptDraft.append(DraftAndSentReportContent(iconImage: #imageLiteral(resourceName: "image"), locationName: " \(AppLanguage().Locale(text: "pollingCenterNo")) \(setLocationName[indedx])"))
        }
        return temptDraft
    }
    

    

}
extension DraftReportViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setLocationName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DraftTableViewCell") as! DraftTableViewCell
        cell.setDraftReports(draftReport: draftContent[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DraftDetailsViewController") as! DraftDetailsViewController
        vc.locName = String(setLocationName[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
