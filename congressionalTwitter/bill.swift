//
//  bill.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/17/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class bill: NSObject {
    
    var billId: String?
    
    var official_title: String?
    var popular_title: String?
    var short_title: String?
    //list of all titles as well?
    
    var nicknames: [String]?
    
    var summary: String?
    var summary_short: String?
    
    init(dict: NSDictionary){
        
        billId = dict["bill_id"] as? String
        
        official_title = dict["official_title"] as? String
        popular_title = dict["popular_title"] as? String
        short_title = dict["short_title"] as? String
        nicknames = dict["nicknames"] as? [String]
        summary = dict["summary"] as? String
        summary_short = dict["summary_short"] as? String
        
        print(billId)
        print(official_title)
        print(popular_title)
        print(short_title)
        
    }
    
    class func billsDictToArray(array: [NSDictionary]) -> [bill] {
        var bills = [bill]()
        
        for dicionary in array{
            bills.append(bill(dict: dicionary))
        }
        
        return bills
    }
    

}
