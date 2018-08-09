//
//  CategoryCell.swift
//  AskMe
//
//  Created by Maryam Jafari on 4/11/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    var locCategory : String!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var goToDescription: UIButton!
    var delegate : CategoryDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        let color = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
        
        categoryLabel.textColor = color
        if let category = category.text{
            locCategory = category
        }
        goToDescription.setTitleColor(UIColor.gray, for: .normal)
    }
    @IBAction func add(_ sender: Any) {
        let data = locCategory
        if(self.delegate != nil){
            self.delegate.callSegueFromCategoryCell(Data: data! )
        }
    }
    
    func configure(category : String){
        self.category.text = category
    }
    
    
}

