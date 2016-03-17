//
//  congressAPI.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/10/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import CoreLocation


let apiKey = "520539ff8eda4bd1b6be5c0e6d1691f5"
let apiBaseUrl = NSURL(string: "https://congress.api.sunlightfoundation.com/")

class congressAPI: BDBOAuth1SessionManager {
    
    static let sharedInstance = congressAPI(baseURL: apiBaseUrl)
    
    func getLegislators(page: Int, success: ([congressPerson]) -> (), failure: (NSError) -> ()){
        
        let parameters = ["order": "state__asc,last_name__asc",
                        "page": page]
    
        GET("legislators?apikey=\(apiKey)", parameters: parameters, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //print("resonse: \(response)")
            
            let people = congressPerson.congressPersonDictToArray(response!["results"] as! [NSDictionary])
            success(people)
            
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
        
        
    }
    
    func getLocalLegislators(location: CLLocationCoordinate2D, success: ([congressPerson]) -> (), failure: (NSError) ->()){
        let parameters = ["apikey" : apiKey,
                        "latitude": location.latitude,
                        "longitude": location.longitude
        ]
        
        GET("legislators/locate", parameters: parameters, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let people = congressPerson.congressPersonDictToArray(response!["results"] as! [NSDictionary])
            success(people)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
        
        
    }
    
    func getVotesByLegislator(congressperson: congressPerson!, success: ([vote]) -> (), failure: (NSError) -> ()){
        
        let urlString = "votes?voter_ids.\(congressperson.bioGuideId)__exists=true"
        
        GET(urlString, parameters: ["apikey": apiKey, "fields": "voter_ids,question,result,roll_id,roll_type,bill",
            "order": "voted_at"], progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print(response)
            let votes = vote.votesDictToArray(response!["results"] as! [NSDictionary])
            success(votes)
            
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
        
        
        
    }
    
    func getVotesByLegislatorSearch(congressperson: congressPerson!, search: String!, success: ([vote]) -> (), failure: (NSError) -> ()){
        
        let urlString = "votes?voter_ids.\(congressperson.bioGuideId)__exists=true"
        
        GET(urlString, parameters: ["apikey": apiKey, "fields": "voter_ids,question,result,roll_id,roll_type,bill",
            "order": "voted_at",
            "query": search], progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print(response)
                let votes = vote.votesDictToArray(response!["results"] as! [NSDictionary])
                success(votes)
                
                
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
        
        
        
    }
    
    
}
