//
//  googleCivicDataAPI.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/21/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let googleApiKey = "AIzaSyBqZJzKY8ib8dCicVj_TCUEo6-yriZWgpk"
let googleBaseURL = NSURL(string: "https://www.googleapis.com/civicinfo/v2/")

class googleCivicDataAPI: BDBOAuth1SessionManager {

    static let sharedInstance = googleCivicDataAPI(baseURL: googleBaseURL)
    
    func getDivisions(query: String!, success: () -> (), failure: (NSError) -> ()){
        let parameters = ["key": googleApiKey,
                        "query": query]

        GET("divisions", parameters: parameters, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            

            print(response)
            
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
        
    }
    
    func getRepsFromDivision(division: String!, success: () -> (), failure: (NSError) -> ()){
        
        let parameters = ["key": googleApiKey]
        
        print(division)
        
        GET("representatives/\(division)", parameters: parameters, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            print(response)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
        
    }
    
    func getRepsFromAddress(address: String!, failure: (NSError) ->()){
        
        let parameters = ["key": googleApiKey,
                        "address": address]
        GET("representatives", parameters: parameters, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            print(response)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
        
    }
    
    
}
