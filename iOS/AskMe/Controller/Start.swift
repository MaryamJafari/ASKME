//
//  Start.swift
//  AskMe
//
//  Created by Maryam Jafari on 4/13/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit
import PubNub  // Stephen
import FirebaseAuth // Stephen

// Stephen
protocol HangupFromDelegate {
    func hangupCall()
}

class Start: UIViewController , UITableViewDelegate, UITableViewDataSource, PNObjectEventListener{
    
    // Stephen ========>
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var RTCdelegate : HangupFromDelegate?
    var isOnCall : Bool! = false
    var myEmail : String!
    var calleeEmail : String!
    var roomName : String! // Stephen
    var isAudioOnly : Bool! = false // Stephen
    // <======== Stephen
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row  {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile")
            return cell!
            
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "chat")
            return cell!
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "call")
            return cell!
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Audio")
            return cell!
    
        default:
            return UITableViewCell()
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row  {
        case 0:
            performSegue(withIdentifier: "ShowProfile", sender: userID)
        case 1:
            performSegue(withIdentifier: "ChatHistory", sender: userID)
            
        case 2:
            performSegue(withIdentifier: "SearchingControl", sender: userID)
        case 3:
            performSegue(withIdentifier: "SearchingControl", sender: userID)
   
            
        default: break
            
        }
    }
    var userID : String!
    var email : String!
    var photURL : URL!
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(red:0.76, green:0.34, blue:0.0, alpha:1.0)
        table.dataSource = self
        table.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color]
        // Do any additional setup after loading the view.
        
        // Stephen ====>
        appDelegate.client.addListener(self)
        appDelegate.client.subscribeToChannels(["my_channel"], withPresence: true)
        appDelegate.startPageAddr = self
        myEmail = Auth.auth().currentUser?.email
        print("my Email is = \(self.myEmail) ")
        // <==== Stephen
    }
    
  
    
    @IBAction func LogOut(_ sender: Any) {
        if AuthProvider.Instance.logOut(){
            DBProvider.Instance.updateNotificationToken(userID: userID, token: "")
            navigationController?.popToRootViewController(animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProfile"{
            if let destination = segue.destination as? ProfileViewController{
                
                
                destination.userID = userID
                destination.email = email
                destination.photURL = photURL
                
            }
        }
        if segue.identifier == "ChatHistory"{
            if let destination = segue.destination as? ChatHistory{
                destination.ID = userID
                destination.email = email
                destination.photURL = photURL
                
            }
        }
        if segue.identifier == "SearchingControl"{
            if let destination = segue.destination as? Searching{
                destination.reciverID = userID
                destination.email = email
                destination.photURL = photURL
                
            }
        }
        
        // Stephen ========>
        if segue.identifier == "AcceptVideoChat"{
            if let destination = segue.destination as? RTCVideoChatViewController {
                //destination.roomUrl = "https://appr.tc/r/" + self.roomName
                destination.roomName = self.roomName! as NSString
                destination.isAudioOnly = self.isAudioOnly
                destination.senderName = self.myEmail
                destination.reciverName = self.calleeEmail
            }
        }
        // <======== Stephen
    }
    
    // Stephen ================ below are belong to the Video & Audio chat
    class CallSignal: Codable {
        let timestamp: Date
        let sender: String
        let receiver: String
        let action: String
        let response: String
        let roomName: String
        
        init(timestamp: Date, sender: String, receiver: String, action: String, response: String, roomName: String) {
            self.timestamp = timestamp
            self.sender = sender
            self.receiver = receiver
            self.action = action
            self.response = response
            self.roomName = roomName
        }
    }
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        print("Searchin.swift !!!! Received message: \(message.data.message) on channel \(message.data.channel) " + "at \(message.data.timetoken)")
        
        print("My Email is: \(self.myEmail)")
        
        if let signal = message.data.message as? NSDictionary {
            print("Dictionary message: timestamp \(signal["timestamp"]), senderEmail: \(signal["sender"]), receiverEmail: \(signal["receiver"]) , Action: \(signal["action"]), Response: \(signal["response"]), SignalRoomName: \(signal["roomName"]), myCurRoomName: \(self.roomName)")
            
            if signal["receiver"] as! String != self.myEmail {
                return
            }
            
            if signal["action"] as! String == "make_video_call" {
                promptCallWindow(chatTitle: "Video call", signal: signal)
            } else if signal["action"] as! String == "make_audio_call" {
                promptCallWindow(chatTitle: "Audio call", signal: signal)
            } else if signal["action"] as! String == "disconnect" && self.isOnCall == true && signal["roomName"] as! String == self.roomName {
                RTCdelegate?.hangupCall()
                return
            } else if signal["action"] as! String == "reject_call" && self.isOnCall == true && signal["roomName"] as! String == self.roomName {
                let alert = UIAlertView(title: "Busy", message: "Please Call Later!", delegate: nil, cancelButtonTitle: "close")
                alert.show()
                RTCdelegate?.hangupCall()
                return
            }
        }
    }
    
    func promptCallWindow(chatTitle : String, signal : NSDictionary) {
        let fromTo = "from \(signal["sender"] as! String)"
        let alert = UIAlertController(title: chatTitle, message: fromTo, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { action in
            if self.isOnCall == true {
                self.RTCdelegate?.hangupCall()
                sleep(1)
            }
            self.isAudioOnly = chatTitle == "Audio call" ? true : false
            self.calleeEmail = signal["sender"] as! String
            self.roomName = signal["roomName"] as! String
            self.performSegue(withIdentifier: "AcceptVideoChat", sender: self.roomName)
        }))
        
        alert.addAction(UIAlertAction(title: "Decline", style: .default, handler: { action in
            let signal = CallSignal(timestamp:Date(), sender:signal["receiver"] as! String, receiver:signal["sender"] as! String, action:"reject_call", response:"busy", roomName:signal["roomName"] as! String);
            let encoder = JSONEncoder()
            let data = try! encoder.encode(signal)
            self.appDelegate.client.publish(String(data: data, encoding: .utf8)!, toChannel: "my_channel", compressed: false, withCompletion: nil)
            print("Sorry I am busy now! Reject the call!")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

