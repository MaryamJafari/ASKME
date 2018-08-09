    //
    //  Searching.swift
    //  AskMe
    //
    //  Created by Maryam Jafari on 11/13/17.
    //  Copyright © 2017 Maryam Jafari. All rights reserved.
    //
    
    import  UIKit
    import  FirebaseAuth
    
    class Searching: UIViewController,  UITableViewDelegate, UITableViewDataSource, FetchData{
        var menuShowing = false
        let searchController = UISearchController(searchResultsController: nil)
        var notificationToken : String!
        var reciverID : String!
        var receiverName : String!
        var email : String!
        var photURL : URL!
        var recieverPhoto : String?
        var senderPhoto : String?
        var inSearchableMode = false
        var newProfile = [Profile]()
        var filterProfile = [Profile]()
        private var profiles = [Profile]()
        var pickerData : [String] = [String]()
        
        @IBOutlet weak var table: UITableView!
        
        
        @IBOutlet weak var profileimage: UIButton!
        override func viewDidLoad() {
            super.viewDidLoad()
            let color = UIColor(red: 0.0039, green: 0.451, blue: 0.6588, alpha: 1.0) /* #0173a8 */
            
            self.navigationController?.navigationBar.tintColor = UIColor.gray
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color]
            
            table.delegate = self
            table.dataSource = self
            DBProvider.Instance.delegate = self
            DBProvider.Instance.getProfiles()
            pickerData = ["Food","Transportation","Housing","Sell","Academic","Financial"]
            
            
            searchController.searchResultsUpdater =   self
            definesPresentationContext = true
            table.tableHeaderView = searchController.searchBar
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.scopeButtonTitles = ["Name","Major","Address","Interest"]
            searchController.searchBar.delegate = self
            
        }
        
        
        @IBAction func profileClick(_ sender: Any) {
            performSegue(withIdentifier: "Profile", sender: "")
            
        }
        
        
        func dataRecieved(contacts : [Profile]){
            self.profiles = contacts
            for contact in contacts{
                if contact.id == AuthProvider.Instance.userID(){
                    AuthProvider.Instance.username = contact.name
                }
            }
            for profile in profiles{
                if (profile.id != Auth.auth().currentUser?.uid ){
                    newProfile.append(profile)
                }
            }
            table.reloadData()
        }
        
        
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
            
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if(searchController.isActive && searchController.searchBar.text != ""){
                return filterProfile.count
            }
            return newProfile.count
            
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProfileCell
            var profile : Profile!
            
            
            if(searchController.isActive && searchController.searchBar.text != ""){
                profile = filterProfile[indexPath.row]
                
                
            }
            else{
                profile = newProfile[indexPath.row]
                
                
            }
            DBProvider.Instance.getProfilesImages(userId: profile.id){(data ) in
                profile.imageURl = data
                
            }
            DBProvider.Instance.getmajor(userId: profile.id){(data ) in
                profile.major = data
                
            }
            DBProvider.Instance.getAddress(userId: profile.id){(data ) in
                profile.address = data
                
            }
            DBProvider.Instance.getCategory(userId: profile.id){(data ) in
                profile.interest1 = data
                
            }
            DBProvider.Instance.getCategory(userId: profile.id){(data ) in
                profile.interest2 = data
                
            }
            DBProvider.Instance.getCategory(userId: profile.id){(data ) in
                profile.interest3 = data
                
            }
            DBProvider.Instance.getCategory(userId: profile.id){(data ) in
                profile.interest4 = data
                
            }
            DBProvider.Instance.getCategory(userId: profile.id){(data ) in
                profile.interest5 = data
                
            }
            DBProvider.Instance.getCategory(userId: profile.id){(data ) in
                profile.interest6 = data
                
            }
            
            
            cell?.configureCell(profile:profile)
            return cell!
        }
        
        @IBAction func logOut(_ sender: Any) {
            if AuthProvider.Instance.logOut(){
                DBProvider.Instance.updateNotificationToken(userID: reciverID, token: "")
                navigationController?.popToRootViewController(animated: true)
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.recieverPhoto =  newProfile[indexPath.row].imageURl
            
            receiverName = newProfile[indexPath.row].name
            notificationToken = newProfile[indexPath.row].notificationToken
            performSegue(withIdentifier: "Chat", sender: newProfile[indexPath.row].id)
        }
        
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "Profile"{
                if let destination = segue.destination as? ProfileViewController{
                    
                    
                    destination.userID = Auth.auth().currentUser?.uid
                    
                    destination.email = Auth.auth().currentUser?.email
                    destination.photURL = Auth.auth().currentUser?.photoURL!
                    
                }
            }
            
            if segue.identifier == "Chat"{
                
                if let destination = segue.destination as? Chat{
                    if let id = sender as? String{
                        destination.reciverId = id
                        destination.ReciverName = receiverName
                        destination.senderPhotURL = Auth.auth().currentUser?.photoURL! 
                        destination.recieverPhotURL = recieverPhoto
                        destination.notificationToken = notificationToken
                        
                    }
                }
            }
        }
        
        func searching(searchText : String, scope : String ){
            var newScope = scope
            if newScope == "Name" {
                filterProfile = newProfile.filter{profile in
                    return   profile.name.lowercased().contains(searchText.lowercased())
                    
                }
            }
            else if newScope == "Address" {
                filterProfile = newProfile.filter{profile in
                    return    profile.address.lowercased().contains(searchText.lowercased())
                    
                }
            }
            else if newScope == "Major" {
                filterProfile = newProfile.filter{profile in
                    return    profile.major.lowercased().contains(searchText.lowercased())
                    
                }
            }
            else if newScope == "Interest" {
                filterProfile = newProfile.filter{profile in
                    return  (profile.interest1.lowercased().contains(searchText.lowercased()) || profile.interest2.lowercased().contains(searchText.lowercased()) ||
                        profile.interest3.lowercased().contains(searchText.lowercased()) || profile.interest4.lowercased().contains(searchText.lowercased()) ||  profile.interest5.lowercased().contains(searchText.lowercased()) ||  profile.interest6.lowercased().contains(searchText.lowercased()))
                    
                }
                newScope = "Name"
            }
            
            table.reloadData()
        }
    }
    
    extension Searching : UISearchResultsUpdating{
        func updateSearchResults(for searchController: UISearchController) {
            let searchbar = searchController.searchBar
            let scope = searchbar.scopeButtonTitles![searchbar.selectedScopeButtonIndex]
            
            searching(searchText: searchController.searchBar.text!, scope: scope)
        }
    }
    
    extension Searching : UISearchBarDelegate{
        func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
            searching(searchText: searchController.searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        }
    }
    
    
