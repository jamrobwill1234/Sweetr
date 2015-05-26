//
//  Request.swift
//  Sweetr
//
//  Created by James Williams on 5/18/15.
//  Copyright (c) 2015 James Williams. All rights reserved.
//

import Foundation
import CoreLocation



class FourSquareRequest {
    
    let API_URL = "https://api.foursquare.com/v2/"
    let CLIENT_ID = "4FP4Y43MH4HNTJ2YS1HXONYQ2KYJLMPR0UZE1Y2C2ZLMD3Z5"
    let CLIENT_SECRET = "ZDOAJYGNN5HG4T4SLZSKQJ1VEGNY1U5NAFTMTXURNA5LDWOQ"
    
    
    
}

func getVenuesWithLocation(location: CLLocation, completion: (venues: [AnyObject]) -> ())
{
    
    
    
    
    
    
}



class TwitterRequest {
    
    let API_URL = "https://api.twitter.com/1.1/"
    let API_KEY = "SA5ZVnyWSe8KcphTFYjaDCCTu"
    let API_SECRET = "JlWaWli1yKhHTJ6GdYgJDf9e9xKxxyA37WbOgoeZzLWqfRL7CF"
    
    var API_ENCODED: String? {
        get {
            
            let str = API_KEY + ":" + API_SECRET
            
            let utf8str = str.dataUsingEncoding(NSUTF8StringEncoding)
            
            if let encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros){
                
                return "Basic " + encoded
            }
            return nil
        }
    }
    
    
    
    
    
    var TOKEN: String? {
        
        get {
            
            return NSUserDefaults.standardUserDefaults().objectForKey("twitterToken") as? String
        }
        
        set {
            
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "twitterToken")
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    func getToken(completion: () -> ()) {
        let endpoint = "https://api.twitter.com/oauth2/token?grant_type=client_credentials"
        if let url = NSURL(string: endpoint) {
            var request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            
            request.setValue(API_ENCODED, forHTTPHeaderField: "Authorization")
            
            request.setValue("application/x-www-form-urlencoded;charset=UTF-8.", forHTTPHeaderField: "Content-Type")
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                
                var error: NSError? = nil
                
                if let returnInfo = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? [String:AnyObject] {
                    
                    println(returnInfo)
                    
                    
                    self.TOKEN = returnInfo["access_token"] as? String
                    
                    completion()
                    
                }
                
                if let error = error {
                    
                    println(error)
                }
                
            })
            
            
        }
        
        
    }
    func findPopularFoodTweets(completion: (tweets: [AnyObject]) -> ()) {
        
        if TOKEN == nil {
            
            getToken({ () -> () in
                
                self.findPopularFoodTweets(completion)
                
            })
            return // if there is no token we will not go any further
        }
        
        let endpoint = API_URL + "search/tweets.json?q=Food&result_type=popular"
        
        
        if let url = NSURL(string: endpoint) {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.setValue("Bearer " + TOKEN!, forHTTPHeaderField: "Authorization")
            // this is ok to force unwrap because the line above will prevent it from crashing by returning nil 
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                
                var error: NSError? = nil
                
                if let searchInfo = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? [String: AnyObject] {
                    
                    if let tweets = searchInfo["statuses"] as? [AnyObject] {
                        
                        println(tweets)
                        completion(tweets: tweets)

                    }
                    
                   
                                       
                }
                
                if let error = error {
                    
                    println(error)
                }
                
            })
            
        }
    }
    
    
}
