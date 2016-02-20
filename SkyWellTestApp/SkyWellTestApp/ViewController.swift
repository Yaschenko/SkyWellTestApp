//
//  ViewController.swift
//  SkyWellTestApp
//
//  Created by Yurii on 2/19/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

class ViewController: UIViewController, UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate {
    var isLoading:Bool = false
    var client:APIClient! = APIClient()
    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var tableView:UITableView!
    var data:[Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        if APIClient.token != nil {
            webView.hidden = true
            self.refresh(nil)
        } else {
            webView.loadRequest(NSURLRequest(URL: NSURL(string: APIClient.kAutorizationUrlString)!))
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func logout() {
        self.client.logout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func refresh(refreshControl: UIRefreshControl?) {
        if self.isLoading {
            return;
        }
        self.isLoading = true
        var page:String? = self.client.nextPage
        if refreshControl != nil {page = nil}
        self.client.loadData(page) { (client) -> Void in
            self.data.removeAll()
            let array:[Post]! = Post.MR_findAllSortedBy("date", ascending: false) as! [Post]
            if array.count != self.data.count {
                self.data.insertContentsOf(array, at: 0)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    self.isLoading = false
                    if refreshControl != nil {
                        refreshControl!.endRefreshing()
                    }
                })
            }
        }
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        let currentURL:NSURL? = webView.request?.URL
        if ((currentURL == nil)||(currentURL!.path != "/blank.html")) {return}
        if (APIClient.parceVKAuthResult(currentURL?.absoluteString)) {
            webView.hidden = true
            self.refresh(nil)
        }

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post:Post = data[indexPath.row]
        let cell:CustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("TextAndImageCell", forIndexPath: indexPath) as! CustomTableViewCell

        cell.photoView.cancelImageDownloadTask()
        cell.photoView.image = nil
        cell.label.text = post.text
        
        if post.relationship?.count > 0 {
            let imageRequest:NSURLRequest = NSURLRequest(URL: NSURL(string: post.relationship!.first!.url!)!, cachePolicy:NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 60)
            cell.photoView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: nil, failure: nil)
        }
        cell.textHeight.constant = self.textHeight(post.text!, width: tableView.frame.size.width - 30)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post:Post = data[indexPath.row]
        var imageHeight:CGFloat = 0
        
        if post.relationship?.count > 0 {
            if (post.relationship!.first!.width == nil)||(post.relationship!.first!.height == nil) {
                imageHeight = 60;
            } else {
                imageHeight = (tableView.frame.size.width - 30) / CGFloat(post.relationship!.first!.width!) * CGFloat(post.relationship!.first!.height!)
            }
        }
        return imageHeight + self.textHeight(post.text!, width: tableView.frame.size.width - 30)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row >= self.data.count-20)||(indexPath.row >= APIClient.totalDownloadPosts-20) {
            self.refresh(nil)
        }
    }
    
    func textHeight(text:String?, width:CGFloat)->CGFloat {
        if text == nil {return 0}
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = text!.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(15)], context: nil)
        
        return boundingBox.height + 6
    }
}

