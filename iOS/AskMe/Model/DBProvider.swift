
    //  DBProvider.swift
    //  AskMe
    //
    //  Created by Maryam Jafari on 11/24/17.
    //  Copyright © 2017 Maryam Jafari. All rights reserved.
    //
    
    import Foundation
    import FirebaseDatabase
    import FirebaseStorage
    protocol FetchData : class{
        func dataRecieved (contacts : [Profile]);
        
    }
    protocol FetchDatafromMessages : class{
        func messageRecieved (contacts : [Message]);
        
    }
    
    class DBProvider {
        private static let _instance = DBProvider();
        weak var delegate : FetchData?
        weak var Messagedelegate : FetchDatafromMessages?
        private init(){}
        static var Instance : DBProvider{
            return _instance
        }
        var dbRef : DatabaseReference {
            return Database.database().reference()
        }
        var contactsRef : DatabaseReference{
            return dbRef.child(Constant.PROFILE)
        }
        var messagessRef : DatabaseReference{
            return dbRef.child(Constant.MESSAGES)
        }
        var profileDetailRef : DatabaseReference{
            return dbRef.child(Constant.PROFILEDETAIL)
        }
        var messageRef : DatabaseReference{
            return dbRef.child(Constant.MESSAGES)
        }
        var mediamessageRef : DatabaseReference{
            return dbRef.child(Constant.MEDIA_MESSAGES)
        }
        var storageRef : StorageReference{
            return Storage.storage().reference(forURL: "gs://askme-ca9f6.appspot.com")
        }
        var imageStorageRef : StorageReference{
            return storageRef.child(Constant.IMAGE_STORAGE)
        }
        var videoStorageRef : StorageReference{
            return storageRef.child(Constant.VIDEO_STORAGE)
        }
      
        
        
        func getProfiles(){
            contactsRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                var contacts = [Profile]()
                if let mycontacts = snapshot.value as? NSDictionary{
                    for (key, value) in mycontacts{
                        if let contactData = value as?NSDictionary{
                            if let email = contactData[Constant.EMAIL] as? String {
                                let id = key as! String
                                let imageUrl = contactData[Constant.PHOTO_URL] as? String
                                if let  interest1 = contactData[Constant.INTEREST] as? String{
                                    if let  interest2 = contactData[Constant.INTEREST2] as? String{
                                        if let notification = contactData[Constant.NOTIFICATION_TOKEN] as? String{
                                            if let  interest3 = contactData[Constant.INTEREST3] as? String{
                                                if let  interest4 = contactData[Constant.INTEREST4] as? String{
                                                    if let  interest5 = contactData[Constant.INTEREST5] as? String{
                                                        if let  interest6 = contactData[Constant.INTEREST6] as? String{
                                                            if let   major = contactData[Constant.MAJOR] as? String{
                                                                if let  address = contactData[Constant.ADDRESS] as? String{
                                                                    let newContact = Profile(name: email, id: id, imageURL: imageUrl!, schoolYear: "", interest1: interest1, interest2: interest2, interest3: interest3, interest4: interest4, interest5: interest5, interest6: interest6, major: major, address: address, notification: notification)
                                                                    
                                                                    contacts.append(newContact)
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    
                    
                    
                }
                self.delegate?.dataRecieved(contacts: contacts)
            }
            
        }
        
     
        func updateNotificationToken(userID : String, token: String){
            let ref = contactsRef.child(userID)
            
            ref.updateChildValues([
                Constant.NOTIFICATION_TOKEN: token  
                ])
        }
        
        func updateprofile(userId : String, major: String){
            
            let ref = contactsRef.child(userId)
            
            ref.updateChildValues([
                Constant.MAJOR: major
                ])
            
        }
        func updateHasProfile(userId : String, hasProfile: Bool){
            
            let ref = contactsRef.child(userId)
            
            ref.updateChildValues([
                Constant.HASPROFILE: hasProfile
                ])
            
        }
        
        func updateAddress(userId : String, address: String){
            
            let ref = contactsRef.child(userId)
            
            ref.updateChildValues([
                Constant.ADDRESS: address
                ])
            
        }
        func updateCategory(userId : String, category: String, category2: String, category3: String, category4: String, category5: String, category6: String){
            
            let ref = contactsRef.child(userId)
            ref.updateChildValues([Constant.INTEREST: category])
            ref.updateChildValues([Constant.INTEREST2: category2])
            ref.updateChildValues([Constant.INTEREST3: category3])
            ref.updateChildValues([Constant.INTEREST4: category4])
            ref.updateChildValues([Constant.INTEREST5: category5])
            ref.updateChildValues([Constant.INTEREST6: category6])
            
            
            
        }

        func getProfilesImages(userId : String, completion: @escaping (String) -> Void) {
            
            let rootRef = Database.database().reference()
            rootRef.child(Constant.PROFILE).observeSingleEvent(of: .value) {
                (snapshot: DataSnapshot) in
                if snapshot.key == userId{
                    if let postsDictionary = snapshot .value as? [String: AnyObject] {
                        for post in postsDictionary {
                            let messages = post.value as! [String: AnyObject]
                            for (key, value) in messages {
                                if key == Constant.PHOTO_URL{
                                    
                                    completion(value as! String)
                                }
                                
                            }
                            
                        }
                    }
                }
                
            }
            
            
        }
        
        
        
        
        func getNotificationToken(userId : String, completion: @escaping (String) -> Void) {
            var returnedToken = ""
            contactsRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                if let mycontacts = snapshot.value as? NSDictionary{
                    for (key, value) in mycontacts{
                        let id1 = key as! String
                        if (id1 == userId){
                            if let contactData = value as?NSDictionary{
                                if let token = contactData[Constant.NOTIFICATION_TOKEN] as? String {
                                    returnedToken = token
                                    
                                }
                            }
                            
                        }
                    }
                }
                completion(returnedToken )
                
            }
        }
        
        func getmajor(userId : String, completion: @escaping (String) -> Void) {
            var returnedMajor = ""
            contactsRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                if let mycontacts = snapshot.value as? NSDictionary{
                    for (key, value) in mycontacts{
                        let id1 = key as! String
                        if (id1 == userId){
                            if let contactData = value as?NSDictionary{
                                if let major = contactData[Constant.MAJOR] as? String {
                                    returnedMajor = major
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
                completion(returnedMajor )
                
            }
        }
        func getAddress(userId : String, completion: @escaping (String) -> Void) {
            var returnedAddress = ""
            contactsRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                if let mycontacts = snapshot.value as? NSDictionary{
                    for (key, value) in mycontacts{
                        let id1 = key as! String
                        if (id1 == userId){
                            if let contactData = value as?NSDictionary{
                                if let address = contactData[Constant.ADDRESS] as? String {
                                    returnedAddress = address
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
                completion(returnedAddress )
                
            }
        }
        func getCategory(userId : String, completion: @escaping (String) -> Void) {
            var returnedCategory = ""
            contactsRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                if let mycontacts = snapshot.value as? NSDictionary{
                    for (key, value) in mycontacts{
                        let id = key as! String
                        if (id == userId){
                            if let contactData = value as?NSDictionary{
                               
                                if let category1 = contactData[Constant.INTEREST] as? String {
                                    returnedCategory = category1
                                    return
                                    
                                }
                                if let category2 = contactData[Constant.INTEREST2] as? String {
                                    returnedCategory = category2
                                    return
                                    
                                }
                                if let category3 = contactData[Constant.INTEREST3] as? String {
                                    returnedCategory = category3
                                    return
                                    
                                }
                                if let category4 = contactData[Constant.INTEREST4] as? String {
                                    returnedCategory = category4
                                    return
                                    
                                }
                                if let category5 = contactData[Constant.INTEREST5] as? String {
                                    returnedCategory = category5
                                    return
                                    
                                }
                                if let category6 = contactData[Constant.INTEREST6] as? String {
                                    returnedCategory = category6
                                    return
                                    
                                }
                                
                            }
                            
                        }
                    }
                    
                }
                completion(returnedCategory)
                
            }
        }
       
        
        func userHasProfile(userId : String, completion: @escaping (Bool) -> Void){
            var x = false
            contactsRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                if let mycontacts = snapshot.value as? NSDictionary{
                    for (key, value) in mycontacts{
                        let id1 = key as! String
                        if (id1 == userId){
                            if let contactData = value as?NSDictionary{
                                if let hasData = contactData[Constant.HASPROFILE] as? Bool {
                                    let y = hasData
                                    if y == true{
                                        x = true
                                    }
                                    else {
                                        x = false
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
                completion(x )
                
            }
        }
        
        func userExists(userId : String, completion: @escaping (Bool) -> Void){
            var x = false
            contactsRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                if let mycontacts = snapshot.value as? NSDictionary{
                    for (key, _) in mycontacts{
                        let id1 = key as! String
                        if (id1 == userId){
                            x = true
                            
                            
                            
                            
                        }
                    }
                    
                }
                completion(x )
            }
            
        }
        

        
        func saveUser (withID : String, email : String,  photoURL: String, hasProfile : Bool,  major : String, interest: String, schoolYear : String, address : String, interest2: String, interest3: String,  interest4: String, interest5: String, interest6: String, notificationToken : String){
            let data : Dictionary<String, Any> = [Constant.EMAIL : email, Constant.PASSWORD : "", Constant.PHOTO_URL: photoURL, Constant.HASPROFILE : hasProfile, Constant.MAJOR : major, Constant.INTEREST : interest, Constant.SCHOOL_YEAR : schoolYear, Constant.ADDRESS : address, Constant.INTEREST2 : interest2, Constant.INTEREST3 : interest3, Constant.INTEREST4 : interest4 , Constant.INTEREST5 : interest5, Constant.INTEREST6 : interest6, Constant.NOTIFICATION_TOKEN  : notificationToken]
            contactsRef.child(withID).setValue(data)
        }
        
    }
    
