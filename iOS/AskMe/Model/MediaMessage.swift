//
//  Message.swift
//  AskMe
//
//  Created by Maryam Jafari on 4/26/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Foundation
class MediaMessage{
    private var _senderName = ""
    private var _receiverName = ""
    private var _recieverId = ""
    private var _senderId = ""
    private var _ImageURL = ""
    private var _reciverImageURL = ""
    private var _date : NSNumber? = nil
    private var _fileURL = ""
    private var _notificationToken = ""
    init(senderName : String, receiverName : String , recieverid : String, imageURL: String, senderId: String,notification : String, fileURL: String, date : NSNumber, reciverImageURL: String){
        _senderName = senderName
        _receiverName = receiverName
        _ImageURL = imageURL
        _recieverId = recieverid
        _senderId = senderId
        _fileURL = fileURL
        _date = date
        _reciverImageURL = reciverImageURL
        _notificationToken = notification
        
    }
    var senderName : String{
        get{
            return _senderName
        }
        set{
            _senderName = newValue
        }
    }
    var reciverImageURL : String{
        get{
            return _reciverImageURL
        }
        set{
            _reciverImageURL = newValue
        }
    }
    var fileURL : String{
        get{
            return _fileURL
        }
        set{
            _fileURL = newValue
        }
    }
    var notificationToken : String{
        get{
            return _notificationToken
        }
        set{
            _notificationToken = newValue
        }
    }
    var receiverName : String{
        get{
            return _receiverName
        }
        set{
            _receiverName = newValue
        }
    }
    
    var recieverId : String{
        get{
            return _recieverId
        }
        set{
            _recieverId = newValue
        }
    }
    var date : NSNumber{
        get{
            return _date!
        }
        set{
            _date = newValue
        }
    }
    
    var senderId : String{
        get{
            return _senderId
        }
        set{
            _senderId = newValue
        }
    }
    
    
    var imageURl : String{
        set { _ImageURL = newValue}
        get{
            return _ImageURL
        }
        
    }
    
}


