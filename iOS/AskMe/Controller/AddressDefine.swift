//
//  AddressDefine.swift
//  AskMe
//
//  Created by Maryam Jafari on 4/11/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class AddressDefine: UIViewController, UITextViewDelegate {
    
    var userId : String?
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    var delegate : CanReceiveAddressUpdate?
    var locAddress : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        var delegate : CanReceiveAddressUpdate?
        
        address.delegate = self
        let colorLabel = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
        
        let colorButton = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
        
        address.text = locAddress
        addressLabel.textColor = colorLabel
        saveButton.backgroundColor = colorButton
        DBProvider.Instance.getAddress(userId: userId!){(url ) in
            self.address.text = url
            
        }
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: address.frame.size.height - width, width:  address.frame.size.width, height: address.frame.size.height)
        
        border.borderWidth = width
        address.layer.addSublayer(border)
        address.layer.masksToBounds = true
        
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            address.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func clear (){
        address.text = ""
    }
    
    @IBAction func save(_ sender: Any) {
        DBProvider.Instance.updateAddress(userId: userId!, address: self.address.text!)
        DBProvider.Instance.updateHasProfile(userId: userId!, hasProfile : true)
        
        delegate?.addressUpdateRecieved(data: self.address.text!)
        
    }
    
}


