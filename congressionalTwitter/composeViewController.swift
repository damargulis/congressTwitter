//
//  composeViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/16/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class composeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var characterCountLabel: UILabel!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var approve: Bool!
    var toCongressman: congressPerson!
    var thisVote: vote!
    var thisBill: bill!
    var theyVoted: String!
    
    var type: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextView.delegate = self
        
        if(type == 0){
            if approve == true {
                tweetTextView.text = ".@\(toCongressman.twitterUsername!) I approve of your vote of \(theyVoted) on \(thisVote!.rollID)!"
            } else {
                tweetTextView.text = ".@\(toCongressman.twitterUsername!) I disapprove of your vote of \(theyVoted) on \(thisVote!.rollID)!"
            }
        }else if(type == 1){
            if approve == true{
                tweetTextView.text = ".@\(toCongressman.twitterUsername!) I approve of your sponsored bill: \(thisBill!.billId!)!"
            } else{
                tweetTextView.text = ".@\(toCongressman.twitterUsername!) I disapprove of your sponsored bill: \(thisBill!.billId!)!"
            }
        }
        
        let charLeft = 140 - tweetTextView.text.characters.count
        
        characterCountLabel.text = "\(charLeft)/140 Characters Remaining"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Control character count
    func textViewDidChange(textView: UITextView) {
        let numCharacters = textView.text.characters.count
        
        let numLeft = 140-numCharacters
        characterCountLabel.text = "\(numLeft)/140 Characters Remaining"
        
    }
    
    //Send tweet
    @IBAction func onSend(sender: AnyObject) {
        twitterAPI.sharedInstance.postStatus(tweetTextView.text)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //Cancel tweet
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
