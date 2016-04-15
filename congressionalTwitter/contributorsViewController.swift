//
//  contributorsViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/14/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class contributorsViewController: UIViewController {

    var congressperson: congressPerson!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = congressperson.name
        
        opensecretsAPI.sharedInstance.getContributors(congressperson!, success: { (result: [NSDictionary]) -> () in
            //do something with result
            print(result)
            
            
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
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
