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
    
    
    //MARK: DUMMY DATA =====================================================================
    
    var dummyDataDictionary = DummyData().globalClothingAndVotes
    
    var photosIHaveLiked = DummyData().photosIHaveLiked
    
    var myUploadedPhotos = DummyData().myUploadedPhotos
    
    var imageURLArray = [String]()
    var votesArray = [Int]()
    
    
    //MARK: VIEW DID LOAD ==================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageURLArray = dummyDataDictionary.keys.array
        votesArray = dummyDataDictionary.values.array
        
        originalTabBarPlacement = tabBarController?.tabBar.frame.origin.y
        
        var avenir = UIFont(name: "AvenirNext-Medium", size: 16)!
        var attributes = [NSForegroundColorAttributeName : UIColor.blackColor(), NSFontAttributeName: avenir]
        var attributedString = NSAttributedString(string: "Pull to Refresh", attributes: attributes)
        
        refreshControl.attributedTitle = attributedString
        refreshControl.addTarget(self, action: "fetchAllData", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.addSubview(refreshControl)
        
    }
    
    func fetchAllData() {
        
        refreshControl.beginRefreshing()
        
        dummyDataDictionary = DummyData().photosIHaveLiked
        photosIHaveLiked = DummyData().myUploadedPhotos
        myUploadedPhotos = DummyData().globalClothingAndVotes
        
        tableView.reloadData()
        
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
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            imageURLArray = dummyDataDictionary.keys.array
            votesArray = dummyDataDictionary.values.array
            tableView.reloadData()
            
        case 1:
            imageURLArray = photosIHaveLiked.keys.array
            votesArray = photosIHaveLiked.values.array
            tableView.reloadData()
            
        case 2:
            imageURLArray = myUploadedPhotos.keys.array
            votesArray = myUploadedPhotos.values.array
            tableView.reloadData()
            
        default:
            println("no segment index selected")
        }
    }
    
    
    //MARK: TABLE VIEW =====================================================================
    
    //number of cells
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageURLArray.count
    }
    
    //cell content
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as StatsTableViewCell
        
        cell.rankLabel.text = "#\(indexPath.row + 1)"
        
        var imageURL = NSURL(string: imageURLArray[indexPath.row])
        var data = NSData(contentsOfURL: imageURL!)
        
        cell.itemImageView?.image = UIImage(data: data!)
        cell.itemImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        cell.itemImageView?.clipsToBounds = true
        
        cell.totalVotesLabel.text = "\(votesArray[indexPath.row])"
        
        return cell
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}