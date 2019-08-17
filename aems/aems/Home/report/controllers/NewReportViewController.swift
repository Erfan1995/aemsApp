//
//  NewReportViewController.swift
//  aems
//
//  Created by aems aems on 5/23/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class NewReportViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let candidateName = ["اشرف غنی","اتمر","عبدالله","حکمتیار","جلییلی","نبیل","فرهاد"]
    let candidateNumber = [1,2,3,4,5,6,7,8]
    let candidateImage = #imageLiteral(resourceName: "user (2)")


    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
   

}
extension NewReportViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.collectionView.frame.width*0.3, height: self.collectionView.frame.height*0.1)
        return size
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
        
        cell.contentView.layer.cornerRadius = 0.4
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.contentView.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0 , height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("unexpected element kind")
        }
        let headerView  = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NewReportHeaderView", for: indexPath) as! NewReportHeaderView
        
        
        return headerView
    }
    
}
