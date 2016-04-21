//
//  organization.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/21/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class organization: NSObject {
    
    var cycle: String?
    var orgID: String?
    var name: String?
    var total: String?
    var individuals: String?
    var pacs: String?
    var soft: String?
    var dems: String?
    var repubs: String?
    
    init(dict: NSDictionary){
        
        cycle = dict["cycle"] as? String
        orgID = dict["orgid"] as? String
        name = dict["orgname"] as? String
        total = dict["total"] as? String
        
        individuals = dict["indivs"] as? String
        pacs = dict["pacs"] as? String
        soft = dict["soft"] as? String
        
        dems = dict["dems"] as? String
        repubs = dict["repubs"] as? String
        
    }
    

}
