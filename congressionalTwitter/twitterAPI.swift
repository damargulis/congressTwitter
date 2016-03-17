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

    
    func currentAccount(success: (twitterUser) -> (), failure: (NSError) -> ()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //print("user: \(response)")
            
            let user = twitterUser(dictionary: response as! NSDictionary)
            
            success(user)
            
            self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
        
    }
    
    func loginWithCompletion(completion: (user: twitterUser?, error: NSError?) -> ()){
        loginCompletion = completion
        
        
        //fetch request token and redirect to auth page
        twitterAPI.sharedInstance.requestSerializer.removeAccessToken()
        twitterAPI.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "congressTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            
            }) {(error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                
                self.loginCompletion?(user: nil, error: error)
        }
        
        
    }
    
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
    
    func logout(){
        twitterUser.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(twitterUser.userDidLogoutNotification, object: nil)
        
    }
    
    
    func postStatus(text: String!){
       
        
        POST("https://api.twitter.com/1.1/statuses/update.json", parameters: ["status": text], progress: { (NSProgress) -> Void in
            print("progress")
            }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
                print("success")
            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error")
        }
    }
    
    
    

}
