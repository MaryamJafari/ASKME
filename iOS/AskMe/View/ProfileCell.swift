//
//  ProfileCell.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/24/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileCell: UITableViewCell {
    let color = UIColor(red: 0.2, green: 0.3843, blue: 0.5961, alpha: 1.0) /* #336298 */
    let gold = UIColor(red: 0.6431, green: 0.5373, blue: 0.1647, alpha: 1.0) /* #a4892a */

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var interests: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var name: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
        
    }
    
    func configureCell(profile : Profile){
        
        let url = URL(string:profile.imageURl)
        let data = try? Data(contentsOf: url!)
        let image: UIImage = UIImage(data: data!)!
        
        
        name.text = profile.name.capitalized
     
        profileImage.image = image
        major.text = profile.major
        address.text = profile.address
        interests.text = profile.interest1 + " "  + profile.interest2 + " " + profile.interest3 + " " + profile.interest4 + " " + profile.interest5 + " " + profile.interest6 + " "
        
    }
    
}

