//
//  PostCell.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/6/24.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
import Alamofire

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var showCaseImg: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var hateLabel: UILabel!
    var post:Post!
    var request: Request?
    
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
    
    
    //Good develper configure the cell, like change cell's text, view, color here, not in FeedViewController's cell function
    func configureCell(post: Post, img: UIImage?){
        self.post = post
        self.descriptionTextView.text = post.description
        self.likeLabel.text = String(post.likes)
        self.hateLabel.text = String(post.hates)
        
        if let url = post.imgUrl{
            if img != nil{//it means we have cache img
                self.showCaseImg.image = img
            }else{//download the img from firebase
                request = Alamofire.request(.GET, post.imgUrl!).validate(contentType: ["image/*"])
            }
        }else{
            self.showCaseImg.hidden = true
        }
    }
}
