//
//  sentReportDetailsViewController.swift
//  aems
//
//  Created by aems aems on 6/5/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class sentReportDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var sentReportCollection: UICollectionView!
    var locName = ""
    let candidateName = ["غنی","عبدالله","جلیلی","تمنا","خلیلزاد","حکتیار","نبیل","تورسن"]
    let numberOfVotes = ["3","4","12","23","23","12","43","23",]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sentReportCollection.dataSource = self
        sentReportCollection.delegate = self
        addBarButton()
    }
 

    func addBarButton(){
        let buttonSend = UIButton(type: .custom)
        buttonSend.setImage(UIImage(named: "send-button (3)"), for: .normal)
        buttonSend.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        buttonSend.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barButtonSend = UIBarButtonItem(customView: buttonSend)
        self.navigationItem.rightBarButtonItem = barButtonSend
    }
    @objc func tapButton(){
        
    }
}

extension sentReportDetailsViewController: UIScrollViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return candidateName.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentReportCollectionViewCell", for: indexPath) as! SentReportCollectionViewCell
        cell.candidateName.text = candidateName[indexPath.row]
        cell.numberOfVote.text  = numberOfVotes[indexPath.row]
        cell.layer.borderWidth = 0.3
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else{
            fatalError("Unexptected element kind")
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SentReportCollectionReusableView", for: indexPath) as! SentReportCollectionReusableView

       
        headerView.locationName.text = locName
        headerView.date.text = "12-23-23"
        headerView.reportIcon.image = #imageLiteral(resourceName: "logo")
        headerView.correctVote.text = String(200)
        headerView.wrongVote.text = String(12)
        headerView.whiteVote.text = String(0)
        return headerView
    }

    
}
