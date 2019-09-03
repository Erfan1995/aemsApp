//
//  TabBarViewController.swift
//  aems
//
//  Created by aems aems on 5/15/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var tabBarItems = UITabBarItem()
    override func viewDidLoad() {
        super.viewDidLoad()
//       self.navigationController?.navigationBar.topItem?.title = ""
    }


}
extension UIImage{
    class  func imageWithColor(color: UIColor, size: CGSize)->UIImage {
        let rect = CGRect(x: 0,y:0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
