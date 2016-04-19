//
//  stateDetailViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/17/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import CoreLocation

class stateDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var chamberControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var curstate: state!
    var people: [congressPerson]?
    var chambers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        nameLabel.text = curstate.name
        chamberControl.removeAllSegments()
        var i = 0
        for chamber in curstate.chambers{
            let name = chamber.1["name"]
            chamberControl.insertSegmentWithTitle(name as? String, atIndex: i, animated: false)
            i = i + 1
            chambers.append(chamber.key as! String)
        }
        chamberControl.insertSegmentWithTitle("All Representatives", atIndex: i, animated: false)
        
        openStatesAPI.sharedInstance.getLegislatorsByState(curstate, chamber: nil, success: { (people: [congressPerson]) -> () in
            
            self.people = people
            self.tableView.reloadData()
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }

        chamberControl.selectedSegmentIndex = i
        chamberControl.addTarget(self, action: "chamberDidChange:", forControlEvents: .ValueChanged)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let people  = people{
            print(people.count)
            return people.count
        } else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stateDetailCell", forIndexPath: indexPath) as! stateDetailTableViewCell
        let rep = people![indexPath.row]
        cell.nameLabel.text = rep.name
        cell.partyLabel.text = rep.partyName
        cell.districtLabel.text = "District \(rep.district!)"
        return cell
        
    }

    func chamberDidChange(sender: UISegmentedControl){
        var chamber: String?
        if(sender.selectedSegmentIndex < chambers.count){
            chamber = chambers[sender.selectedSegmentIndex]
        }
        print(chamber)
        
        openStatesAPI.sharedInstance.getLegislatorsByState(curstate, chamber: chamber, success: { (people: [congressPerson]) -> () in
            self.people = people
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        
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
