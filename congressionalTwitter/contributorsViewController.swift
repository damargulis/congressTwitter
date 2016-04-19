//
//  contributorsViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/14/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class contributorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    

    var congressperson: congressPerson!
    var orgs: [NSDictionary]?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = congressperson.name
        partyLabel.text = congressperson.partyName
        
        tableView.delegate = self
        tableView.dataSource = self
        
        opensecretsAPI.sharedInstance.getContributorsManual(congressperson, success: { (response: NSDictionary) -> () in
            
            
            self.orgs = response["contributors"]!["contributor"] as? [NSDictionary]
            self.tableView.reloadData()
            print(self.orgs)
        })
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contributorCell", forIndexPath: indexPath) as! contributorTableViewCell
        let org1 = orgs![indexPath.row]
        let org = org1["@attributes"] as! NSDictionary
        cell.nameLabel.text = org["org_name"] as? String
        cell.individualLabel.text = "Individuals: $\(org["indivs"] as! String)"
        cell.pacLabel.text = "PAC's: $\(org["pacs"]as! String)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let orgs = orgs{
            return orgs.count
        }else{
            return 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
