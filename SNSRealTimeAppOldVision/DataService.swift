//
//  DataService.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/6/24.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import Foundation

class DataService {
    static let ds = DataService()
    private var _REF_BASE = Firebase(url: "https://realtimeappoldvision.firebaseio.com")
    var REF_BASE: Firebase{
        return _REF_BASE
    }
    
}