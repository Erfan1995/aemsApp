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
    var report : Report?
    var candidateName : Array<String> = Array()
    var numberOfVotes : Array<String> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        sentReportCollection.dataSource = self
        sentReportCollection.delegate = self
        report=AppDatabase().getReport(station_id: Int(locName)!)
        for candidte in AppDatabase().getCandidateReport(report_id: report!.id!){
            
            switch(Int(candidte[0])){
            case 1:
                candidateName.append("رحمت الله نبیل")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 2:
                candidateName.append("دوکتور نورالله جلیلی")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 3:
                candidateName.append("دکتور فرامز تمنا")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 4:
                candidateName.append("شیدا محمد ابدالی")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 5:
                candidateName.append("احمدولی مسعود")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 6:
                candidateName.append("نورحمان لیوال")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 7:
                candidateName.append("محمد شهاب حکیمی")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 8:
                candidateName.append("محمد اشرف غنی")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 9:
                candidateName.append("دکتور عبدالله عبدالله")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 10:
                candidateName.append("محمد حکیم تورسن")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 11:
                candidateName.append("گلبدین حکتمیار")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 12:
                candidateName.append("عبدالطیف پدرام")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 13:
                candidateName.append("نورالحق علومی ")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 14:
                candidateName.append("حاجی محمد ابراهیم الکوزی ")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 15:
                candidateName.append("پوهاند پروفیسوردکتورغلام فاروق نجرابی")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 16:
                candidateName.append("عنایت الله حفیظ")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 17:
                candidateName.append("محمد حنیف اتمر")
                numberOfVotes.append(String(candidte[1]))
                break
                
            case 18:
                candidateName.append("داکتر زلمی رسول")
                numberOfVotes.append(String(candidte[1]))
                break
        
            default:
                break
            }
        }
    }
}

extension sentReportDetailsViewController{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return candidateName.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentReportCollectionViewCell", for: indexPath) as! SentReportCollectionViewCell
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

       
        headerView.locationName.text = "محل شماره \(locName)"
        headerView.date.text = "\(report!.date_time!)"
        headerView.reportIcon.image = #imageLiteral(resourceName: "logo")
        headerView.correctVote.text = String(report!.right_vote!)
        headerView.wrongVote.text = String(report!.void_vote!)
        headerView.whiteVote.text = String(report!.white_vote!)
        
        var images = AppDatabase().getImageReport(report_id: report!.id!)
        if  images.count==1{
            headerView.firstImage.image=ReportImage().loadImageFromDocumentDirectory(nameOfImage: images[0])
        }
        else if images.count==2{
            headerView.firstImage.image=ReportImage().loadImageFromDocumentDirectory(nameOfImage: images[0])
            headerView.secondImage.image=ReportImage().loadImageFromDocumentDirectory(nameOfImage: images[1])
        }
        
        return headerView
    }

    
}
