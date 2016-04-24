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
        
        if(congressperson.type == 0){
        opensecretsAPI.sharedInstance.getContributorsManual(congressperson, success: { (response: NSDictionary) -> () in
            
            
            self.orgs = response["contributors"]!["contributor"] as? [NSDictionary]
            self.tableView.reloadData()
            print(self.orgs)
        })
        } else if(congressperson.type == 1){
            partyLabel.text = "Not currently available"
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contributorCell", forIndexPath: indexPath) as! contributorTableViewCell
        let org1 = orgs![indexPath.row]
        let org = org1["@attributes"] as! NSDictionary
        cell.nameLabel.text = org["org_name"] as? String
        let nf = NSNumberFormatter()
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let indiv = nf.stringFromNumber(nf.numberFromString((org["indivs"] as? String)!)!)
        let pacs = nf.stringFromNumber(nf.numberFromString((org["pacs"] as? String)!)!)
        
        cell.individualLabel.text = "Individuals: $\(indiv!)"
        cell.pacLabel.text = "PAC's: $\(pacs!)"
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? contributorTableViewCell{
            let dvc = segue.destinationViewController as? organizationViewController
            let ip = tableView.indexPathForCell(cell)
            let org1 = orgs![ip!.row]
            let org = org1["@attributes"] as! NSDictionary
            
            dvc?.name = org["org_name"] as? String
            
            
        }
        
    }
    

}
