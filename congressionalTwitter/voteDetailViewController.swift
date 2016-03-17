//
//  voteDetailViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/14/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class voteDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var disapproveButton: UIButton!
    
    
    var congressman: congressPerson!
    var thisvote: vote!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if twitterUser.currentUser != nil {
            
            loginButton.tag = 1
            loginButton.title = "Logout"
            
        } else {
            loginButton.tag = 0
            loginButton.title = "Login"
        }

        approveButton.tag = 0
        disapproveButton.tag = 1
        
        
        nameLabel.text = congressman.name
        questionLabel.text = thisvote.question
        resultLabel.text = thisvote.result
        
        voteLabel.text = thisvote.voter_ids[congressman.bioGuideId]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogin(sender: AnyObject) {
        
        if (sender.tag == 0){
            let client = twitterAPI.sharedInstance
            
            client.login({ () -> () in
                
                self.loginButton.title = "Logout"
                self.loginButton.tag = 1
                
                }) { (error: NSError) -> () in
                    print(error.localizedDescription)
            }
            
            
            
        } else {
            
            twitterAPI.sharedInstance.logout()
            
            loginButton.title = "Login"
            loginButton.tag = 0
            
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let composeView = segue.destinationViewController as! composeViewController
        
        composeView.toCongressman = self.congressman
        composeView.thisVote = self.thisvote
        composeView.theyVoted = thisvote.voter_ids[congressman.bioGuideId]
        
        if sender!.tag == 0 {
            composeView.approve = true
        } else {
            composeView.approve = false
        }
        
    }
    

}
