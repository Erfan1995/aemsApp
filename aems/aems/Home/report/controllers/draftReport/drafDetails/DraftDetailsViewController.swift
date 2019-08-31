//
//  DraftDetailsViewController.swift
//  aems
//
//  Created by aems aems on 6/5/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DraftDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var draftViewCollection: UICollectionView!
    var locName = ""
    var candidateName : Array<String> = Array()
    var numberOfVotes : Array<String> = Array()
    var files : Array<ImageFile> = Array()
    var report : Report?
    var candidateVotes : [[Int]] = []
    var images : Array<String> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        draftViewCollection.dataSource = self
        draftViewCollection.delegate = self
        report=AppDatabase().getReport(station_id: Int(locName)!)
        candidateVotes=AppDatabase().getCandidateReport(report_id: report!.id!)
        for candidte in candidateVotes{
            switch(candidte[0]){
                
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
        files.removeAll()
        let headers: HTTPHeaders = [
            "authorization": User().getLoginUserDefault()!.token
        ]
        let candidateData = try? JSONSerialization.data(withJSONObject: candidateVotes , options: [])
        if CheckInternetConnection.isConnectedToInternet(){
            
        if images.count == 1{
            files.append(ImageFile(fileName:images[0]))

                let firstImageData = (ReportImage().loadImageFromDocumentDirectory(nameOfImage: images[0]).jpegData(compressionQuality: 0))!
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(firstImageData, withName: "image1", fileName: self.images[0], mimeType: "image/png");
                    multipartFormData.append(candidateData!, withName: "candidates");
                    multipartFormData.append(String(self.report!.province_id!).data(using: String.Encoding.utf8)!, withName: "province_id");
                    multipartFormData.append(String(self.report!.observer_id!).data(using: String.Encoding.utf8)!, withName: "observer_id");
                    multipartFormData.append(String(self.report!.right_vote!).data(using: String.Encoding.utf8)!, withName: "right_vote");
                    multipartFormData.append(String(self.report!.void_vote!).data(using: String.Encoding.utf8)!, withName: "void_vote");
                    multipartFormData.append(String(self.report!.latitude!).data(using: String.Encoding.utf8)!, withName: "latitude");
                    multipartFormData.append(String(self.report!.white_vote!).data(using: String.Encoding.utf8)!, withName: "white_vote");
                    multipartFormData.append(String(self.report!.polling_center_id!).data(using: String.Encoding.utf8)!, withName: "polling_center_id");
                    multipartFormData.append(String(self.report!.pc_station_number!).data(using: String.Encoding.utf8)!, withName: "pc_station_number");
                    multipartFormData.append(String(self.report!.longitude!).data(using: String.Encoding.utf8)!, withName: "longitude");
                },to: "\(AppDatabase.DOMAIN_ADDRESS)/api/finalresult/register",method: .post,headers:headers ) { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            print("Upload Progress: \(progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            
                            var res = response.result.value as? Int
                            if res==1{
                                AppDatabase().deleteReport(station_id: self.report!.pc_station_number!)
                                self.report!.is_sent=true
                                AppDatabase().storeFileToLocal(files: self.files, report: self.report!, candidatesVote: self.candidateVotes)
                                Helper.showSnackBar(messageString: "your report stored")
                            }
                            
                        }
                        
                    case .failure(let encodingError):
                        Helper.showSnackBar(messageString: "occured some error . Please try again")
                    }
                }
            
        }
        else if images.count == 2{
                files.append(ImageFile(fileName: images[0]))
                files.append(ImageFile(fileName: images[1]))
                let firstImageData = (ReportImage().loadImageFromDocumentDirectory(nameOfImage: images[0]).jpegData(compressionQuality: 0))!
                let secondImageData = (ReportImage().loadImageFromDocumentDirectory(nameOfImage: images[1]).jpegData(compressionQuality: 0))!
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(firstImageData, withName: "image1", fileName: self.images[0], mimeType: "image/png");
                    multipartFormData.append(secondImageData, withName: "image2", fileName: self.images[1], mimeType: "image/png");
                    multipartFormData.append(candidateData!, withName: "candidates");
                    multipartFormData.append(String(self.report!.province_id!).data(using: String.Encoding.utf8)!, withName: "province_id");
                    multipartFormData.append(String(self.report!.observer_id!).data(using: String.Encoding.utf8)!, withName: "observer_id");
                    multipartFormData.append(String(self.report!.right_vote!).data(using: String.Encoding.utf8)!, withName: "right_vote");
                    multipartFormData.append(String(self.report!.void_vote!).data(using: String.Encoding.utf8)!, withName: "void_vote");
                    multipartFormData.append(String(self.report!.latitude!).data(using: String.Encoding.utf8)!, withName: "latitude");
                    multipartFormData.append(String(self.report!.white_vote!).data(using: String.Encoding.utf8)!, withName: "white_vote");
                    multipartFormData.append(String(self.report!.polling_center_id!).data(using: String.Encoding.utf8)!, withName: "polling_center_id");
                    multipartFormData.append(String(self.report!.pc_station_number!).data(using: String.Encoding.utf8)!, withName: "pc_station_number");
                    multipartFormData.append(String(self.report!.longitude!).data(using: String.Encoding.utf8)!, withName: "longitude");
                },to: "\(AppDatabase.DOMAIN_ADDRESS)/api/finalresult/register",method: .post,headers:headers ) { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            print("Upload Progress: \(progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            
                            var res = response.result.value as? Int
                            if res==1{
                                AppDatabase().deleteReport(station_id: self.report!.pc_station_number!)
                                self.report!.is_sent=true
                                AppDatabase().storeFileToLocal(files: self.files, report: self.report!, candidatesVote: self.candidateVotes)
                                Helper.showSnackBar(messageString: "your report stored in sent report")
                            }
                            
                            
                        }
                        
                    case .failure(let encodingError):
                        Helper.showSnackBar(messageString: "occured some proble , please try again ")
                    }
                }
            }
        }
        else{
            Helper.showSnackBar(messageString: " please check network connection ")
        }
    }

}

extension DraftDetailsViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return candidateName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DraftCollectionViewCell", for: indexPath) as! DraftCollectionViewCell
      
        cell.candidatName.text = candidateName[indexPath.row]
        
        cell.numberOfVoote.text = numberOfVotes[indexPath.row]
        cell.layer.borderWidth = 0.3
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else{
            fatalError("Unexptected element kind")
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DraftCollectionReusableView", for: indexPath) as! DraftCollectionReusableView

        headerView.iconImage.image = #imageLiteral(resourceName: "logo")
        headerView.locationName.text = "محل شماره \(locName)"
        headerView.date.text = "\(report!.date_time!)"
        headerView.correctVote.text = String(report!.right_vote!)
        headerView.wrongVote.text = String(report!.void_vote!)
        headerView.whiteVote.text = String(report!.white_vote!)
        images = AppDatabase().getImageReport(report_id: report!.id!)
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
