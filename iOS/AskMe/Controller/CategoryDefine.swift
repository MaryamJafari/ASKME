//
//  CategoryDefine.swift
//  AskMe
//
//  Created by Maryam Jafari on 4/11/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class CategoryDefine: UIViewController,UITextFieldDelegate , UIPickerViewDataSource, UIPickerViewDelegate {
    var userId : String?
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var invisibleView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var category2: UITextField!
    @IBOutlet weak var category3: UITextField!
    @IBOutlet weak var category6: UITextField!
    @IBOutlet weak var category4: UITextField!
    @IBOutlet weak var category5: UITextField!
    
    var picker_values = ["Food","Transportation","Housing","Sell","Academic","Financial"]
    var myPicker: UIPickerView! = UIPickerView()
    var doneButton = UIButton()
    var cancelButton = UIButton()
    
    var delegate : CanReceiveCategoryUpdate?
    override func viewDidLoad() {
        super.viewDidLoad()
        category.delegate = self
        category2.delegate = self
        category3.delegate = self
        category4.delegate = self
        category5.delegate = self
        category6.delegate = self
        self.myPicker = UIPickerView()
        self.myPicker.frame =  CGRect(x: 20, y: 0, width: 335, height: 200)
        let colorLabel = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
        
        let colorButton = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
        self.myPicker.delegate = self
        self.myPicker.dataSource = self
        UIView.animate(withDuration: 0.5){
            self.category.addTarget(self, action: #selector(self.categoryPicker(_:)), for: UIControlEvents.editingDidBegin)
            self.category2.addTarget(self, action: #selector(self.categoryPicker(_:)), for: UIControlEvents.editingDidBegin)
            self.category3.addTarget(self, action: #selector(self.categoryPicker(_:)), for: UIControlEvents.editingDidBegin)
            self.category4.addTarget(self, action: #selector(self.categoryPicker(_:)), for: UIControlEvents.editingDidBegin)
            self.category5.addTarget(self, action: #selector(self.categoryPicker(_:)), for: UIControlEvents.editingDidBegin)
            self.category6.addTarget(self, action: #selector(self.categoryPicker(_:)), for: UIControlEvents.editingDidBegin)
            
        }
        
        
        categoryLabel.textColor = colorLabel
        saveButton.backgroundColor = colorButton
        DBProvider.Instance.getCategory(userId: userId!){(url ) in
            self.category.text = url
        }
        DBProvider.Instance.getCategory(userId: userId!){(url ) in
            self.category2.text = url
        }
        DBProvider.Instance.getCategory(userId: userId!){(url ) in
            self.category3.text = url
        }
        DBProvider.Instance.getCategory(userId: userId!){(url ) in
            self.category4.text = url
        }
        DBProvider.Instance.getCategory(userId: userId!){(url ) in
            self.category5.text = url
        }
        DBProvider.Instance.getCategory(userId: userId!){(url ) in
            self.category6.text = url
        }
        
        let border = CALayer()
        let border2 = CALayer()
        let border3 = CALayer()
        let border4 = CALayer()
        let border5 = CALayer()
        let border6 = CALayer()
        let width = CGFloat(2.0)
        
        
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: category.frame.size.height - width, width:  category.frame.size.width, height: category.frame.size.height)
        
        border2.borderColor = UIColor.darkGray.cgColor
        border2.frame = CGRect(x: 0, y: category2.frame.size.height - width, width:  category2.frame.size.width, height: category2.frame.size.height)
        border3.borderColor = UIColor.darkGray.cgColor
        border3.frame = CGRect(x: 0, y: category3.frame.size.height - width, width:  category3.frame.size.width, height: category3.frame.size.height)
        border4.borderColor = UIColor.darkGray.cgColor
        border4.frame = CGRect(x: 0, y: category4.frame.size.height - width, width:  category4.frame.size.width, height: category4.frame.size.height)
        border5.borderColor = UIColor.darkGray.cgColor
        border5.frame = CGRect(x: 0, y: category5.frame.size.height - width, width:  category5.frame.size.width, height: category5.frame.size.height)
        border6.borderColor = UIColor.darkGray.cgColor
        border6.frame = CGRect(x: 0, y: category6.frame.size.height - width, width:  category6.frame.size.width, height: category6.frame.size.height)
        
        border.borderWidth = width
        border2.borderWidth = width
        border3.borderWidth = width
        border4.borderWidth = width
        border5.borderWidth = width
        border6.borderWidth = width
        category.layer.addSublayer(border)
        category.layer.masksToBounds = true
        category2.layer.addSublayer(border2)
        category2.layer.masksToBounds = true
        category3.layer.addSublayer(border3)
        category3.layer.masksToBounds = true
        category4.layer.addSublayer(border4)
        category4.layer.masksToBounds = true
        category5.layer.addSublayer(border5)
        category5.layer.masksToBounds = true
        category6.layer.addSublayer(border6)
        category6.layer.masksToBounds = true
        
    }
    
    
    
    
    @IBAction func save(_ sender: Any) {
        DBProvider.Instance.updateCategory(userId: userId!, category: self.category.text!,category2: self.category2.text!,category3: self.category3.text!,category4: self.category4.text!,category5: self.category5.text!,category6: self.category6.text!)
        let text =  self.category.text! + "  " +  self.category2.text! + "  " +  self.category3.text! + " " +  self.category4.text! + " " +  self.category5.text! + " " +  self.category6.text!
        DBProvider.Instance.updateHasProfile(userId: userId!, hasProfile : true)
        delegate?.categoryUpdateRecieved(data: text)
        
        
    }
    
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker_values.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker_values[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if  category.isFirstResponder {
            category.text = picker_values[row]
        }
        else if  category2.isFirstResponder {
            category2.text = picker_values[row]
        }
        else if  category3.isFirstResponder {
            category3.text = picker_values[row]
        }
        else if  category4.isFirstResponder {
            category4.text = picker_values[row]
        }
        else if  category5.isFirstResponder {
            category5.text = picker_values[row]
        }
        else if  category6.isFirstResponder {
            category6.text = picker_values[row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        pickerView.showsSelectionIndicator = true
        
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = picker_values[row]
        pickerLabel.font = UIFont(name: "Avenir Next", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    @objc func categoryPicker(_ textField: UITextField) {
        
        //Create the view
        let tintColor: UIColor = UIColor(red: 101.0/255.0, green: 98.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        //  viewHeightConstraint.constant = 500
        invisibleView.center.x = invisibleView.center.x
        invisibleView.addSubview(myPicker) // add date picker to UIView
        
        //Create the Done button
        doneButton.frame = CGRect(x: 100/2, y: 0, width: 100, height: 50)
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(tintColor, for: UIControlState.normal)
        doneButton.setTitleColor(tintColor, for: UIControlState.highlighted)
        invisibleView.addSubview(doneButton) // add Button to UIView
        doneButton.addTarget(self, action: #selector(doneButtonclick), for: UIControlEvents.touchUpInside)
        let color = UIColor(red:0.76, green:0.34, blue:0.0, alpha:1.0)
        doneButton.setTitleColor(color, for: .normal)
        doneButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 16)
        
        //Create the Cancel button
        cancelButton.frame = CGRect(x: (self.view.frame.size.width - 3*(100/2)), y: 0, width: 100, height: 50)
        cancelButton.setTitle("Cancel", for: UIControlState.normal)
        cancelButton.setTitle("Cancel", for: UIControlState.highlighted)
        cancelButton.setTitleColor(tintColor, for: UIControlState.normal)
        cancelButton.setTitleColor(tintColor, for: UIControlState.highlighted)
        invisibleView.addSubview(cancelButton) // add Button to UIView
        cancelButton.addTarget(self, action: #selector(cancelPicker), for: UIControlEvents.touchUpInside)
        cancelButton.setTitleColor(UIColor.gray, for: .normal)
        cancelButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 16)
        
        invisibleView.removeFromSuperview()
        textField.inputView = invisibleView
        invisibleView.layoutIfNeeded()
    }
    
    @objc func doneButtonclick() -> Bool{
        saveButton.becomeFirstResponder()
        self.view.endEditing(true)
        return true
        
        // saveButton.becomeFirstResponder()
    }
    
    @objc func cancelPicker(sender:UIButton)-> Bool {
        if  category.isFirstResponder {
            category.text = ""
        }
        else if  category2.isFirstResponder {
            category2.text = ""
        }
        else if  category3.isFirstResponder {
            category3.text = ""
        }
        else if  category4.isFirstResponder {
            category4.text = ""
        }
        else if  category5.isFirstResponder {
            category5.text = ""
        }
        else if  category6.isFirstResponder {
            category6.text = ""
        }
        saveButton.becomeFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    
    
    
}


