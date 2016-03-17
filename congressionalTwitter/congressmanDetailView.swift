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
    var votes: [vote]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chamberLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        if twitterUser.currentUser != nil {
            loginButton.tag = 1
            loginButton.title = "Logout"
        } else {
            loginButton.tag = 0
            loginButton.title = "Login"
        }

        // Do any additional setup after loading the view.
        nameLabel.text = congressman.name
        
        congressAPI.sharedInstance.getVotesByLegislator(congressman, success: { (votes: [vote]) -> () in
            
            self.votes = votes
            self.tableView.reloadData()
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        chamberLabel.text = "Chamber: " + congressman.chamber!
        partyLabel.text = "Party: " + congressman.partyName!
        termLabel.text = "Current Term: " + congressman.term!
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let votes = votes{
            return votes.count
        } else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detailTableCell") as! detailTableViewCell
        
        let vote = votes![indexPath.row]
        
        if congressman.chamber == "senate" {
            cell.questionLabel.text = vote.question
        } else {
            cell.questionLabel.text = vote.title
        }
        
        
        return cell
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let search = searchBar.text
        if(search != nil){
            congressAPI.sharedInstance.getVotesByLegislatorSearch(congressman, search: search, success: { (votes: [vote]) -> () in
            self.votes = votes
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? UITableViewCell{
            let indexPath = tableView.indexPathForCell(cell)
            let avote = votes![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! voteDetailViewController
            detailViewController.congressman = congressman
            detailViewController.thisvote = avote
        }
    }

    
    

}
