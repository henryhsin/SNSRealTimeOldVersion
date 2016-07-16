//
//  DataService.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/6/24.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

//let URL_BASE = "https://realtimeappoldvision.firebaseio.com"
  let URL_BASE = FIRDatabase.database().reference()
//為了要儲存圖片
  let URL_STORAGE = FIRStorage.storage().reference()




class DataService {
    //DataService is a singleton, meaning only one instance of it can exist.
    static let ds = DataService()
    //private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_BASE = URL_BASE
    
    
    //private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_POSTS = URL_BASE.child("posts")
    
    //private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    private var _REF_USERS = URL_BASE.child("users")
    
    //在storage下新增一個images的節點
    private var _REF_IMAGES = URL_STORAGE.child("images")
    
//    var REF_BASE: Firebase{
//        return _REF_BASE
//    }
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    var REF_POSTS: FIRDatabaseReference{
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    //REF_IMAGES的type記得為FIRStorageReference
    var REF_IMAGES: FIRStorageReference{
        return _REF_IMAGES
    }
    func createFirebaseUser(uid: String, user: Dictionary<String, String>){
        //等同於"https://realtimeappoldvision.firebaseio.com/users/uid"
        //因為uid下會有provider和userName，所以我們用Dictionary的方式將這兩個value儲存進去
        //並設立provider: facebook or provider: email
        //並設立userName: name
        //REF_USERS.childByAppendingPath(uid).setValue(user)
        REF_USERS.child(uid).updateChildValues(user)
    }
    
}