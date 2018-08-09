//
//  Chat.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/24/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseAuth
import SDWebImage
import FirebaseDatabase
import FirebaseStorage
import PubNub

class Chat: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     var reciverId : String!
     var notificationToken : String!
     var ReciverName: String!
     var SenderName: String! //Stephen
     var avatarDictionary: [String:UIImage] = [:]
     var senderPhotURL : URL?
     var recieverPhotURL : String?
     let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
     var roomName : String! // Stephen
     var isAudioOnly : Bool! = false // Stephen
     var delegate : ChatHistoryDelegate?
     private var messages = [JSQMessage]()
     let picker = UIImagePickerController()
     override func viewDidLoad() {
          super.viewDidLoad()
          self.senderId = AuthProvider.Instance.userID()
          self.senderDisplayName = AuthProvider.Instance.username
          picker.delegate = self
          observeUserMessages()
          observeUserMediaMessages()
          navigationItem.title = ReciverName
          // Stephen
          self.SenderName = Auth.auth().currentUser?.email
          // Stephen
          
     }
     
     // chat control
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
          return messages[indexPath.item]
     }
     
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
          let msg = messages[indexPath.item]
          if msg.isMediaMessage{
               if let mediaItem = msg.media as? JSQVideoMediaItem{
                    let player = AVPlayer(url: mediaItem.fileURL)
                    let playerController = AVPlayerViewController();
                    playerController.player = player
                    self.present(playerController, animated: true, completion: nil)
               }
          }
     }
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return messages.count
     }
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
          return cell
     }
     
     override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
          
          self.sendMessage(senderID: senderId, senderName: SenderName, text: text, reciverID: reciverId!, date :  NSNumber(value : NSDate().timeIntervalSince1970) , recieverImage: self.recieverPhotURL!, recieverName: ReciverName, senderImage: (senderPhotURL?.absoluteString)!, notificationToken: notificationToken)
          finishSendingMessage()
          collectionView.reloadData()
          
          
     }
     
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
          let bubbleFactorty = JSQMessagesBubbleImageFactory()
          let mesage = messages[indexPath.item]
          if (mesage.senderId == self.senderId){
               return bubbleFactorty?.outgoingMessagesBubbleImage(with: UIColor.blue)
          }
          else{
               return bubbleFactorty?.incomingMessagesBubbleImage(with: UIColor.gray)
          }
     }
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
          return nil
     }

     override func didPressAccessoryButton(_ sender: UIButton!) {
          let alert = UIAlertController(title: "Media Messages", message: "Please Select A Media", preferredStyle: .actionSheet)
          let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          let photos = UIAlertAction(title: "Photos", style: .default, handler: {(alert : UIAlertAction) in
               self.chooseMedia(type: kUTTypeImage)
               
          })
          let videos = UIAlertAction(title: "Videos", style: .default, handler: {(alert : UIAlertAction) in
               self.chooseMedia(type: kUTTypeMovie)
          })
          alert.addAction(photos)
          alert.addAction(cancel)
          alert.addAction(videos)
          present(alert, animated: true, completion: nil)
     }
     // picker view function
     private func chooseMedia(type : CFString){
          picker.mediaTypes = [type as String]
          present(picker, animated: true, completion : nil)
     }
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
          if let pic = info[UIImagePickerControllerOriginalImage] as?
               UIImage{
               let data = UIImageJPEGRepresentation(pic, 0.01)
               
               sendMedia(image: data, video: nil, senderId: senderId, senderName: SenderName, reciverID: reciverId)
               finishSendingMessage()
               
          }
          else if let vidURL = info[UIImagePickerControllerMediaURL] as? URL{
               
               
               sendMedia(image: nil, video: vidURL , senderId: senderId, senderName: SenderName, reciverID: reciverId)
               finishSendingMessage()
          }
          
          self.dismiss(animated: true, completion: nil)
          collectionView.reloadData()
     }
     //chat methods
     
     func sendMediaMessage(senderId: String, senderName : String, url : String, reciverID : String, date : NSNumber, senderImage : URL, recieverImage : String, recieverName : String, notificationToken : String){
          let data : Dictionary<String, Any> = [Constant.SENDER_ID : senderId, Constant.SENDER_NAME : senderName, Constant.URL : url,  Constant.RECIVER_ID : reciverID, Constant.DATE : date, Constant.RECIVERPHOTOURL : recieverPhotURL, Constant.RECIVER_NAME : ReciverName, Constant.NOTIFICATION_TOKEN : notificationToken, Constant.SENDERPHOTOURL : senderPhotURL?.absoluteString]
          // DBProvider.Instance.mediamessageRef.childByAutoId().setValue(data)
          
          
          var childRef = Database.database().reference().child("Media_Messages").childByAutoId()
          childRef.updateChildValues(data) { (error, ref) in
               if error != nil{
                    print (error)
                    return
               }
               let userMessageRef = Database.database().reference().child("user_messages").child(senderId)
               let messagId =  childRef.key
               userMessageRef.updateChildValues([messagId : 1])
               
               let recipiantUserMessageRefrence =  Database.database().reference().child("user_messages").child(reciverID)
               recipiantUserMessageRefrence.updateChildValues([messagId : 1])
          }
     }
     
     func sendMessage(senderID : String, senderName : String, text: String, reciverID : String, date : NSNumber,  recieverImage : String, recieverName : String, senderImage : String, notificationToken : String){
          let data : Dictionary<String, Any> = [Constant.SENDER_ID : senderID, Constant.SENDER_NAME : senderName, Constant.TEXT : text, Constant.RECIVER_ID : reciverID, Constant.DATE: date, Constant.RECIVERPHOTOURL : recieverImage, Constant.RECIVER_NAME : ReciverName, Constant.SENDERPHOTOURL : senderPhotURL?.absoluteString, Constant.NOTIFICATION_TOKEN : notificationToken]
          let childRef = Database.database().reference().child("Messages").childByAutoId()
          childRef.updateChildValues(data) { (error, ref) in
               if error != nil{
                    print (error)
                    return
               }
               let userMessageRef = Database.database().reference().child("user_messages").child(senderID)
               let messagId =  childRef.key
               userMessageRef.updateChildValues([messagId : 1])
               
               let recipiantUserMessageRefrence =  Database.database().reference().child("user_messages").child(reciverID)
               recipiantUserMessageRefrence.updateChildValues([messagId : 1])  
          }
          
          delegate?.chatHistoryUpdateRecieved(data: Message(senderName: senderName, receiverName: recieverName, recieverid: reciverID, imageURL: recieverPhotURL!, senderId: senderID, notification: notificationToken, message: text, date: date, reciverImageURL: recieverPhotURL!))
     }
     
     private func addMessage(withId id: String, name: String, text: String, reciverID : String) {
          
          let uid = Auth.auth().currentUser?.uid
          
          if (reciverID == uid! || id == uid!){
               if(reciverId == reciverID || reciverId == id){
                    
                    
                    if let message = JSQMessage(senderId: id, displayName: name,text: text) {
                         messages.append(message)
                         
                    }
               }
          }
     }
     
     func observeUserMessages(){
          guard let uid = Auth.auth().currentUser?.uid else {
               return
          }
          let ref = Database.database().reference().child("user_messages").child(uid)
          ref.observe(DataEventType.childAdded, with: { (snapshot : DataSnapshot)  in
               
               let messageId = snapshot.key
               
               let messageRef =  Database.database().reference().child("Messages").child(messageId)
               messageRef.observeSingleEvent(of: .value , with: { (snapshot) in
                    
                    if let data = snapshot.value as? NSDictionary {
                         if let senderID = data[Constant.SENDER_ID] as? String{
                              if let senderName = data[Constant.SENDER_NAME] as? String{
                                   
                                   if let text = data[Constant.TEXT] as? String{
                                        if let reciverID = data[Constant.RECIVER_ID] as? String{
                                             self.addMessage(withId: senderID, name: senderName, text: text, reciverID: reciverID )
                                             self.finishReceivingMessage()
                                        }
                                        
                                   }
                                   
                              }
                         }
                    }
               }, withCancel: nil)
               
               
          }, withCancel: nil)
     }
     
     func observeMessages(){
          DBProvider.Instance.messageRef.observe(DataEventType.childAdded) { (snapshot : DataSnapshot) in
               if let data = snapshot.value as? NSDictionary {
                    if let senderID = data[Constant.SENDER_ID] as? String{
                         if let senderName = data[Constant.SENDER_NAME] as? String{
                              if let text = data[Constant.TEXT] as? String{
                                   
                                   if let reciverID = data[Constant.RECIVER_ID] as? String{
                                        self.addMessage(withId: senderID, name: senderName, text: text, reciverID: reciverID)
                                        self.finishReceivingMessage()
                                   }
                              }
                              
                         }
                    }
               }
          }
     }
     // media methods
     
     func mediaRecived(senderID: String, senderName: String, url: String, reciverID : String) {
          if let mediaURL = URL(string : url)
          {
               do {
                    let data = try Data(contentsOf : mediaURL)
                    if let _ = UIImage(data :  data){
                         let _ = SDWebImageDownloader.shared().downloadImage(with: mediaURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                              DispatchQueue.main.async {
                                   let photo = JSQPhotoMediaItem(image: image)
                                   if senderID == self.senderId{
                                        photo?.appliesMediaViewMaskAsOutgoing = true
                                   }
                                   else
                                   {
                                        photo?.appliesMediaViewMaskAsOutgoing = false
                                        
                                   }
                                   
                                   
                                   if (reciverID == Auth.auth().currentUser?.uid || senderID == Auth.auth().currentUser?.uid){
                                        if(self.reciverId == reciverID || self.reciverId == senderID)
                                        {
                                             self.messages.append(JSQMessage(senderId: senderID, senderDisplayName: senderName, date: Date(), media: photo))
                                             
                                        }
                                   }
                                   self.collectionView.reloadData()
                              }
                         })
                    }
                    else{
                         let video = JSQVideoMediaItem(fileURL: mediaURL, isReadyToPlay: true)
                         
                         
                         if senderID == self.senderId{
                              video?.appliesMediaViewMaskAsOutgoing = true
                         }
                         else
                         {
                              video?.appliesMediaViewMaskAsOutgoing = false
                              
                         }
                         if (reciverID == Auth.auth().currentUser?.uid || senderID == Auth.auth().currentUser?.uid){
                              if(self.reciverId == reciverID || self.reciverId == senderID)
                              {
                                   self.messages.append(JSQMessage(senderId: senderID, senderDisplayName: senderName, date: Date(), media: video))
                              }
                              
                         }
                         self.collectionView.reloadData()
                         
                    }
               }
               catch{
                    
               }
          }
     }

     func sendMedia(image: Data?, video: URL? ,senderId : String, senderName: String, reciverID : String){
          if image != nil{
               DBProvider.Instance.imageStorageRef.child(senderId + "\(NSUUID().uuidString).jpg").putData(image!, metadata: nil){(metadata : StorageMetadata?, err : Error?)
                    in
                    if err != nil{
                         
                    }
                    else{
                         
                         
                         self.sendMediaMessage(senderId: senderId, senderName: self.SenderName, url: String(describing : metadata!.downloadURL()!), reciverID: self.reciverId!, date : NSNumber(value : NSDate().timeIntervalSince1970) , senderImage: self.senderPhotURL!, recieverImage: self.recieverPhotURL!, recieverName : self.ReciverName,  notificationToken: self.notificationToken)
                    }
               }
          }else{
               DBProvider.Instance.videoStorageRef.child(senderId + "\(NSUUID().uuidString)").putFile(from: video!, metadata: nil){(metadata : StorageMetadata?, err : Error?)
                    in
                    if err != nil{
                         
                    }
                    else{
                         self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing : metadata!.downloadURL()!), reciverID: reciverID, date:  NSNumber(value : NSDate().timeIntervalSince1970) , senderImage: self.senderPhotURL!, recieverImage: self.recieverPhotURL!, recieverName : self.ReciverName, notificationToken: self.notificationToken)
                    }
               }
          }
     }
     
     func observeUserMediaMessages(){
          guard let uid = Auth.auth().currentUser?.uid else {
               return
          }
          let ref = Database.database().reference().child("user_messages").child(uid)
          ref.observe(DataEventType.childAdded, with: { (snapshot : DataSnapshot)  in
               
               let messageId = snapshot.key
               
               let messageRef =  Database.database().reference().child("Media_Messages").child(messageId)
               messageRef.observeSingleEvent(of: .value , with: { (snapshot) in
                    
                    if let data = snapshot.value as? NSDictionary {
                         if let senderID = data[Constant.SENDER_ID] as? String{
                              if let senderName = data[Constant.SENDER_NAME] as? String{
                                   if let fileURL = data[Constant.URL] as? String{
                                        if let reciverID = data[Constant.RECIVER_ID] as? String{
                                             
                                             self.mediaRecived( senderID: senderID ,senderName: senderName, url: fileURL, reciverID: reciverID)
                                             self.finishReceivingMessage()
                                        }
                                        
                                   }
                              }
                         }
                    }
               }, withCancel: nil)
               
               
          }, withCancel: nil)
          
     }
     
     func observeMediaMessages(){
          DBProvider.Instance.mediamessageRef.observe(DataEventType.childAdded) { (snapshot : DataSnapshot) in
               if let data = snapshot.value as? NSDictionary {
                    if let id = data[Constant.SENDER_ID] as? String{
                         
                         if let name = data[Constant.SENDER_NAME] as? String{
                              if let fileURL = data[Constant.URL] as? String{
                                   if let reciverID = data[Constant.RECIVER_ID] as? String{
                                        
                                        self.mediaRecived( senderID: id,senderName: name, url: fileURL, reciverID: reciverID)
                                        self.finishReceivingMessage()
                                   }
                              }
                         }
                    }
               }
               
          }}
     
     // =============== Stephen below are belong to the Video & Audio chat =====================
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
     
     @IBAction func openAudioChat(_ sender: Any) {
          self.isAudioOnly = true;
          openVideoOrAudioRoom(callAction: "make_audio_call");
     }
     @IBAction func openVideoChat(_ sender: Any) {
          self.isAudioOnly = false;
          openVideoOrAudioRoom(callAction: "make_video_call");
     }
     
     func openVideoOrAudioRoom(callAction: String) {
          self.roomName = UUID().uuidString
          let signal = CallSignal(timestamp:Date(), sender:SenderName, receiver:ReciverName, action:callAction, response:"true", roomName:self.roomName);
          let encoder = JSONEncoder()
          let data = try! encoder.encode(signal)
          appDelegate.client.publish(String(data: data, encoding: .utf8)!, toChannel: "my_channel", compressed: false, withCompletion: nil)
          
          // ready to enter the video call view
          self.performSegue(withIdentifier: "ToVideoChatView", sender: self.roomName)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "ToVideoChatView"{
               if let destination = segue.destination as? RTCVideoChatViewController {
                    destination.roomName = self.roomName as! NSString
                    //destination.roomUrl = "https://appr.tc/r/" + self.roomName
                    destination.isAudioOnly = self.isAudioOnly
                    destination.senderName = SenderName
                    destination.reciverName = ReciverName
               }
          }
     }
     // <====== Stephen
     @IBAction func exit(_ sender: Any) {
          dismiss(animated: true, completion: nil)
     }
     
     
}

extension Date {
     init?(jsonDate: String) {
          let prefix = "/Date("
          let suffix = ")/"
          let scanner = Scanner(string: jsonDate)
          
          // Check prefix:
          guard scanner.scanString(prefix, into: nil)  else { return nil }
          
          // Read milliseconds part:
          var milliseconds : Int64 = 0
          guard scanner.scanInt64(&milliseconds) else { return nil }
          // Milliseconds to seconds:
          var timeStamp = TimeInterval(milliseconds)/1000.0
          
          // Read optional timezone part:
          var timeZoneOffset : Int = 0
          if scanner.scanInt(&timeZoneOffset) {
               let hours = timeZoneOffset / 100
               let minutes = timeZoneOffset % 100
               // Adjust timestamp according to timezone:
               timeStamp += TimeInterval(3600 * hours + 60 * minutes)
          }
          
          // Check suffix:
          guard scanner.scanString(suffix, into: nil) else { return nil }
          
          // Success! Create NSDate and return.
          self.init(timeIntervalSince1970: timeStamp)
     }
}

