//
//  congressmanDetailView.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 3/11/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class congressmanDetailView: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var congressman: congressPerson!
    var pastVotes: [vote]?
    var sponsoredBills: [bill]?
    var tweets: [tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chamberLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var partyImageView: UIImageView!
    
    @IBOutlet weak var voteControl: UISegmentedControl!

    @IBOutlet weak var followButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        voteControl.addTarget(self, action: #selector(congressmanDetailView.voteDidChange(_:)), forControlEvents: .ValueChanged)
        
        if let twitterUsername = congressman.twitterUsername{
            
            twitterAPI.sharedInstance.getUser(twitterUsername, success: { (account: twitterUser) -> () in
                self.congressman.twitterAccount = account
                if let url = account.profileImageUrl{
                    self.partyImageView.setImageWithURL(url)
                }else{
                    if (self.congressman.partyCode == "D"){
                        self.partyImageView.image = UIImage(named: "Donkey")
                    } else if (self.congressman.partyCode == "R"){
                        self.partyImageView.image = UIImage(named: "Elephant")
                    } else {
                        self.partyImageView.image = UIImage(named: "Congress")
                    }
                }
                if let following = account.following{
                    if(following){
                        self.followButton.setTitle("Unfollow", forState: .Normal)
                    }else{
                        self.followButton.setTitle("Follow", forState: .Normal)
                    }
                }
                
                }, failure: { (error: NSError) -> () in
                    print("didnt get account")
                    print(error.localizedDescription)
                    if (self.congressman.partyCode == "D"){
                        self.partyImageView.image = UIImage(named: "Donkey")
                    } else if (self.congressman.partyCode == "R"){
                        self.partyImageView.image = UIImage(named: "Elephant")
                    } else {
                        self.partyImageView.image = UIImage(named: "Congress")
                    }

            })
            
        } else{
            if let url = congressman.photoUrl{
                self.partyImageView.setImageWithURL(NSURL(string: url)!)
            }
            
        }
        
        
        //control login button
        if twitterUser.currentUser != nil {
            loginButton.tag = 1
            loginButton.title = "Logout"
        } else {
            loginButton.tag = 0
            loginButton.title = "Login"
        }
        
        //populate data
        if let name = congressman.name{
            nameLabel.text = name
        }
        if let chamber = congressman.chamber{
            chamberLabel.text = "Chamber: " + chamber.capitalizedString
        }
        if let party = congressman.partyName{
            partyLabel.text = "Party: " + party
        }
        if let term = congressman.term{
            termLabel.text = "Current Term: " + term
        }

            //populate vote and bills cells
        getPastVotes()
        getSponsoredBills()
        getTweets()
        
        //tabeview autolayout control
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(voteControl.selectedSegmentIndex == 0){
            if let votes = pastVotes{
                return votes.count
            }else{
                return 0
            }
        }else if(voteControl.selectedSegmentIndex == 1){
            if let bills = sponsoredBills{
                return bills.count
            } else{
                return 0
            }
        } else if(voteControl.selectedSegmentIndex == 2){
            if let tweets = tweets{
                return tweets.count
            } else{
                return 0
            }
        } else{
            return 0
        }
    }
    
    func getPastVotes(){
        if(congressman.type == 0){
        congressAPI.sharedInstance.getVotesByLegislator(congressman, success: { (votes: [vote]) -> () in
            
            self.pastVotes = votes
            self.tableView.reloadData()
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        } else if(congressman.type == 1){
            
        }
    }
    
    func getSponsoredBills(){
        if(congressman.type == 0){
        congressAPI.sharedInstance.getSponsoredBills(congressman, searchText: nil, success: { (bills: [bill]) -> () in
            
            self.sponsoredBills = bills
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        } else if(congressman.type == 1){
            
            openStatesAPI.sharedInstance.getSponsoredBills(congressman, success: { (bills: [bill]) -> () in
                self.sponsoredBills = bills
                self.tableView.reloadData()
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
            
        }
    }
    
    func getTweets(){
        if(congressman.type == 0){
            twitterAPI.sharedInstance.getTweets(congressman.twitterUsername, success: { (tweets: [tweet]) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                
                
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
            
        }else if(congressman.type == 1){
            //twitter accounts not currently available for state legislators
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("detailTableCell") as! detailTableViewCell
                
        if(voteControl.selectedSegmentIndex == 0){
            let vote = pastVotes![indexPath.row]
            //Senate votes use question, House uses title
            if congressman.chamber == "senate" {
                cell.questionLabel.text = vote.question
            } else {
                cell.questionLabel.text = vote.title
            }
        }else if(voteControl.selectedSegmentIndex == 1){
            let bill = sponsoredBills![indexPath.row]
            if let title = bill.official_title{
                cell.questionLabel.text = title
            }else if let title = bill.title{
                cell.questionLabel.text = title
            }
            
        }else if(voteControl.selectedSegmentIndex == 2){
            let tweet = tweets![indexPath.row]
            cell.questionLabel.text = tweet.text
            
        }
        cell.layoutIfNeeded()
        
        return cell
    }
    
    
    //Twitter login/logout controlls
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
    
    
    //Search Bar Controlls
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let search = searchBar.text
        
        if(search != nil){
            if(voteControl.selectedSegmentIndex == 0){
                
                if(congressman.type == 0){
                    congressAPI.sharedInstance.getVotesByLegislatorSearch(congressman, search: search, success: { (votes: [vote]) -> () in
                        self.pastVotes = votes
                        self.tableView.reloadData()
                        }, failure: { (error: NSError) -> () in
                            print(error.localizedDescription)
                    })
                }
                
            } else if(voteControl.selectedSegmentIndex == 1){
                
                if(congressman.type == 0){
                    congressAPI.sharedInstance.getSponsoredBills(congressman, searchText: search, success: { (bills: [bill]) -> () in
                        self.sponsoredBills = bills
                        self.tableView.reloadData()
                        }, failure: { (error: NSError) -> () in
                            print(error.localizedDescription)
                    })
                }
                
            } else if(voteControl.selectedSegmentIndex == 2){
                
                if(congressman.type == 0){
                    
                    twitterAPI.sharedInstance.searchTweets(congressman.twitterUsername!, query: search, success: { (tweets: [tweet]) in
                        self.tweets = tweets
                        self.tableView.reloadData()
                        }, failure: { (error: NSError) in
                            print(error.localizedDescription)
                    })
                }
                
            }
        }else{
            
            
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        if(voteControl.selectedSegmentIndex == 0){
            getPastVotes()
        }else if(voteControl.selectedSegmentIndex == 1){
            getSponsoredBills()
        }else if(voteControl.selectedSegmentIndex == 2){
            getTweets()
        }
    }
    
    @IBAction func onTapFollow(sender: AnyObject) {
        print("taping follow")
        
        if let following = congressman.twitterAccount?.following{
            print("following exists")
            if(following){
                
                twitterAPI.sharedInstance.unfollow(congressman.twitterUsername, success: { () -> () in
                    print("unfollowed")
                    self.congressman.twitterAccount?.following = false
                    self.followButton.setTitle("Follow", forState: .Normal)
                    
                    }, failure: { (error: NSError) -> () in
                        print(error.localizedDescription)
                })
                
            }else{
                
                twitterAPI.sharedInstance.follow(congressman.twitterUsername, success: { () -> () in
                    print("followed")
                    self.congressman.twitterAccount?.following = true
                    self.followButton.setTitle("Unfollow", forState: .Normal)
                    }, failure: { (error: NSError) -> () in
                        print(error.localizedDescription)
                })
                
            }
        }

        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    //Seque to voteDetailView
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? UITableViewCell{
            let indexPath = tableView.indexPathForCell(cell)
            let detailViewController = segue.destinationViewController as! voteDetailViewController
            detailViewController.congressman = congressman
            if(voteControl.selectedSegmentIndex == 0){
                
                let avote = pastVotes![indexPath!.row]
                detailViewController.thisvote = avote
                
            }else if(voteControl.selectedSegmentIndex == 1){
                
                let abill = sponsoredBills![indexPath!.row]
                detailViewController.thisbill = abill
                
            }else if(voteControl.selectedSegmentIndex == 2){
                
                let atweet = tweets![indexPath!.row]
                detailViewController.thistweet = atweet
                
            }
        } else if let _ = sender as? UIButton{
            let contributorViewController = segue.destinationViewController as! contributorsViewController
            contributorViewController.congressperson = congressman
        }
        
        
    }
    
    func voteDidChange(sender: UISegmentedControl){
        tableView.reloadData()
    }
    
    
}
