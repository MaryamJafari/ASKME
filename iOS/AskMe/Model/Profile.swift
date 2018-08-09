//
//  Profile.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/24/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
class Profile{
    private var _name = ""
    private var _id = ""
    private var _ImageURL = ""
    private var _schoolYear = ""
    private var _interest1 = ""
    private var _interest2 = ""
    private var _interest3 = ""
    private var _interest4 = ""
    private var _interest5 = ""
    private var _interest6 = ""
    private var _major = ""
    private var _address = ""
    private var _notificationToken = ""
    
    init(name : String, id : String, imageURL: String, schoolYear: String, interest1: String, interest2: String, interest3: String,interest4: String,interest5: String, interest6: String, major:  String, address: String, notification : String ){
        _name = name
        _id = id
        _ImageURL = imageURL
        _schoolYear = schoolYear
        _notificationToken = notification
        _interest1 = interest1
        _interest2 = interest2
        _interest3 = interest3
        _interest4 = interest4
        _interest5 = interest5
        _interest6 = interest6
        _major = major
        _address = address
    }
    var name : String{
        get{
            return _name
        }
    }
    
    var schoolyear : String{
        get{
            return _schoolYear
        }
        set{
            _schoolYear = newValue
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
    
    var interest1 : String{
        get{
            return _interest1
        }
        set{
            _interest1 = newValue
        }
    }
    var interest2 : String{
        get{
            return _interest2
        }
        set{
            _interest2 = newValue
        }
    }
    var interest3 : String{
        get{
            return _interest3
        }
        set{
            _interest3 = newValue
        }
    }
    var interest4 : String{
        get{
            return _interest4
        }
        set{
            _interest4 = newValue
        }
    }
    var interest5 : String{
        get{
            return _interest5
        }
        set{
            _interest5 = newValue
        }
    }
    var interest6 : String{
        get{
            return _interest6
        }
        set{
            _interest6 = newValue
        }
    }
    
    var address : String{
        get{
            return _address
        }
        set{
            _address = newValue
        }
    }
    var major : String{
        get{
            return _major
        }
        set{
            _major = newValue
        }
    }
    var imageURl : String{
        set { _ImageURL = newValue}
        get{
            return _ImageURL
        }
        
    }
    var id : String{
        get{
            return _id
        }
    }
}

