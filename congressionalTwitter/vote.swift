//
//  vote.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/14/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class vote: NSObject {

    var rollID: String!
    var question: String!
    var result: String!
    var voter_ids: [String: String]!
    
    var title: String?
    
    init(dict: NSDictionary){
        
        rollID = dict["roll_id"] as! String
        question = dict["question"] as! String
        result = dict["result"] as! String
        voter_ids = dict["voter_ids"] as! [String: String]
        
        title = dict["bill"]?["popular_title"] as? String
        if title == nil {
            title = dict["bill"]?["official_title"] as? String
        }
        
    }
    
    
    class func votesDictToArray(array: [NSDictionary]) -> [vote] {
        var people = [vote]()
        
        for dicionary in array{
            people.append(vote(dict: dicionary))
        }
        
        return people
    }
    
}
