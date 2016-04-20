//
//  openStatesAPI.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/17/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import CoreLocation

let openStatesApiKey = "520539ff8eda4bd1b6be5c0e6d1691f5"
let openStatesApiBaseUrl = NSURL(string: "http://openstates.org/api/v1/")

class openStatesAPI: BDBOAuth1SessionManager {

    static let sharedInstance = openStatesAPI(baseURL: openStatesApiBaseUrl)
    
    func getMetaData(success: ([state]) -> (), failure: (NSError) -> ()){
        
        GET("metadata/", parameters: ["apikey": openStatesApiKey], progress: nil, success: { (opeartion:NSURLSessionDataTask, response: AnyObject?) -> Void in
            let states = state.stateDictToArray(response as! [NSDictionary])
            success(states)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
    }
    
    func getLegislatorsByState(stateToSearch: state!, chamber: String?, success: ([congressPerson]) -> (), failure: (NSError) -> ()){
        
        var parameters = ["apikey": openStatesApiKey,]
        parameters["state"] = stateToSearch.abbreviation
        if let chamber = chamber{
            parameters["chamber"] = chamber
        }
        
        GET("legislators/", parameters: parameters, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let people = congressPerson.congressPersonDictToArray(response as! [NSDictionary], type: 1)
            success(people)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
    }
    
    func getLegislatorsByLocation(location: CLLocationCoordinate2D, success: ([congressPerson]) -> (), failure: (NSError) -> ()){
        
        let parameters = ["apikey" : openStatesApiKey,
            "lat": location.latitude,
            "long": location.longitude
        ]
        
        GET("legislators/geo/", parameters: parameters, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let people = congressPerson.congressPersonDictToArray(response as! [NSDictionary], type: 1)
            success(people)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
        
    }
    
    func getSponsoredBills(rep: congressPerson!, success: ([bill]) -> (), failure: (NSError) -> ()){
        
        
        var p = ["apikey": openStatesApiKey]
        p["state"] = rep.stateCode
        p["sponsor_id"] = rep.legID
        
        GET("bills/", parameters: p, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let bills = bill.billsDictToArray(response as! [NSDictionary])
            success(bills)
            }) { (opeartion: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
}
