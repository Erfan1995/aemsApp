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
    var candidateVoteNumber = Array(repeating: 0, count: 19)
    public var imagePickerController: UIImagePickerController?
    var imagePicker: ImagePicker!
    var selectedImage:Int = 0
    let candidateImage = #imageLiteral(resourceName: "user (2)")
    var firsImage : UIImageView?
    var secondImage: UIImageView?
    var pollingCenter: UITextField?
    let picker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
      
        
        collectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
        self.hideKeyboardWhenTappedAround()
        addBarButton()
        candidateName.removeAll()
        candidateNumber.removeAll()
        
        var candidatesList : Array<Candidate> = AppDatabase().getCandidates()
        
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


        var files : Array<UIImage> = Array();
        
        var arr = [[Int]](repeating: [Int](repeating: 0, count: 2), count: candidateVoteNumber.count)
     
        
        var index : Int = 0
        for value in candidateVoteNumber{
            if value != -1 && index != 0{
               arr[index]=[index,value]
            }
            index=index+1
        }
        
        print(arr)
        
        saveImageToDocumentDirectory(image: firsImage!.image!)
        firsImage?.image=loadImageFromDocumentDirectory(nameOfImage: "image002.png")
        
//        let firstImageData = (firsImage!.image?.jpegData(compressionQuality: 0))!
//        let secondImageData = (secondImage!.image?.jpegData(compressionQuality: 0))
//
        // https://stackoverflow.com/a/40521003
        
        let headers: HTTPHeaders = [
            "authorization": User().getLoginUserDefault()!.token
        ]

    
        let report : Report = Report(latitude: 30.302, longitude: 92.736, observer_id: 10, void_vote: 100, white_vote: 2, right_vote: 1, province_id: 1, polling_center_id: 3, pc_station_nummber: 2, date_time: "2019-01-02")
        
        let candidateData = try? JSONSerialization.data(withJSONObject: arr, options: [])
        

        
        
        

//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(imageData, withName: "image1", fileName: "test1.jpg", mimeType: "image/jpg");
//            multipartFormData.append(candidateData!, withName: "candidates");
//            multipartFormData.append(String(report.province_id!).data(using: String.Encoding.utf8)!, withName: "province_id");
//            multipartFormData.append(String(report.observer_id!).data(using: String.Encoding.utf8)!, withName: "observer_id");
//            multipartFormData.append(String(report.right_vote!).data(using: String.Encoding.utf8)!, withName: "right_vote");
//            multipartFormData.append(String(report.void_vote!).data(using: String.Encoding.utf8)!, withName: "void_vote");
//            multipartFormData.append(String(report.latitude!).data(using: String.Encoding.utf8)!, withName: "latitude");
//            multipartFormData.append(String(report.white_vote!).data(using: String.Encoding.utf8)!, withName: "white_vote");
//            multipartFormData.append(String(report.polling_center_id!).data(using: String.Encoding.utf8)!, withName: "polling_center_id");
//            multipartFormData.append(String(report.pc_station_number!).data(using: String.Encoding.utf8)!, withName: "pc_station_number");
//            multipartFormData.append(String(report.longitude!).data(using: String.Encoding.utf8)!, withName: "longitude");
//        },to: "\(AppDatabase.DOMAIN_ADDRESS)/api/finalresult/register",method: .post,headers:headers ) { (result) in
//            switch result {
//            case .success(let upload, _, _):
//                upload.uploadProgress(closure: { (progress) in
//                    print("Upload Progress: \(progress.fractionCompleted)")
//                })
//
//                upload.responseJSON { response in
//                    print("Success")
//                    print(response.result.value)
//                }
//
//            case .failure(let encodingError):
//                print("Error")
//                print(encodingError)
//            }
//        }
        
   
    }
    
    
    func saveImageToDocumentDirectory(image: UIImage ) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "image002.png" // name of the image to be saved
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
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
        cell.candidateImage.image = candidateImage
        cell.candidateName.text = candidateName[indexPath.row]
        cell.candidateNumber.text = String(candidateNumber[indexPath.row])
        cell.txtVoteNumber.text = String(candidateVoteNumber[Int(candidateNumber[indexPath.row])])
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.txtVoteNumber.addTarget(self, action: #selector(textFieldOnChange(_sender:)), for: .editingChanged)
        
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
            }
            else{
                print("<#T##items: Any...##Any#>")
            }
        }
        else if(selectedImage==2){
            if secondImage != nil{
               
                let compressImage = image?.jpegData(compressionQuality: 0)
                let myImage = UIImage(data: compressImage!)
                if let data = myImage?.jpegData(compressionQuality: 0){
                    let fileSizeString = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: ByteCountFormatter.CountStyle.memory)
                    
                }
                 secondImage?.image = myImage
            }
            else{
                print("<#T##items: Any...##Any#>")
            }
        }
      
    }
    
   
    
    
}
extension NewReportViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return candidateName.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pollingCenter?.text = candidateName[row]
        
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
        label.text = candidateName[row]
        return label
    }
    
   
}


