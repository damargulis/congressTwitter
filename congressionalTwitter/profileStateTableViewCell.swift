//
//  profileStateTableViewCell.swift
//  congressionalTwitter
//
//  Created by Daniel Margulis on 4/20/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class profileStateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
