//
//  organizationViewController.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/21/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class organizationViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var individualLabel: UILabel!
    
    @IBOutlet weak var pacLabel: UILabel!
    
    @IBOutlet weak var demLabel: UILabel!
    
    @IBOutlet weak var repLabel: UILabel!
    
    var name: String!
    var org: organization!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)
        opensecretsAPI.sharedInstance.getOrganizationSummaryFromName(name, success: { (org: organization) -> () in
            
            self.org = org
            self.nameLabel.text = org.name
            self.individualLabel.text = "Individual Contributions: $\(org.individuals!)"
            self.pacLabel.text = "PAC Contributions: $\(org.pacs!)"
            self.demLabel.text = "Given to Democrats: $\(org.dems!)"
            self.repLabel.text = "Given to Republicans: $\(org.repubs!)"
            
            })
        


        // Do any additional setup after loading the view.
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
