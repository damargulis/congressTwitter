//
//  opensecretsAPI.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/14/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

let opensecretApiKey = "fba2da9eab14c612bde22145fe7a7bac"
let opensecretApiBaseUrl = NSURL(string: "https://www.opensecrets.org/")

class opensecretsAPI: BDBOAuth1SessionManager {
    
    static let sharedInstance = opensecretsAPI(baseURL: opensecretApiBaseUrl)
    
    func getContributorsManual(congressman: congressPerson!, success: NSDictionary -> ()){
        
        let url = NSURL(string: "https://www.opensecrets.org/api/?method=candContrib&apikey=\(opensecretApiKey)&output=json&cid=\(congressman.crpId)")
        
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)

        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            let response = responseDictionary["response"]
                            success(response as! NSDictionary)
                            
                    }
                }
                
        })
        task.resume()
        
        
    }
    
    func getContributors(congressperson: congressPerson!, success: ([NSDictionary]) -> (), failure: (NSError) -> ()){
        //Doesnt work!
        
        
        let parameters = [
            "cid": congressperson.crpId,
            "output": "json",
            "apikey": opensecretApiKey,
            "cycle": "2016"] as NSDictionary
        
        GET("api/?method=candContrib", parameters: parameters, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let results = response!["results"] as! [NSDictionary]
            print("here success")
            success(results)
            
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                
                print("here fail")
                failure(error)
        }
        
    }
    
    
    
    
}
