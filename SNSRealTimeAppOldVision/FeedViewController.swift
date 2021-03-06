//
//  FeedViewController.swift
//  SNSRealTimeAppOldVision
//
//  Created by 辛忠翰 on 2016/6/24.
//  Copyright © 2016年 Keynote. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage



class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var imgPicker: UIImagePickerController!
    var selectedImg = false
    
    var posts = [Post]()
    //everytime we want to display the view from the firebase, we can check was the img downloaded before in the cache? If yes, we can grab the img from the cache instead of downloading again from the Firebase
    static var imgCache = NSCache()
    
    @IBOutlet weak var cameraImg: UIImageView!
    
    @IBAction func postButton(sender: MaterialButton) {
        if let txt = postField.text where postField.text != "" {
            let checkCameraImg = UIImage(named: "SLR Camera-48")
            print(selectedImg)
            print("Q")
            if let img = cameraImg.image where selectedImg == true{
                //convert img to imgData and compress img from 0~1
                let imgData = UIImageJPEGRepresentation(img, 0.2)
                
                //use current time to give the imgData an unique name
                let imgPath = "\(NSDate.timeIntervalSinceReferenceDate())"
                
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpg"
                
                DataService.ds.REF_IMAGES.child(imgPath).putData(imgData!, metadata: metadata, completion: { (storageMetadata, error) in
                    
                    //TODO: show loading indicator~~
                    
                    if error != nil{
                        print(error)
                    }else{
                        if let meta = storageMetadata{
                            if let imgLink = meta.downloadURL()?.absoluteString{
                                print(imgLink)
                                self.postToFirebase(imgLink)
                                print("QQ")

                            }
                        }
                    }
                })
                
            }else{
                //we wont to post the img, so we create a function that just post text
                self.postToFirebase(nil)
            }
        }
    }
    
    
    //這個function會將postDescription, likes, hates, imgUrl  上傳到Firebase
    func postToFirebase(imgUrl: String?){
        //這邊需要去參考Firebase中的database的資料結構，裡面的節點都需與database中的一致
        var posts: Dictionary<String, AnyObject> = [
            "description": postField.text!,
            "hates": 0,
            "likes": 0
        ]
        
        //如果有imgUrl，則在posts中新增一個key: "imgUrl",且其value: imgUrl
        if imgUrl != nil{
            posts["imgUrl"] = imgUrl!
            print(posts)
            print("QQ")
        }
        
        //在database中新增一個針對此貼文(post)的子節點
        //下面這行程式碼可以自動為此po文創建一個unique ID
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        //在這個新創的po文子節點下，將posts新增進去
        firebasePost.updateChildValues(posts)
        
        
        //上傳完po文後，將postField中的字清空, cameraImg改回初始的相機圖案 selectedImg設為false
        
        print(self.postField.text)
        self.postField.text = ""
        
        cameraImg.image = UIImage(named: "SLR Camera-48")
        selectedImg = false
        
        //最後再讓tableView reloadData
        tableView.reloadData()
        
        
    }
    
    
    
    @IBOutlet weak var postField: MaterialTextField!
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
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
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
        
        
        
        
        
        
        imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        
        
        
        
        
        
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
    
    
    
    
    
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imgPicker.dismissViewControllerAnimated(true, completion: nil)
        cameraImg.image = image
        selectedImg = true
    }
    
    
    
    
    
    
    
    
    
    //MARK: Gesture
    
    @IBAction func selectImgFromCamera(sender: UITapGestureRecognizer) {
        presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
}
