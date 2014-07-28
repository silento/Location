//
//  BackgroundTaskManager.swift
//  LocationSwing
//
//  Created by Mazhar Biliciler on 14/07/14.
//  Copyright (c) 2014 Mazhar Biliciler. All rights reserved.
//

import Foundation
import UIKit


class BackgroundTaskManager : NSObject {
    
    var bgTaskIdList : NSMutableArray?
    var masterTaskId : UIBackgroundTaskIdentifier?
    
    init() {
        super.init()
        if self != nil {
            self.bgTaskIdList = NSMutableArray()
            self.masterTaskId = UIBackgroundTaskInvalid
        }
    }
    
    class func sharedBackgroundTaskManager() -> BackgroundTaskManager? {
        struct Static {
            static var sharedBGTaskManager : BackgroundTaskManager?
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            Static.sharedBGTaskManager = BackgroundTaskManager()
        }
        return Static.sharedBGTaskManager
    }
    
    func beginNewBackgroundTask() -> UIBackgroundTaskIdentifier? {
        var application : UIApplication = UIApplication.sharedApplication()
        
        var bgTaskId : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
        
        if application.respondsToSelector("beginBackgroundTaskWithExpirationHandler") {
            print("RESPONDS TO SELECTOR")
            bgTaskId = application.beginBackgroundTaskWithExpirationHandler({
                print("background task \(bgTaskId as Int) expired\n")
            })
        }
        
        if self.masterTaskId == UIBackgroundTaskInvalid {
            self.masterTaskId = bgTaskId
            print("started master task \(self.masterTaskId)\n")
        } else {
            // add this ID to our list
            print("started background task \(bgTaskId as Int)\n")
            self.bgTaskIdList!.addObject(bgTaskId)
            //self.endBackgr
        }
        return bgTaskId
    }
    
    func endBackgroundTask(){
        self.drainBGTaskList(false)
    }
    
    func endAllBackgroundTasks() {
        self.drainBGTaskList(true)
    }
    
    func drainBGTaskList(all:Bool) {
        //mark end of each of our background task
        var application: UIApplication = UIApplication.sharedApplication()
        
        
        let endBackgroundTask : Selector = "endBackgroundTask"
        
        if application.respondsToSelector(endBackgroundTask) {
            var count: Int = self.bgTaskIdList!.count
            for (var i = (all==true ? 0:1); i<count; i++) {
                var bgTaskId : UIBackgroundTaskIdentifier = self.bgTaskIdList!.objectAtIndex(0) as Int
                print("ending background task with id \(bgTaskId as Int)\n")
                application.endBackgroundTask(bgTaskId)
                self.bgTaskIdList!.removeObjectAtIndex(0)
            }
            if self.bgTaskIdList!.count > 0 {
                print("kept background task id \(self.bgTaskIdList!.objectAtIndex(0))\n")
            }
            if all == true {
                print("no more background tasks running\n")
                application.endBackgroundTask(self.masterTaskId!)
                self.masterTaskId = UIBackgroundTaskInvalid
            } else {
                print("kept master background task id \(self.masterTaskId)\n")
            }
        }
    }

}


