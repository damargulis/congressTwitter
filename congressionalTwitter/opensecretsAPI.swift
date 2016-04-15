//
//  opensecretsAPI.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/14/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let opensecretApiKey = "fba2da9eab14c612bde22145fe7a7bac"
let opensecretApiBaseUrl = NSURL(string: "https://www.opensecrets.org/")


class opensecretsAPI: BDBOAuth1SessionManager {

    static let sharedInstance = opensecretsAPI(baseURL: opensecretApiBaseUrl)

    func getContributors(congressperson: congressPerson!, success: ([NSDictionary]) -> (), failure: (NSError) -> ()){
        
        let parameters = [
            "cid": congressperson.crpId,
            "output": "json",
            "apikey": opensecretApiKey] as NSDictionary
        
        
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
