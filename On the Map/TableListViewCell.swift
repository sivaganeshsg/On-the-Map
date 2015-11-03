//
//  TableListViewCell.swift
//  On the Map
//
//  Created by Siva Ganesh on 10/09/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import UIKit

class TableListViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var listImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userLink: UILabel!

}
