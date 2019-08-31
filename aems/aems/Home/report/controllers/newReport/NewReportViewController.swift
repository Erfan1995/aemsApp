//
//  NewReportViewController.swift
//  aems
//
//  Created by aems aems on 5/23/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import Alamofire
import SwiftyJSON
class NewReportViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    var estimatedWidth = 180.0
    var cellMarginSize = 5.0
    var candidateName : Array<String> = Array()
    var candidateNumber : Array<Int32> = Array()
    var txtWrongVote : UITextField?
    var txtWhiteVote : UITextField?
    var txtCorrectVote : UITextField?
    var stationList : Array<Int> = Array()
    var selectedFiles : Array<Int> = Array()
    var candidateVoteNumber = Array(repeating: 0, count: 19)
    public var imagePickerController: UIImagePickerController?
    var imagePicker: ImagePicker!
    var selectedImage:Int = 0
    let candidateImage = #imageLiteral(resourceName: "user (2)")
    var firsImage : UIImageView?
    var secondImage: UIImageView?
    var pollingCenter: UITextField?
    let picker = UIPickerView()
    var languageBundle : Bundle?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        collectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        self.hideKeyboardWhenTappedAround()
        addBarButton()
        candidateName.removeAll()
        candidateNumber.removeAll()
        
        language()


        var candidatesList : Array<Candidate> = AppDatabase().getCandidates()
        let numberOfStation = User().getLoginUserDefault()!.pc_station_number
        for stationNumber in 1...numberOfStation{
            stationList.append(stationNumber)
        }
        
        
        
   
        
        for x in 1...18{
            var match : Bool = false
            for y in 0..<candidatesList.count{
                if x == Int(candidatesList[y].election_no!){
                    match=true
                    break
                }
            }
            
            if  match{
                candidateVoteNumber[x] = 0
                
            }
            else{
                candidateVoteNumber[x] = -1
            }
        }
        
        
        for candidate in candidatesList{
            candidateName.append(candidate.candidate_name!)
            candidateNumber.append(candidate.election_no!)
        }
        setupGrid()

    }
    
    
    
    func language() {
        let languageCode = UserDefaults.standard
        if UserDefaults.standard.value(forKey: "language") != nil {
            let language = languageCode.string(forKey: "language")!
            if let path  = Bundle.main.path(forResource: language, ofType: "lproj") {
                languageBundle =  Bundle(path: path)
            }
            else{
                languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            }
        }
        else {
            languageCode.set("en", forKey: "language")
            languageCode.synchronize()
            let language = languageCode.string(forKey: "language")!
            if let path  = Bundle.main.path(forResource: language, ofType: "lproj") {
                languageBundle =  Bundle(path: path)
            }
            else{
                languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            }
        }
    }
    
    
    
    func setupGrid(){
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
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

        var tootalVote = 0
        let station_id = Int(pollingCenter!.text ?? "0")
        var files : Array<ImageFile> = Array();
        files.removeAll()
        var candidatesVote:Dictionary<String, Int> = [:]
        
        
        let whiteVote=Int(txtWhiteVote!.text ?? "0")
        let correctVote=Int(txtCorrectVote!.text ?? "0")
        let wrongVote=Int(txtWrongVote!.text ?? "0")
        let polling_center_id = User().getLoginUserDefault()?.polling_center_id
        let observer_id = User().getLoginUserDefault()?.observer_id
        let provice_id = User().getLoginUserDefault()?.province_id
        
        
        var candidateArray = Array(repeating: Array(repeating: 0, count: 2), count: 19)
        
        var index=0
        for value in candidateVoteNumber{
            if value != -1 && index != 0{
                //candidatesVote[String(index)]=value
                tootalVote=tootalVote+value
                candidateArray[index][0]=index
                candidateArray[index][1]=value
            }
            index=index+1
        }
        
        
        
        if tootalVote>=450 || tootalVote>=(whiteVote!+wrongVote!+correctVote!){
            Helper.showSnackBar(messageString: "your report is wrong please correct your report ")
        }else{
        if selectedFiles.count == 1{
            if selectedFiles[0]==1{
                if firsImage!.image != nil{
                    let image1="image1_name_\(Int(round(Date().timeIntervalSince1970))).png"
                    ReportImage().saveImageToDocumentDirectory(image: firsImage!.image!, fileName: image1)
                    files.append(ImageFile(fileName: image1, file: firsImage!.image!))
                }
            }
            else if selectedFiles[0]==2{
                if (secondImage!.image != nil){
                    let image2="image2_name_\(Int(round(Date().timeIntervalSince1970))).png"
                    ReportImage().saveImageToDocumentDirectory(image: secondImage!.image!, fileName: image2)
                    files.append(ImageFile(fileName: image2, file: secondImage!.image!))
                }
            }
        }
        else if selectedFiles.count == 2 {
            let image1="image1_name_\(Int(round(Date().timeIntervalSince1970))).png"
            ReportImage().saveImageToDocumentDirectory(image: firsImage!.image!, fileName: image1)
            files.append(ImageFile(fileName: image1, file: firsImage!.image!))
            
            let image2="image2_name_\(Int(round(Date().timeIntervalSince1970))).png"
            ReportImage().saveImageToDocumentDirectory(image: secondImage!.image!, fileName: image2)
            files.append(ImageFile(fileName: image2, file: secondImage!.image!))
        }
        else {
            Helper.showSnackBar(messageString: "plesase select your files")
        }
        
        
        
        let headers: HTTPHeaders = [
            "authorization": User().getLoginUserDefault()!.token
        ]
        
        
            let report : Report = Report(latitude: ReportViewController.latitude, longitude: ReportViewController.longitude, observer_id: observer_id, void_vote: wrongVote, white_vote: whiteVote, right_vote: correctVote, province_id: provice_id, polling_center_id: polling_center_id, pc_station_nummber: station_id, date_time: getCurrentDate())
        
        
        let candidateData = try? JSONSerialization.data(withJSONObject: candidateArray , options: [])
        
        
        
        if AppDatabase().isSentReport(station_id: station_id!){
            print("you report id douplicate please choose other station")
            let alert = UIAlertController(title: "گزارش تکراری", message: "گزارش شما از این مرکز یک بار ارسال شده آیا میخواهید دوباره ارسال کنید ؟", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "بله", style: .default, handler: { action in
                
                
                if files.count == 1{
                    if CheckInternetConnection.isConnectedToInternet(){
                        let firstImageData = (files[0].file!.jpegData(compressionQuality: 0))!
                        Alamofire.upload(multipartFormData: { (multipartFormData) in
                            multipartFormData.append(firstImageData, withName: "image1", fileName: files[0].fileName!, mimeType: "image/png");
                            multipartFormData.append(candidateData!, withName: "candidates");
                            multipartFormData.append(String(report.province_id!).data(using: String.Encoding.utf8)!, withName: "province_id");
                            multipartFormData.append(String(report.observer_id!).data(using: String.Encoding.utf8)!, withName: "observer_id");
                            multipartFormData.append(String(report.right_vote!).data(using: String.Encoding.utf8)!, withName: "right_vote");
                            multipartFormData.append(String(report.void_vote!).data(using: String.Encoding.utf8)!, withName: "void_vote");
                            multipartFormData.append(String(report.latitude!).data(using: String.Encoding.utf8)!, withName: "latitude");
                            multipartFormData.append(String(report.white_vote!).data(using: String.Encoding.utf8)!, withName: "white_vote");
                            multipartFormData.append(String(report.polling_center_id!).data(using: String.Encoding.utf8)!, withName: "polling_center_id");
                            multipartFormData.append(String(report.pc_station_number!).data(using: String.Encoding.utf8)!, withName: "pc_station_number");
                            multipartFormData.append(String(report.longitude!).data(using: String.Encoding.utf8)!, withName: "longitude");
                        },to: "\(AppDatabase.DOMAIN_ADDRESS)/api/finalresult/register",method: .post,headers:headers ) { (result) in
                            switch result {
                            case .success(let upload, _, _):
                                upload.uploadProgress(closure: { (progress) in
                                    print("Upload Progress: \(progress.fractionCompleted)")
                                })
                                
                                upload.responseJSON { response in
                                    var res = response.result.value as? Int
                                    if  res == 1{
                                        AppDatabase().deleteReport(station_id: station_id!)
                                        report.is_sent=true
                                        AppDatabase().storeFileToLocal(files: files, report: report, candidatesVote: candidateArray)
                                        Helper.showSnackBar(messageString: "your report sent")
                                    }
                                    
                                }
                                
                            case .failure(let encodingError):
                                Helper.showSnackBar(messageString: "occured some error . Please try again ")
                            }
                        }
                        
                        
                    }
                    else{
                        AppDatabase().deleteReport(station_id: station_id!)
                        report.is_sent=false
                        AppDatabase().storeFileToLocal(files: files, report: report, candidatesVote: candidateArray)
                        Helper.showSnackBar(messageString: "your report stored in draft")
                    }
                }
                else if files.count == 2{
                    if CheckInternetConnection.isConnectedToInternet(){
                        let firstImageData = (files[0].file?.jpegData(compressionQuality: 0))!
                        let secondImageData = (files[1].file?.jpegData(compressionQuality: 0))!
                        Alamofire.upload(multipartFormData: { (multipartFormData) in
                            multipartFormData.append(firstImageData, withName: "image1", fileName: files[0].fileName!, mimeType: "image/png");
                            multipartFormData.append(secondImageData, withName: "image2", fileName: files[1].fileName!, mimeType: "image/png");
                            multipartFormData.append(candidateData!, withName: "candidates");
                            multipartFormData.append(String(report.province_id!).data(using: String.Encoding.utf8)!, withName: "province_id");
                            multipartFormData.append(String(report.observer_id!).data(using: String.Encoding.utf8)!, withName: "observer_id");
                            multipartFormData.append(String(report.right_vote!).data(using: String.Encoding.utf8)!, withName: "right_vote");
                            multipartFormData.append(String(report.void_vote!).data(using: String.Encoding.utf8)!, withName: "void_vote");
                            multipartFormData.append(String(report.latitude!).data(using: String.Encoding.utf8)!, withName: "latitude");
                            multipartFormData.append(String(report.white_vote!).data(using: String.Encoding.utf8)!, withName: "white_vote");
                            multipartFormData.append(String(report.polling_center_id!).data(using: String.Encoding.utf8)!, withName: "polling_center_id");
                            multipartFormData.append(String(report.pc_station_number!).data(using: String.Encoding.utf8)!, withName: "pc_station_number");
                            multipartFormData.append(String(report.longitude!).data(using: String.Encoding.utf8)!, withName: "longitude");
                        },to: "\(AppDatabase.DOMAIN_ADDRESS)/api/finalresult/register",method: .post,headers:headers ) { (result) in
                            switch result {
                            case .success(let upload, _, _):
                                upload.uploadProgress(closure: { (progress) in
                                    print("Upload Progress: \(progress.fractionCompleted)")
                                })
                                
                                upload.responseJSON { response in
                                    var res = response.result.value as? Int
                                    if  res == 1{
                                        AppDatabase().deleteReport(station_id: station_id!)
                                        report.is_sent=true
                                        AppDatabase().storeFileToLocal(files: files, report: report, candidatesVote: candidateArray)
                                        Helper.showSnackBar(messageString: "your report stored in sent report")
                                    }
                                }
                                
                            case .failure(let encodingError):
                                Helper.showSnackBar(messageString: "occure some problem . Please try again")
                            }
                        }
                    }
                    else{
                        AppDatabase().deleteReport(station_id: station_id!)
                        report.is_sent=false
                        AppDatabase().storeFileToLocal(files: files, report: report, candidatesVote: candidateArray)
                        Helper.showSnackBar(messageString: "your report stored in draft")
                    }
                }
                else{
                    Helper.showSnackBar(messageString: "please select image file ")
                }
                
                //end if
                
                
            }))
            alert.addAction(UIAlertAction(title: "نخیر", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
            
        }
        else{
            
                if files.count == 1{
                    if CheckInternetConnection.isConnectedToInternet(){
                        let firstImageData = (files[0].file!.jpegData(compressionQuality: 0))!
                        Alamofire.upload(multipartFormData: { (multipartFormData) in
                            multipartFormData.append(firstImageData, withName: "image1", fileName: files[0].fileName!, mimeType: "image/png");
                            multipartFormData.append(candidateData!, withName: "candidates");
                            multipartFormData.append(String(report.province_id!).data(using: String.Encoding.utf8)!, withName: "province_id");
                            multipartFormData.append(String(report.observer_id!).data(using: String.Encoding.utf8)!, withName: "observer_id");
                            multipartFormData.append(String(report.right_vote!).data(using: String.Encoding.utf8)!, withName: "right_vote");
                            multipartFormData.append(String(report.void_vote!).data(using: String.Encoding.utf8)!, withName: "void_vote");
                            multipartFormData.append(String(report.latitude!).data(using: String.Encoding.utf8)!, withName: "latitude");
                            multipartFormData.append(String(report.white_vote!).data(using: String.Encoding.utf8)!, withName: "white_vote");
                            multipartFormData.append(String(report.polling_center_id!).data(using: String.Encoding.utf8)!, withName: "polling_center_id");
                            multipartFormData.append(String(report.pc_station_number!).data(using: String.Encoding.utf8)!, withName: "pc_station_number");
                            multipartFormData.append(String(report.longitude!).data(using: String.Encoding.utf8)!, withName: "longitude");
                        },to: "\(AppDatabase.DOMAIN_ADDRESS)/api/finalresult/register",method: .post,headers:headers ) { (result) in
                            switch result {
                            case .success(let upload, _, _):
                                upload.uploadProgress(closure: { (progress) in
                                    print("Upload Progress: \(progress.fractionCompleted)")
                                })
                                
                                upload.responseJSON { response in
                                    
                                    var response = response.result.value as? Int
                                    if  response == 1{
                                        report.is_sent=true
                                        AppDatabase().storeFileToLocal(files: files, report: report, candidatesVote: candidateArray)
                                        Helper.showSnackBar(messageString: "your report stored ")
                                    }
                                }
                                
                            case .failure(let encodingError):
                                Helper.showSnackBar(messageString: "occured some error .Please try again")
                            }
                        }
                        
                        
                    }
                    else{
                        report.is_sent=false
                        AppDatabase().storeFileToLocal(files: files, report: report, candidatesVote: candidateArray)
                        Helper.showSnackBar(messageString: "your report stored in draft")
                    }
                }
                else if files.count == 2{
                    if CheckInternetConnection.isConnectedToInternet(){
                        let firstImageData = (files[0].file?.jpegData(compressionQuality: 0))!
                        let secondImageData = (files[1].file?.jpegData(compressionQuality: 0))!
                        Alamofire.upload(multipartFormData: { (multipartFormData) in
                            multipartFormData.append(firstImageData, withName: "image1", fileName: files[0].fileName!, mimeType: "image/png");
                            multipartFormData.append(secondImageData, withName: "image2", fileName: files[1].fileName!, mimeType: "image/png");
                            multipartFormData.append(candidateData!, withName: "candidates");
                            multipartFormData.append(String(report.province_id!).data(using: String.Encoding.utf8)!, withName: "province_id");
                            multipartFormData.append(String(report.observer_id!).data(using: String.Encoding.utf8)!, withName: "observer_id");
                            multipartFormData.append(String(report.right_vote!).data(using: String.Encoding.utf8)!, withName: "right_vote");
                            multipartFormData.append(String(report.void_vote!).data(using: String.Encoding.utf8)!, withName: "void_vote");
                            multipartFormData.append(String(report.latitude!).data(using: String.Encoding.utf8)!, withName: "latitude");
                            multipartFormData.append(String(report.white_vote!).data(using: String.Encoding.utf8)!, withName: "white_vote");
                            multipartFormData.append(String(report.polling_center_id!).data(using: String.Encoding.utf8)!, withName: "polling_center_id");
                            multipartFormData.append(String(report.pc_station_number!).data(using: String.Encoding.utf8)!, withName: "pc_station_number");
                            multipartFormData.append(String(report.longitude!).data(using: String.Encoding.utf8)!, withName: "longitude");
                        },to: "\(AppDatabase.DOMAIN_ADDRESS)/api/finalresult/register",method: .post,headers:headers ) { (result) in
                            switch result {
                            case .success(let upload, _, _):
                                upload.uploadProgress(closure: { (progress) in
                                    print("Upload Progress: \(progress.fractionCompleted)")
                                })
                                
                                upload.responseJSON { response in
                        
                                    
                                    var response = response.result.value as? Int
                                    if  response == 1{
                                        report.is_sent=true
                                        AppDatabase().storeFileToLocal(files: files, report: report, candidatesVote: candidateArray)
                                        Helper.showSnackBar(messageString: "your report stored in dent report")
                                    }
                                    
                                }
                                
                            case .failure(let encodingError):
                                Helper.showSnackBar(messageString: "occured some problem . Please try agian")
                            }
                        }
                    }
                    else{
                        report.is_sent=false
                        AppDatabase().storeFileToLocal(files: files, report: report, candidatesVote: candidateArray)
                        Helper.showSnackBar(messageString: "your report stored in draft")
                    }
                }
                else{
                    Helper.showSnackBar(messageString: "please select image files")
                }
                
                //end if

            }
        
        }
        //selectedFiles.removeAll()
   
    }
   
    
   
    
    func getCurrentDate() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
       return formatter.string(from: currentDateTime)
    }
    
    
    func saveImageToDocumentDirectory(image: UIImage,fileName:String ) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
            } catch {
                Helper.showSnackBar(messageString: "save file has error")
            }
        }
    }
    
    
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image!
        }
        return UIImage.init(named: "default.png")!
    }
    
}


