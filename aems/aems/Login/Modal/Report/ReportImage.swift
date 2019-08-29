//
//  ReportImage.swift
//  aems
//
//  Created by aems1 aems on 8/26/19.
//  Copyright © 2019 aems aems. All rights reserved.
//

import Foundation
import Photos

class ReportImage {
    
    static let TABLE_NAME="report_images";
    static let COL_ID="id";
    static let COL_REPORT_ID="report_id";
    static let COL_IMAGE_PATH="image_path"

    var id : Int?
    var report_id : Int?
    var image_path : String?
 
    static let CREATE_TABLE=" CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER PRIMARY KEY AUTOINCREMENT ,\(COL_REPORT_ID) INTEGER , \(COL_IMAGE_PATH) TEXT , FOREIGN KEY ( \(COL_REPORT_ID) ) REFERENCES \(Report.TABLE_NAME) (\(Report.COL_ID)) ON DELETE CASCADE )"
    
    
    
    func saveImageToDocumentDirectory(image: UIImage,fileName:String ) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                print("file saved")
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
