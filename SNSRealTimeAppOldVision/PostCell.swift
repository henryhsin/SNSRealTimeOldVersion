//
//  PostCell.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/6/24.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showCaseImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func drawRect(rect: CGRect) {
        //想要讓大頭照有圓形的效果
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        //讓圖片不會超出bound
        profileImg.clipsToBounds = true
        showCaseImg.clipsToBounds = true
        
    }
}
