//
//  state.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/17/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class state: NSObject {
    
    
    var name: String!
    var abbreviation: String!
    var chambers: NSDictionary!
    
    init(dict: NSDictionary){
        
        name = dict["name"] as? String
        abbreviation = dict["abbreviation"] as? String
        chambers = dict["chambers"] as? NSDictionary
        
    }
    
    class func stateDictToArray(array: [NSDictionary]) -> [state] {
        var states = [state]()
        
        for dicionary in array{
            states.append(state(dict: dicionary))
        }
        
        return states
    }
}
