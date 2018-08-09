//
//  MajorDefine.swift
//  AskMe
//
//  Created by Maryam Jafari on 4/11/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class MajorDefine:  UIViewController, UITextFieldDelegate {
    var userId : String?
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var major: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    var locName : String!
    var delegate : CanReceiveMajorUpdate?
    override func viewDidLoad() {
        super.viewDidLoad()
        major.delegate = self
        let colorLabel = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
        
        let colorButton = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
        
        major.text = locName
        nameLabel.textColor = colorLabel
        saveButton.backgroundColor = colorButton
        DBProvider.Instance.getmajor(userId: userId!){(url ) in
            self.major.text = url
            
        }
        
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: major.frame.size.height - width, width:  major.frame.size.width, height: major.frame.size.height)
        
        border.borderWidth = width
        major.layer.addSublayer(border)
        major.layer.masksToBounds = true
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icons8-info-30"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        button.frame = CGRect(x: CGFloat(major.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.clear), for: .touchUpInside)
        
        
        major.rightView = button
        major.rightViewMode = .always
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func clear (){
        major.text = ""
    }
    @IBAction func save(_ sender: Any) {
        DBProvider.Instance.updateprofile(userId: userId!, major: self.major.text!)
        DBProvider.Instance.updateHasProfile(userId: userId!, hasProfile : true)
        delegate?.MajorUpdateRecieved(data: self.major.text!)
        
    }
    
    
}


