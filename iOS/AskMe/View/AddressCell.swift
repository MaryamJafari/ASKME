//
//  AddressCell.swift
//  AskMe
//
//  Created by Maryam Jafari on 4/11/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    var locationAddress : String!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var addressLebel: UILabel!
    @IBOutlet weak var goToDescription: UIButton!
    var delegate : AddressDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        let color = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
        
        addressLebel.textColor = color
        if let locAddress = address.text{
            locationAddress = locAddress
        }
        goToDescription.setTitleColor(UIColor.gray, for: .normal)
    }
    @IBAction func add(_ sender: Any) {
        let data = locationAddress
        if(self.delegate != nil){
            self.delegate.callSegueFromAddressCell(Data: data! )
        }
    }
    func configure(address : String){
        self.address.text = address
    }
    
}

