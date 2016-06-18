//
//  settingsViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/21/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var topicsTable: UITableView!

    var followedLegislators: [congressPerson] = [congressPerson]()
    var allTopics: [String] = [String]()
    var following: [Bool]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topicsTable.dataSource = self
        topicsTable.delegate = self
        
        allTopics = ["Foreign Policy", "Homeland Security", "War & Peace", "Free Trade", "Immigration", "Energy & Oil", "Gun Control", "Crime", "Drugs", "Healthcare", "Technology", "Enviornment", "Budget & Economy", "Government Reform", "Tax Reform", "Social Security", "Corporations", "Jobs", "Education", "Civil Rights", "Abortion", "Families & Children", "Welfare & Poverty", "Principles & Values"]
        allTopics.sortInPlace()

        if let follow = NSUserDefaults.standardUserDefaults().valueForKey("following"){
            following = follow as! [Bool]
        }else{
            following = [Bool](count: allTopics.count, repeatedValue: false)
        }
        
        topicsTable.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == topicsTable){
            return allTopics.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(tableView == topicsTable){
            let cell = tableView.dequeueReusableCellWithIdentifier("topicCell", forIndexPath: indexPath) as UITableViewCell
            if(following[indexPath.row]){
                cell.accessoryType = .Checkmark
            }else{
                cell.accessoryType = .None
            }
            cell.textLabel!.text = allTopics[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == topicsTable){
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                if(following[indexPath.row]){
                    cell.accessoryType = .None
                    following[indexPath.row] = false
                }else{
                    cell.accessoryType = .Checkmark
                    following[indexPath.row] = true
                }
            }
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(following, forKey: "following")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        
    }


}
