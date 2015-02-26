//
//  TableViewController.swift
//  Z00ty
//
//  Created by GTPWTW on 2/24/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var originalTabBarPlacement: CGFloat!
    
    var refreshControl = UIRefreshControl()
    
    //pull dummy data from json
    //organize by all users / all of my upVotes / and photos I've uploaded
    //then sort each array by most total votes (up - down)
    
    
    //MARK: DUMMY DATA =====================================================================
    
    var allPhotos = [Photos]()
    var allVotes = [VoteActions]()

    var myPhotos = [Photos]()
    var tableViewData = [Photos]()
    
    var token: String!
    
    //MARK: VIEW DID LOAD ==================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.tintColor = UIColor.whiteColor()
        
        originalTabBarPlacement = tabBarController?.tabBar.frame.origin.y
        
        var avenir = UIFont(name: "AvenirNext-Medium", size: 16)!
        var attributes = [NSForegroundColorAttributeName : UIColor.blackColor(), NSFontAttributeName: avenir]
        var attributedString = NSAttributedString(string: "Pull to Refresh", attributes: attributes)
        
        refreshControl.attributedTitle = attributedString
        refreshControl.addTarget(self, action: "pullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.addSubview(refreshControl)
        
        var userDefaults = NSUserDefaults()
        token = userDefaults.objectForKey("token") as String

        var url = NSURL(string: "http://zooty.herokuapp.com/api/v1/stats/")
        
        var request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "token")

        var session = NSURLSession.sharedSession()
        
        var dataTask = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            
            println("\n")
            println((response as NSHTTPURLResponse).statusCode)
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject]
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                println(jsonResult!)
                
                //set jsonResult to equal tableViewData here
                
                self.loadDataFromJSON()
                
                self.tableViewData = self.allPhotos
                
                self.seperateMyPhotos(self.allPhotos)
                
                self.sortByVote()
                
                self.tableView.reloadData()
            })
        })
        
        dataTask.resume()
    }
    
    
    //MARK: FUNCTIONS GALORE ===============================================================
    
    func loadDataFromJSON() {
        
        let path = NSBundle.mainBundle().pathForResource("photos", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!, options: nil, error: nil)
        var jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: nil) as [AnyObject]
        
        for photo in jsonResult {
            
            var photos = Photos()
            photos.phoneId = photo["phoneId"] as String
            photos.photoUrl = photo["photoUrl"] as String
            photos.up = photo["up"] as Int
            photos.down = photo["down"] as Int
            photos.total = photos.up - photos.down
            
            allPhotos.append(photos)
        }
    }
    
    
    func loadVoteDataFromJSON() {
        
        let path = NSBundle.mainBundle().pathForResource("votes", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!, options: nil, error: nil)
        var jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData!, options: nil, error: nil) as [AnyObject]
        
        for vote in jsonResult {
            
            var votes = VoteActions()
            votes.userID = vote["userId"] as String
            votes.photoURL = vote["photoUrl"] as String
            votes.registeredVote = vote["registeredVote"] as String
            
            allVotes.append(votes)
        }
        
    }
    
    
    func seperateMyPhotos(allPhotos: [Photos]) {
        for photo in allPhotos {
            if photo.phoneId == "0" {
                myPhotos.append(photo)
            }
        }
    }
    
    
    func sortByVote() {
        
        tableViewData.sort { (a, b) -> Bool in
            
            if a.total > b.total {
                return true
            } else {
                return false
            }
        }
    }

    
    func pullToRefresh() {
        
        refreshControl.beginRefreshing()
        
        refreshControl.endRefreshing()
    }
    
    
    //MARK: SCROLL VIEW ====================================================================
    
    var currentOffset: CGFloat!
    var previousOffset: CGFloat!
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        previousOffset = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        currentOffset = scrollView.contentOffset.y
        
        var speed = currentOffset - previousOffset
        
        //tabbar disappears
        if speed > 0 {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                var x = self.tabBarController?.tabBar.frame.origin.x
                var width = self.tabBarController?.tabBar.frame.size.width
                var height = self.tabBarController?.tabBar.frame.size.height
                
                self.tabBarController?.tabBar.frame = CGRect(
                    x: x!,
                    y: self.view.frame.size.height,
                    width: width!,
                    height: height!)
            })
            
        //tabbar reappears
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                var x = self.tabBarController?.tabBar.frame.origin.x
                var width = self.tabBarController?.tabBar.frame.size.width
                var height = self.tabBarController?.tabBar.frame.size.height
                
                self.tabBarController?.tabBar.frame = CGRect(
                    x: x!,
                    y: self.originalTabBarPlacement,
                    width: width!,
                    height: height!)
            })
        }
    }
    
    
    //MARK: UISEGMENTED CONTROL ============================================================
    
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {

        switchSegmentedControlIndex()
    }
    
    func switchSegmentedControlIndex() {
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            tableViewData = allPhotos
            sortByVote()
            tableView.reloadData()
            
        case 1:
            
            tableViewData = []
            tableView.reloadData()
            
        case 2:
            tableViewData = myPhotos
            sortByVote()
            tableView.reloadData()
            
        default:
            println("no segment index selected")
        }
    }
    
    
    //MARK: TABLE VIEW =====================================================================
    
    //number of cells
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewData.count
    }
    
    //cell content
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as StatsTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.rankLabel.text = "Rank: \(indexPath.row + 1)"
        cell.totalVotesLabel.text = "\(tableViewData[indexPath.row].up - tableViewData[indexPath.row].down) Votes"
        
        var imageQue = NSOperationQueue()
        imageQue.addOperationWithBlock { () -> Void in
            
            var imageURL = NSURL(string: self.tableViewData[indexPath.row].photoUrl)
            var data = NSData(contentsOfURL: imageURL!)
            var image = UIImage(data: data!)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in

                cell.itemImageView?.contentMode = UIViewContentMode.ScaleAspectFill
                cell.itemImageView?.clipsToBounds = true
                
                if self.tableViewData[indexPath.row].image == nil {
                    
                    self.tableViewData[indexPath.row].image = image
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                } else {
                    cell.itemImageView.image = self.tableViewData[indexPath.row].image
                }
                

            })
        }
        
        return cell
    }
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let selectedCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as StatsTableViewCell
//
//        selectedCell.selectionStyle = UITableViewCellSelectionStyle.None
//        
//        var longPress = UILongPressGestureRecognizer(target: self, action: "showZoomedImage")
//        selectedCell.imageView?.addGestureRecognizer(longPress)
//
//        var zoomedImage = UIImageView()
//
//        if longPress.state == UIGestureRecognizerState.Began {
//            
//            zoomedImage.frame.size = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.height-50)
//            zoomedImage.center = self.view.center
//            zoomedImage.clipsToBounds = true
//            zoomedImage.contentMode = UIViewContentMode.ScaleAspectFill
//            
//            zoomedImage.image = selectedCell.itemImageView.image
//            
//            zoomedImage.userInteractionEnabled = true
//            zoomedImage.addGestureRecognizer(longPress)
//            
//            view.addSubview(zoomedImage)
//            
//        } else if longPress.state == UIGestureRecognizerState.Ended {
//            
//        }
//    }
//    
//    func showZoomedImage() {
//        println("yo")
//    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}