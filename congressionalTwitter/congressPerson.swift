//
//  congressPerson.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/10/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class congressPerson: NSObject {

    //Taken directly from API
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var nameSuffix: String?
    var partyCode: String?
    var stateCode: String?
    var stateName: String?
    var district: String?
    var title: String?
    var chamber: String?
    var termStart: String?
    var termEnd: String?
    var bioGuideId: String!
    var website: String?
    var twitterUsername: String?
    
    //Calculated
    var name: String?
    var partyName: String?
    var term: String?
    
    init(entry: NSDictionary) {
        
        firstName = entry["first_name"] as? String
        lastName = entry["last_name"] as? String
        middleName = entry["middle_name"] as? String
        nameSuffix = entry["name_suffix"] as? String
        
        if let middleName = middleName{
            name = firstName! + " " + middleName + " " + lastName!
        } else {
            name = firstName! + " " + lastName!
        }
        
        if let nameSuffix = nameSuffix{
            name = name! + " " + nameSuffix
        }
        
        partyCode = entry["party"] as? String
        if(partyCode == "D"){
            partyName = "Democrat"
        } else if(partyCode == "R"){
            partyName = "Republican"
        } else if(partyCode == "I"){
            partyName = "Independent"
        }
        
        
        stateCode = entry["state"] as? String
        stateName = entry["state_name"] as? String
        district = entry["district"] as? String
        title = entry["title"] as? String
        
        if let title = title{
            name = title + ". " + name!
        }
        
        chamber = entry["chamber"] as? String
        termStart = entry["term_start"] as? String
        termEnd = entry["term_end"] as? String
        
        bioGuideId = entry["bioguide_id"] as? String
        
        website = entry["website"] as? String
        twitterUsername = entry["twitter_id"] as? String
        
        
        if let termStart = termStart{
            if let termEnd = termEnd{
                term = termStart + " - " + termEnd
            }
        }
        
        
        
    }
    
    
    class func congressPersonDictToArray(array: [NSDictionary]) -> [congressPerson] {
        var people = [congressPerson]()
        
        for dicionary in array{
            people.append(congressPerson(entry: dicionary))
        }
        
        return people
    }
    
}
