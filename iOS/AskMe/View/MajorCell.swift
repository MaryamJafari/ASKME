//
//  MajorCell.swift
//  AskMe
//
//  Created by Maryam Jafari on 4/11/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class MajorCell: UITableViewCell {
    
    var locationName : String!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var goToDescription: UIButton!
    
    var delegate : NameDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let color = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
        
        nameLabel.textColor = color
        
        if let locName = name.text{
            locationName = locName
        }
        goToDescription.setTitleColor(UIColor.gray, for: .normal)
    }
    
    func configure(name : String){
        self.name!.text = name
    }
    @IBAction func addName(_ sender: Any) {
        
        let data = locationName
        if(self.delegate != nil){
            self.delegate.callSegueFromNameCell(Data: data! )
        }
    }
    
}

