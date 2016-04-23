//
//  twitterAPI.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/14/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let twitterConsumerKey = "jUtKyKeI5PX9iMUpvmBLucq1e"
let twitterConsumerSecret = "9DdAmWPTZhNBRKgdsRhMfD9gB7EXFDaBCOilVEiPZnEtTDRDfZ"

class twitterAPI: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: twitterUser?, error: NSError?) -> ())?
    
    static let sharedInstance = twitterAPI(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)

    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError)->())?
    
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: twitterUser) -> () in
                twitterUser.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            
            }) {(error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }

    //get curret account
    func currentAccount(success: (twitterUser) -> (), failure: (NSError) -> ()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            
            let user = twitterUser(dictionary: response as! NSDictionary)
            
            success(user)
            
            self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    
    //login to twitter
    func login(success: () -> (), failure: (NSError)->()) {
        loginSuccess = success
        loginFailure = failure
        
        twitterAPI.sharedInstance.deauthorize()
        twitterAPI.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "congressTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    //logout of twitter
    func logout(){
        twitterUser.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(twitterUser.userDidLogoutNotification, object: nil)
        
    }
    
    //create and send tweet
    func postStatus(text: String!){
       
        
        POST("https://api.twitter.com/1.1/statuses/update.json", parameters: ["status": text], progress: { (NSProgress) -> Void in
            }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in

            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
    func getTweets(username: String!, success: ([tweet]) -> (), failure: (NSError) -> ()){
        
        
        let parameters = ["screen_name": username, "include_rts": "false", "exclude_replies": "true"]
        
        GET("https://api.twitter.com/1.1/statuses/user_timeline.json", parameters: parameters, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = tweet.tweetsWithArray(response as! [NSDictionary])
            success(tweets)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
        
    }
    
    

}
