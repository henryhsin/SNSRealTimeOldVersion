//
//  Constants.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/6/23.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import Foundation
import UIKit

// used by thr layer shadow
let SHADOW_COLOR: CGFloat = 157.0/255.0

//Key
let KEY_UID = "uid"

//Segue
let SEGUE_LOGGED_IN = "loggedIn"

//Alert Title
let ALERT_TITLE_OKAY = "okay"
let ALERT_TITLE_OOPS = "OOps!!"

//Status Codes 有關Firebase中所給的錯誤代碼
//使用者不存在的錯誤代碼在2.x版本的firebase為-8，然而在3.3版本的firebase中為17011
let STATUS_ACCOUNT_NONEXIST = 17011


//使用者密碼錯誤代碼為-6
let STATUS_PASSWORD_WRONG = -6
