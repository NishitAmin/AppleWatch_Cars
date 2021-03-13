//
//  MyDataTableViewCell.swift
//  WatchApp_Cars
//
//  Created by Xcode on 2020-11-29.
//  Copyright © 2020 Nishit Amin. All rights reserved.
//

import UIKit

class MyDataTableViewCell: UITableViewCell {

    @IBOutlet var make : UILabel!
    @IBOutlet var model : UILabel!
    @IBOutlet var year : UILabel!
    @IBOutlet var color : UILabel!
    @IBOutlet var status : UILabel!
    @IBOutlet var price : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
