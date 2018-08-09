//
//  ProfileViewController.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/19/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import  FirebaseDatabase
import Firebase
import MapKit
import CoreLocation
import  GeoFire
class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, CategoryDelegate,NameDelegate, AddressDelegate, CanReceiveMajorUpdate,CanReceiveAddressUpdate, CanReceiveCategoryUpdate, CanReceiveSchoolYearUpdate {
    var updatedCategory : String!
    var text = ""
    var showStart : Bool = false
    var updatedAddress: String!
    var updatedMajor: String!
    var updatedSchoolYear: String!
    func MajorUpdateRecieved(data: String) {
        updatedMajor = data
        tableView.reloadData()
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func start(_ sender: Any) {
        if majorValue != ""{
            performSegue(withIdentifier: "FromProfileToStart", sender: "")
        }
        else{
            let refreshAlert = UIAlertController(title: "Required Information", message: "Major is required", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                
            }))
            
            
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
    
    func addressUpdateRecieved(data: String) {
        updatedAddress = data
        tableView.reloadData()
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func categoryUpdateRecieved(data: String) {
        updatedCategory = data
        tableView.reloadData()
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func schoolYearUpdateRecieved(data: String) {
        updatedSchoolYear = data
        tableView.reloadData()
    }
    
    func callSegueFromCategoryCell(Data dataobject: String) {
        performSegue(withIdentifier: "AddCategory", sender: CategoryCell().locCategory)
        
    }
    
    @IBOutlet weak var major: UITextField!
    var userID : String!
    var email : String!
    var photURL : URL!
    var selectedRow: String!
    var newMajor : String!
    var newschoolYear : String!
    var newinterests : String!
    var newAddress: String!
    var long : Double!
    var lat : Double!
    var majorValue : String?
    
    
    var pickerData = ["Food","Transportation","Housing","Sell","Academic","Financial"]
    var newlocation : CLLocationCoordinate2D!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func LogOut(_ sender: Any) {
        if AuthProvider.Instance.logOut(){
            DBProvider.Instance.updateNotificationToken(userID: userID, token: "")
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.name.text = email
        let  imageURL = photURL
        let data = try? Data(contentsOf: imageURL!)
        self.image.image = UIImage(data: data!)!
        let color = UIColor(red: 0.0078, green: 0.6588, blue: 0.8588, alpha: 1.0) /* #02a8db */
        if showStart {
            startButton.isHidden = false
        }
        else {
            startButton.isHidden = true
        }
        if majorValue != ""{
            startButton.isEnabled    = true
        }
        else{
            startButton.isEnabled    = false
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color]
        
        tableView.delegate = self
        tableView.dataSource = self
        major?.textColor = color
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row  {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as? MajorCell
            cell?.delegate = self
            if(updatedMajor != nil){
                cell?.configure(name: self.updatedMajor )
            }
            DBProvider.Instance.getmajor(userId: userID){(url ) in
                cell?.configure(name: url )
                self.majorValue =  url
                
            }
            
            return cell!
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as? AddressCell
            cell?.delegate = self
            if(updatedAddress != nil){
                cell?.configure(address: self.updatedAddress)
            }
            
            DBProvider.Instance.getAddress(userId: userID){(url ) in
                cell?.configure(address: url )
                
            }
            return cell!
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell
            cell?.delegate = self
            
            if(updatedCategory != nil){
                cell?.configure(category:  self.updatedCategory)
            }
            else{
                DBProvider.Instance.getCategory(userId: userID){(data ) in
                    self.text = self.text + data + " "
                    cell?.configure(category: self.text )
                    
                }
                DBProvider.Instance.getCategory(userId: userID){(url ) in
                    self.text = self.text + url + " "
                    cell?.configure(category: self.text )
                }
                DBProvider.Instance.getCategory(userId: userID){(url ) in
                    self.text = self.text + url + " "
                    cell?.configure(category: self.text )
                }
                DBProvider.Instance.getCategory(userId: userID){(url ) in
                    self.text = self.text + url + " "
                    cell?.configure(category: self.text )
                }
                DBProvider.Instance.getCategory(userId: userID){(url ) in
                    self.text = self.text + url + " "
                    cell?.configure(category: self.text )
                }
                DBProvider.Instance.getCategory(userId: userID){(url ) in
                    self.text = self.text + url + " "
                    cell?.configure(category: self.text )
                }
                
            }
            
            return cell!
            
        case 3 :
            
            return UITableViewCell()
            
            
        default:
            return UITableViewCell()
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func callSegueFromNameCell(Data dataobject: String) {
        performSegue(withIdentifier: "AddName", sender:  name)
        
        
        
    }
    func callSegueFromAddressCell(Data dataobject: String) {
        performSegue(withIdentifier: "AddAddress", sender:  AddressCell().locationAddress)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddName"{
            if let destination = segue.destination as? MajorDefine{
                destination.userId = userID
                destination.delegate = self
                
            }
        }
        if segue.identifier == "AddCategory"{
            if let destination = segue.destination as? CategoryDefine{
                destination.userId = userID
                destination.delegate = self
                
            }
        }
        if segue.identifier == "AddAddress"{
            if let destination = segue.destination as? AddressDefine{
                destination.userId = userID
                destination.delegate = self
                
            }
        }
        if segue.identifier == "FromProfileToStart"{
            if let destination = segue.destination as? Start{
                destination.userID = Auth.auth().currentUser?.uid
                destination.email = Auth.auth().currentUser?.email
                destination.photURL = Auth.auth().currentUser?.photoURL!
                
                
            }
        }
        
    }
    
}

