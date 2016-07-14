//
//  Post.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/7/2.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import Foundation

class Post{
    private var _description: String?
    private var _imgUrl: String?
    private var _hates: Int!
    private var _likes: Int!
    private var _userName: String!
    private var _postKey: String!
    
    var description: String?{
        return _description
    }
    
    var imgUrl: String?{
        return _imgUrl
    }
    
    var hates: Int!{
        return _hates
    }
    
    var likes: Int!{
        return _likes
    }
    
    var userName: String!{
        return _userName
    }
    
    //The initial value of _hates and _likes are both 0
    //The initial value of _postkey is created by firebase
    //With the above reasons, we don't need to initialize _hates、 _likes、_postkey's value
    init(descript: String, img: String, name: String){
        self._description = descript
        self._imgUrl = img
        self._userName = name
    }
    
    //if the firebase have data, it will save in dictionary
    //When we grab the datas from the firebase(We have the postkey, hates, likes's values in the firebase, so we can use them to initialize the three), we need to initialize the _postKey, _hates, _likes from the datas.
    //And if the firebase have the data of img and description, we also can initialize the _imgUrl and _description from the data in Firebase
    init(postKey: String, dictionary: Dictionary<String, AnyObject>){
        self._postKey = postKey
        
        if let hate = dictionary["hates"] as? Int{
            self._hates = hate
        }
        
        if let like = dictionary["likes"] as? Int{
            self._likes = like
        }
        
        if let img = dictionary["imgUrl"] as? String{
            self._imgUrl = img
        }
        
        if let descript = dictionary["description"] as? String{
            self._description = descript
        }
    }
    
}
