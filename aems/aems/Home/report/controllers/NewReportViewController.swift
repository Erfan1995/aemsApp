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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
    
    
    func isExists(index :Int) -> Bool {
        var result : Bool = false
        for x in 1...18{
            if index==x{
                result=true
                break
            }
        }
        return result
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
        let buttonAttach = UIButton(type: .custom)
        buttonAttach.setImage(UIImage(named: "icon (3)"), for: .normal)
        buttonAttach.addTarget(self, action: #selector(tapButton), for: .touchUpInside)

        buttonAttach.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barButtonAttach = UIBarButtonItem(customView: buttonAttach)
        self.navigationItem.rightBarButtonItems = [barButtonSend, barButtonAttach]
}

    @objc func tapButton(){
        var index : Int = 0
        for value in candidateVoteNumber{
            print("candidate index  \(value)")
        }
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

extension NewReportViewController: UICollectionViewDelegate, UICollectionViewDataSource{
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
        return headerView
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
                    print("file size >>>>>>>>\(fileSizeString)")
                }
                 secondImage?.image = myImage
            }
            else{
                print("<#T##items: Any...##Any#>")
            }
        }
      
    }
    
   
    
    
}


