//
//  WPBillAddresslTableViewCell.swift
//  payAdress
//
//  Created by 易购付 on 2022/4/13.
//

import UIKit

let WPBillAddresslTableViewCellID = "WPBillAddresslTableViewCell"
class WPBillAddresslTableViewCell: UITableViewCell {
    
    ///输入框
    @IBOutlet weak var WPAdressTextField: WPPayTextField!
    
    ///标题名
    @IBOutlet weak var WPAdressName: UILabel!
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
