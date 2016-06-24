//
//  DataService.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/6/24.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import Foundation

let URL_BASE = "https://realtimeappoldvision.firebaseio.com"

class DataService {
    static let ds = DataService()
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase{
        return _REF_BASE
    }
    var REF_POSTS: Firebase{
        return _REF_POSTS
    }
    var REF_USERS: Firebase{
        return _REF_USERS
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>){
        //等同於"https://realtimeappoldvision.firebaseio.com/users/uid"
        //並設立provider: facebook or provider: email
        //並設立userName: name
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
    
}