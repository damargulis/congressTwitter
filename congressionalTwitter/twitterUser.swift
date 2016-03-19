//
//  twitterUser.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/14/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class twitterUser: NSObject {
    

    
    var name: NSString?
    var dictionary: NSDictionary!
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        
    }
    
    //track current logged in user
    var _currentUser: twitterUser?
    static var _currentUser: twitterUser?
    class var currentUser: twitterUser?{
        get {
            if _currentUser == nil{
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
        
                if let userData = userData{
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = twitterUser(dictionary: dictionary)
                }
        
        
            }
            return _currentUser
        }
        
        set(user){
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else{
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
    
}
