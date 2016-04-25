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
    var screenname: String?
    var profileImageUrl: NSURL?
    var headerImageUrl: NSURL?
    var tagline: String?
    var followerCount: Int?
    var followingCount: Int?
    var tweetCount: Int?
    var location: String?
    var following: Bool?
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let imageUrl = dictionary["profile_image_url"] as? String
        if let imageUrl = imageUrl{
            profileImageUrl = NSURL(string: imageUrl)
        }
        let headerUrl = dictionary["profile_banner_url"] as? String
        if let headerUrl = headerUrl{
            headerImageUrl = NSURL(string: headerUrl)
        }
        
        
        tagline = dictionary["description"] as? String
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetCount = dictionary["statuses_count"] as? Int
        
        location = dictionary["location"] as? String
        if let f = dictionary["following"] as? Bool{
            if(f){
                following = true
            }else{
                following = false
            }
        }
        
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
