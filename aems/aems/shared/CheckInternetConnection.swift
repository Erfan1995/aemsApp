//
//  CheckInternetConnection.swift
//  aems
//
//  Created by aems aems on 6/5/1398 AP.
//  Copyright © 1398 aems aems. All rights reserved.
//

import Foundation
import Alamofire
open class CheckInternetConnection{
    class func isConnectedToInternet()->Bool{
        return NetworkReachabilityManager()!.isReachable
    }
}
