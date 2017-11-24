//
//  ViewController.swift
//  REST-List
//
//  Created by Er. Bharat Mahajan on 07/11/17.
//  Copyright © 2017 Er. Bharat Mahajan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tblRestList: UITableView!
    @IBOutlet weak var activityIndicatorRestList: UIActivityIndicatorView!
    
    var posts : [Post] = []
    var refreshCtrl: UIRefreshControl!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ListTableViewCell", bundle: nil)
        self.tblRestList.register(nib, forCellReuseIdentifier: "ListTableViewCell")
        
        activityIndicatorRestList.startAnimating()
        self.tblRestList.delegate = self;
        self.tblRestList.dataSource = self;
        self.tblRestList.rowHeight = UITableViewAutomaticDimension
        self.tblRestList.estimatedRowHeight = 445
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        
        self.cache = NSCache()
        
        self.refreshCtrl = UIRefreshControl()
        self.tblRestList.addSubview(self.refreshCtrl)
        self.refreshCtrl.attributedTitle = NSAttributedString(string:"Pull to refresh")
        self.refreshCtrl.tintColor = UIColor.darkGray
        self.refreshCtrl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
        parseJSON()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
//      public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//
//        return 435
//    }

     public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        let newPost = posts[indexPath.row];
        cell.lblPostTitle?.text = newPost.title
        cell.lblPostDescription?.text = newPost.description
        cell.lblPostPublishDate?.text = CommonFunctions.formatDate(datePublish: newPost.published_at)
        cell.lblPostDescription.contentInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)

        cell.imgPostImage?.image = UIImage(named:"placeholder")
        cell.imgActivityIndicator.startAnimating()
        
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            // 2
            // Use cache
            print("Cached image used, no need to download it")
            cell.imgActivityIndicator.stopAnimating()
            cell.imgPostImage?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        }else{
            // 3
            let url:URL! = URL(string: newPost.image!)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    // 4
                    DispatchQueue.main.async(execute: { () -> Void in
                        // 5
                        // Before we assign the image, check whether the current cell is visible
                        if let updateCell = self.tblRestList.cellForRow(at: indexPath) as! ListTableViewCell!  {
                            let img:UIImage! = UIImage(data: data)
                            updateCell.imgActivityIndicator.stopAnimating()
                            updateCell.imgPostImage?.image = img
                            self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                        }
                    })
                }
            })
            task.resume()
        }
        return cell;
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func parseJSON(){
        let url = URL(string: Constants.baseURL)
        
        let datatask = session.dataTask(with: url!) {(data, response, error) in
            
            guard error == nil else {
                print("returning error")
                DispatchQueue.main.async {
                    self.tblRestList.reloadData()
                    self.activityIndicatorRestList.stopAnimating()
                }
                     return
            }
            
            guard let content = data else {
                print("not returning data")
                DispatchQueue.main.async {
                    self.tblRestList.reloadData()
                    self.activityIndicatorRestList.stopAnimating()
                }
                return
            }
            
            
            guard let postsjson = (try? JSONSerialization.jsonObject(with: content, options:.mutableContainers)) as? Dictionary<String, Array<Any>> else {
                print("Not containing JSON")
                DispatchQueue.main.async {
                    self.tblRestList.reloadData()
                    self.activityIndicatorRestList.stopAnimating()
                }
                return
            }
//            let postDict = postsjson
            var postsArray : NSArray
            postsArray = postsjson["posts"]! as NSArray
//            let postsArray : NSArray  = postsjson as NSArray
            
            //traversing through all elements of the array
            self.posts.removeAll()
            
            for i in 0..<postsArray.count{
                
                //adding post values to the post list
                
                self.posts.append(Post(
                    title: (postsArray[i] as AnyObject).value(forKey: "title") as? String,
                    description: (postsArray[i] as AnyObject).value(forKey: "description") as? String,
                    image: (postsArray[i] as AnyObject).value(forKey: "image") as? String,
                    published_at: (postsArray[i] as AnyObject).value(forKey: "published_at") as? String))
            }
            DispatchQueue.main.async {
                self.tblRestList.reloadData()
                self.activityIndicatorRestList.stopAnimating()
            }
        }
        datatask.resume()
    }
    
    @objc func refreshTableData() {
        parseJSON()
        self.tblRestList.reloadData()
        self.refreshCtrl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

