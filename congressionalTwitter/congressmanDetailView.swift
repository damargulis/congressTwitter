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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chamberLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var partyImageView: UIImageView!
    
    @IBOutlet weak var voteControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        voteControl.addTarget(self, action: "voteDidChange:", forControlEvents: .ValueChanged)
        
        
        //control login button
        if twitterUser.currentUser != nil {
            loginButton.tag = 1
            loginButton.title = "Logout"
        } else {
            loginButton.tag = 0
            loginButton.title = "Login"
        }
        
        //populate data
        nameLabel.text = congressman.name
        chamberLabel.text = "Chamber: " + congressman.chamber!
        partyLabel.text = "Party: " + congressman.partyName!
        termLabel.text = "Current Term: " + congressman.term!
        
        //populate vote and bills cells
        getPastVotes()
        getSponsoredBills()
        
        //get party image
        if (congressman.partyCode == "D"){
            
            partyImageView.image = UIImage(named: "Donkey")
            
        } else if (congressman.partyCode == "R"){
            
            partyImageView.image = UIImage(named: "Elephant")
            
        } else {
            
            partyImageView.image = UIImage(named: "Congress")
            
        }
        
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
        } else{
            return 0
        }
    }
    
    func getPastVotes(){
        congressAPI.sharedInstance.getVotesByLegislator(congressman, success: { (votes: [vote]) -> () in
            
            self.pastVotes = votes
            self.tableView.reloadData()
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
    }
    
    func getSponsoredBills(){
        congressAPI.sharedInstance.getSponsoredBills(congressman, success: { (bills: [bill]) -> () in
            
            self.sponsoredBills = bills
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
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
            cell.questionLabel.text = bill.official_title
            
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
            
            congressAPI.sharedInstance.getVotesByLegislatorSearch(congressman, search: search, success: { (votes: [vote]) -> () in
                self.pastVotes = votes
                self.tableView.reloadData()
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
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
