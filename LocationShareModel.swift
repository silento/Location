//
//  LocationShareModel.swift
//  LocationSwing
//
//  Created by Mazhar Biliciler on 18/07/14.
//  Copyright (c) 2014 Mazhar Biliciler. All rights reserved.
//

import Foundation
import UIKit

class LocationShareModel : NSObject {
    var timer : NSTimer?
    var bgTask : BackgroundTaskManager?
    var myLocationArray : NSMutableArray?
    
    func sharedModel()-> AnyObject {
        struct Static {
            static var sharedMyModel : AnyObject?
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            Static.sharedMyModel = LocationShareModel()
        }
        return Static.sharedMyModel!
    }
}
