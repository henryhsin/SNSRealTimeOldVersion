//
//  FeedViewController.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/6/24.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var posts = [Post]()
    //everytime we want to display the view from the firebase, we can check was the img downloaded before in the cache? If yes, we can grab the img from the cache instead of downloading again from the Firebase
    static var imgCache = NSCache()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //因為有些cell無圖片，所以我們可以給cell一個預設的row height，讓他再有圖片時載入這個高度
        //下面會再設沒有圖片時的高度
        tableView.estimatedRowHeight = 402
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        //everytime Firebase have changed, we can use this func to grab the changes
        
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock:  { (snapshot) in
            //每次都先清空posts，再重新抓取在firebase中存在的post到posts中
            self.posts = []
            //因為是REF_POSTS
            //此處的snap是針對每個post，而非user
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots{
                    //print("SNAP \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject>{
                        //every snap means a distinct post, so every post has an unique ID key
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            
            
            self.tableView.reloadData()
        })
    }
    
    //MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        //in cache, there has a dectionary. And the key is "url", and the value is the "img"
        //So we can check is the img existed in the cache
        
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell{
            //it means every time we create a new cell, we want to cancel the request, because we can use the downloaded img in the cache, instead of downloading the old picture again
            cell.request?.cancel()
            
            var img: UIImage?
            if let url = post.imgUrl{
                print(url)
                img = FeedViewController.imgCache.objectForKey(url) as? UIImage
                print(img)
                print("QQ")
            }
            cell.configureCell(post, img: img)
            return cell
        }else{
            return PostCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if let url = post.imgUrl{
            return tableView.estimatedRowHeight
        }else{
            return 150
        }
    }
}
