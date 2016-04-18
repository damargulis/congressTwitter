//
//  stateDetailTableViewCell.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/18/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class stateDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
