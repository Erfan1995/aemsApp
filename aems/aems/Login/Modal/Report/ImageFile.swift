//
//  ImageFile.swift
//  aems
//
//  Created by aems1 aems on 8/28/19.
//  Copyright © 2019 aems aems. All rights reserved.
//

import UIKit

class ImageFile {

    var fileName : String?
    var file : UIImage?
    
    init(fileName:String,file:UIImage) {
        self.file=file
        self.fileName=fileName
    }
}
