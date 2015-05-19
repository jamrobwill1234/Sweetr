//
//  SocialData.swift
//  Sweetr
//
//  Created by James Williams on 5/18/15.
//  Copyright (c) 2015 James Williams. All rights reserved.
//
// singleton equals one instance of social data it will never change or be a new object

//NSNotificationCenter.defaultCenter()
//NSOperationQueue.mainQueue()
//NSUserDefaults.standardUserDefaults()
// all singletons


import UIKit


private let _singleton = SocialData()


class SocialData: NSObject {
    
    var twitterName = ""
    
    class func mainData() -> SocialData { return _singleton }
   
}
