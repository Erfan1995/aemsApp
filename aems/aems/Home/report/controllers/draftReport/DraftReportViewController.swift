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
        addBarButton()
        draftTable.delegate = self
        draftTable.dataSource = self
        setLocationName=AppDatabase().getDraftOrSentReports(isSent: 0)
       draftContent = creatArry()
            }
    @objc func loadList(){
        setLocationName=AppDatabase().getDraftOrSentReports(isSent: 0)
        draftContent = creatArry()
        self.draftTable.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name("loadTable"), object: nil)
   }
    func creatArry()->[DraftAndSentReportContent]{
        var temptDraft: [DraftAndSentReportContent] = []
        for indedx in 0..<setLocationName.count{
            temptDraft.append(DraftAndSentReportContent(iconImage: #imageLiteral(resourceName: "image"), locationName: " \(AppLanguage().Locale(text: "pollingCenterNo")) \(setLocationName[indedx])"))
        }
        return temptDraft
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
        let alert = UIAlertController(title: AppLanguage().Locale(text: "delete"), message: AppLanguage().Locale(text: "deleteDraftReport"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppLanguage().Locale(text: "no"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: AppLanguage().Locale(text: "yes"), style: .default, handler: { action in
            AppDatabase().deleteAllReport(is_sent: 0)
            self.loadList()
        }))
        self.present(alert, animated: true)
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

