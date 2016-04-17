//
//  stateViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/17/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class stateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var localStateView: UIView!
    @IBOutlet weak var localStateName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var states: [state]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        openStatesAPI.sharedInstance.getMetaData({ (states: [state]) -> () in
            self.states  = states
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stateCell") as! stateTableViewCell
        let state = states![indexPath.row]
        cell.nameLabel.text = state.name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let states = states{
            return states.count
        }else{
            return 0
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell = sender as? UITableViewCell{
            let indexPath = tableView.indexPathForCell(cell)
            let st = states![indexPath!.row]
            let dvc = segue.destinationViewController as! stateDetailViewController
            dvc.curstate = st
        }
        
    }


}
