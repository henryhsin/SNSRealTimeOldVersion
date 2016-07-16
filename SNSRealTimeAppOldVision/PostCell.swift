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
            if img != nil{
                //it means we have img in cacheImg
                self.showCaseImg.image = img
            }else{
                //download the img from firebase
                //contentType is Alamofire only have, it means it is an img
                
                //要記得因為apple還未預設開放連結到非https的網址，所以記得要去info.plist設定
                request = Alamofire.request(.GET, url).validate(contentType: ["image/*"]).response(completionHandler: { (request, response, data, err) in
                    if err != nil{
                        print(err.debugDescription)
                    }else{
                        
                        let img = UIImage(data: data!)!
                        self.showCaseImg.image = img
                        //將載下來的圖片，存到cache中
                        FeedViewController.imgCache.setObject(img, forKey: self.post.imgUrl!)
                    }
                })
            }
        }else{
            self.showCaseImg.hidden = true
        }
    }
}