extension NewReportViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: 200.0)
    }
    
    func calculateWidth() -> CGFloat{
        let estimateWidth = CGFloat(estimatedWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimateWidth))
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        return width
    }
}

extension NewReportViewController: UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return candidateName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NewReportCollectionViewCell
        
        cell.candidateName.text = candidateName[indexPath.row]
        cell.candidateNumber.text = String(candidateNumber[indexPath.row])
        cell.txtVoteNumber.text = String(candidateVoteNumber[Int(candidateNumber[indexPath.row])])
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.txtVoteNumber.addTarget(self, action: #selector(textFieldOnChange(_sender:)), for: .editingChanged)
        
        switch candidateNumber[indexPath.row] {
        case 1:
            cell.candidateImage.image = #imageLiteral(resourceName: "rahmatulah_nabil")
            break
            
        case 2:
            cell.candidateImage.image = #imageLiteral(resourceName: "nurolah_jalili")
            break
            
            
        case 3:
            cell.candidateImage.image = #imageLiteral(resourceName: "faramarz_tamana")
            break
            
        case 4:
            cell.candidateImage.image = #imageLiteral(resourceName: "shida_mohamad_abdali")
            break
            
        case 5:
            cell.candidateImage.image = #imageLiteral(resourceName: "ahmad_wali_masod")
            break
            
        case 6:
            cell.candidateImage.image = #imageLiteral(resourceName: "noor_rahman_lival")
            break
            
        case 7:
            cell.candidateImage.image = #imageLiteral(resourceName: "mohamad_shahab")
            break
            
        case 8:
            cell.candidateImage.image = #imageLiteral(resourceName: "ashraf_ghani")
            break
            
        case 9:
            cell.candidateImage.image = #imageLiteral(resourceName: "andulah_abdulah")
            break
            
        case 10:
            cell.candidateImage.image = #imageLiteral(resourceName: "hakim_torsan")
            break
            
        case 11:
            cell.candidateImage.image = #imageLiteral(resourceName: "golbodin")
            break
            
        case 12:
            cell.candidateImage.image = #imageLiteral(resourceName: "latif_pedram")
            break
            
        case 13:
            cell.candidateImage.image = #imageLiteral(resourceName: "noorul_haq")
            break
            
        case 14:
            cell.candidateImage.image = #imageLiteral(resourceName: "abrahim_alikozay")
            break
            
        case 15:
            cell.candidateImage.image = #imageLiteral(resourceName: "gholam_faroq")
            break
            
        case 16:
            cell.candidateImage.image = #imageLiteral(resourceName: "enayat_hafiz")
            break
            
        case 17:
            cell.candidateImage.image = #imageLiteral(resourceName: "hanif_atmar")
            break
            
        case 18:
            cell.candidateImage.image = #imageLiteral(resourceName: "zalmay_rasol")
            break
        default:
            cell.candidateImage.image = #imageLiteral(resourceName: "user (2)")
        }
        
        return cell
    }
    
    
    @IBAction func textFieldOnChange(_sender: UITextField) {
        let indexPath = self.collectionView.indexPathForItem(at: _sender.convert(CGPoint.zero, to: self.collectionView))
        let vote : String? = _sender.text
        if vote != nil && vote != ""{
            candidateVoteNumber[Int(candidateNumber[indexPath![1]])] = Int(vote!)!
        }
        else{
            candidateVoteNumber[Int(candidateNumber[indexPath![1]])]=0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("unexpected element kind")
        }
        let headerView  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NewReportHeaderView", for: indexPath) as! NewReportHeaderView
        self.firsImage = headerView.pickFirstImage
        self.secondImage = headerView.pickSecondImage
        let firstImageTap = UITapGestureRecognizer(target: self, action: #selector(tapFirstDetected(_sender:)))
        let secondImageTap = UITapGestureRecognizer(target: self, action: #selector(tapSecondDetected(_sender:)))
        headerView.pickFirstImage.isUserInteractionEnabled = true
        headerView.pickFirstImage.addGestureRecognizer(firstImageTap)
        headerView.pickSecondImage.isUserInteractionEnabled = true
        headerView.pickSecondImage.addGestureRecognizer(secondImageTap)

        self.txtWhiteVote=headerView.whiteVote
        self.txtWrongVote=headerView.wrongVote
        self.txtCorrectVote=headerView.correctVote
        self.pollingCenter = headerView.pollingCenter
        pollingCenter?.delegate = self
//        let pollingCenterTap = UITapGestureRecognizer(target: self, action: #selector(choosePollingCenter))
//        pollingCenter?.addGestureRecognizer(pollingCenterTap)
        createPollingCenterPicker()
        return headerView
    }
    
    func createPollingCenterPicker(){
        picker.delegate = self as? UIPickerViewDelegate
        pollingCenter?.inputView = picker
        picker.backgroundColor = .gray
    }
    
    //Action
    @IBAction func tapFirstDetected(_sender: UIView) {
        self.selectedImage = 1
        self.imagePicker.present(from: _sender)
    }
    
    @IBAction func tapSecondDetected(_sender: UIView){
        self.selectedImage = 2
        self.imagePicker.present(from: _sender)
    }
    
    @objc func choosePollingCenter(){
        
    }
    
}
extension NewReportViewController:  ImagePickerDelegate{
    func didSelect(image: UIImage?) {
        
        if selectedImage==1{
            if firsImage != nil{
                firsImage?.image=image
                selectedFiles.append(1)
            }
        }
        else if(selectedImage==2){
            if secondImage != nil{
                 secondImage?.image = image
                 selectedFiles.append(2)
            }
        }
      
    }
}


extension NewReportViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stationList.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pollingCenter?.text = String(stationList[row])
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel{
            label = view
        }else{
            label = UILabel()
        }
        label.textColor = .green
        label.textAlignment = .center
        label.text = String(stationList[row])
        return label
    }
    
   
}

extension String {
    func localized(_ lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }}
