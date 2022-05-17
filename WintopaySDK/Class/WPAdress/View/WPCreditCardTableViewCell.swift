//
//  WPCreditCardTableViewCell.swift
//  WintopaySDK
//
//  Created by 易购付 on 2022/4/8.
//

import UIKit

let WPCreditCardTableViewCellID = "WPCreditCardTableViewCell"
class WPCreditCardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var WPCardNumberTextField: WPPayTextField!
    
    @IBOutlet weak var WPCVVTextField: WPPayTextField!
    
    @IBOutlet weak var WPDateTextField: WPPayTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        WPCardNumberTextField.name = .CardNumber
        WPCVVTextField.name = .CardCVC
        WPDateTextField.name = .CardDate
        
        let basicView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 52, height: 30))
        let cardImageView = UIImageView()
        cardImageView.image = UIImage.init(named: "card.png")
        cardImageView.image = UIImage.WPBundleImage(name:"card.png")
        basicView.addSubview(cardImageView)
        cardImageView.frame = CGRect.init(x: 18, y:0, width: 22, height: 18)
        cardImageView.center = basicView.center
        WPDateTextField.leftView = basicView
        WPDateTextField.leftViewMode = .always
        WPDateTextField.keyboardType = .numberPad
        WPDateTextField.placeholder = "MM/YYYY"
        
        let CVVBasicView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 52, height: 30))
        let CVVImageView = UIImageView()
        CVVImageView.image = UIImage.WPBundleImage(name:"cvc.png")
        CVVBasicView.addSubview(CVVImageView)
        CVVImageView.frame = CGRect.init(x: 0, y:0, width: 22, height: 18)
        CVVImageView.center = basicView.center
        WPCVVTextField.rightView = CVVBasicView
        WPCVVTextField.rightViewMode = .always
        WPCVVTextField.placeholder = "CVC"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
