//
//  openStatesAPI.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/17/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let openStatesApiKey = "520539ff8eda4bd1b6be5c0e6d1691f5"
let openStatesApiBaseUrl = NSURL(string: "http://openstates.org/api/v1/")

class openStatesAPI: BDBOAuth1SessionManager {

    static let sharedInstance = openStatesAPI(baseURL: openStatesApiBaseUrl)
    
    func getMetaData(){
        
        GET("metadata/", parameters: ["apikey": openStatesApiKey], progress: nil, success: { (opeartion:NSURLSessionDataTask, response: AnyObject?) -> Void in
            print(response)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
}
