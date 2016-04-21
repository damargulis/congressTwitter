//
//  congressPerson.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/10/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class congressPerson: NSObject {
    
    var type: Int!
    //(0=national, 1=state)

    //both
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var nameSuffix: String?
    var name: String?
    var partyName: String?
    var partyCode: String?
    var stateCode: String?
    var district: String?
    var chamber: String?
    
    //national
    var stateName: String?
    var title: String?
    var termStart: String?
    var termEnd: String?
    var bioGuideId: String!
    var crpId: String!
    var website: String?
    var twitterUsername: String?
    var term: String?
    var ocd_ID: String?
    
    //state
    var photoUrl: String?
    var legID: String?
    



    
    
    init(entry: NSDictionary, type: Int!) {
        self.type = type
        

        
        
        if(type == 0){
            
            firstName = entry["first_name"] as? String
            lastName = entry["last_name"] as? String
            middleName = entry["middle_name"] as? String
            
            
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
            nameSuffix = entry["name_suffix"] as? String
            
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
            crpId = entry["crp_id"] as? String
            ocd_ID = entry["ocd_id"] as? String
            
            website = entry["website"] as? String
            twitterUsername = entry["twitter_id"] as? String
            
            
            if let termStart = termStart{
                if let termEnd = termEnd{
                    term = termStart + " - " + termEnd
                }
            }
            
        }else if(type == 1){
            firstName = entry["first_name"] as? String
            lastName = entry["last_name"] as? String
            middleName = entry["middle_name"] as? String
            
            partyName = entry["party"] as? String
            if(partyName == "Democratic"){
                partyCode = "D"
            }else if(partyName == "Republican"){
                partyCode = "R"
            }else{
                partyCode = "I"
            }
            nameSuffix = entry["suffixes"] as? String
            name = entry["full_name"] as? String
            photoUrl = entry["photo_url"] as? String
            
            stateCode = entry["state"] as? String
            chamber = entry["chamber"] as? String
            district = entry["district"] as? String
            legID = entry["leg_id"] as? String
        }
        

    }
    
    
    class func congressPersonDictToArray(array: [NSDictionary], type: Int!) -> [congressPerson] {
        var people = [congressPerson]()
        
        for dicionary in array{
            people.append(congressPerson(entry: dicionary, type: type))
        }
        
        return people
    }
    
}
