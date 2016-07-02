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
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
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
        print(post.description)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        return cell
    }
}
