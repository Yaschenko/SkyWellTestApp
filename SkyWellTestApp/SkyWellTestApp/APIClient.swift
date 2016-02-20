//
//  APIClient.swift
//  SkyWellTestApp
//
//  Created by Yurii on 2/19/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

import UIKit
import AFNetworking
import MagicalRecord

class APIClient: NSObject {
    static let kResponseField:String = "response"
    static let kNextFromField:String = "next_from"
    static let kStartFrom:String = "start_from"
    static let kAccessToken:String = "access_token"
    static let kGetFeedsUrlString:String = "https://api.vk.com/method/newsfeed.get?v=5.45&filters=post&"
    static let kAutorizationUrlString:String = "https://oauth.vk.com/authorize?client_id=3308962&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=friends&response_type=token&v=5.45&scope=wall,friends,offline"
    static var token:String?
    
    var currentPage:String! = ""
    var nextPage:String? = nil
    var error:NSError?
    static var totalDownloadPosts:Int = 0
    let manager:AFHTTPSessionManager = AFHTTPSessionManager()
    
    override init() {
        if  (APIClient.token == nil) {
            APIClient.token = NSUserDefaults.standardUserDefaults().valueForKey(APIClient.kAccessToken) as? String
        }
    }
    func parceResults(results:NSDictionary!, callback:(client:APIClient)->Void) -> Void {
        if results.valueForKey(APIClient.kResponseField) == nil {
            callback(client: self)
            return
        }

        self.nextPage = results[APIClient.kResponseField]![APIClient.kNextFromField] as? String
        MagicalRecord.saveWithBlock({ (context) -> Void in
            let res:[AnyObject] = results[APIClient.kResponseField]!["items"] as! [AnyObject]
            APIClient.totalDownloadPosts += res.count
            
            for item in res {
                var post:Post? = Post.MR_findFirstByAttribute("postId", withValue: (item["post_id"] as? NSNumber)!, inContext:context)
                if post != nil {
                    continue
                }
                if item.valueForKey("copy_history") != nil {continue}
                post = Post.MR_createEntityInContext(context)!
                post?.setData(item as! [NSObject : AnyObject])
            }
            }) { (result, error) -> Void in
                callback(client: self)
        }
    }
    func loadData(page:String?, callback:(client:APIClient)->Void) {
        
        if (APIClient.token == nil) {
            self.error = NSError(domain: "Not Authorized", code: 500, userInfo: nil)
            callback(client: self)
        }
        
        if (page == nil) {self.currentPage = ""} else {self.currentPage = page}
        
        self.manager.GET(APIClient.kGetFeedsUrlString+APIClient.kAccessToken+"="+APIClient.token!+"&"+APIClient.kStartFrom+"="+self.currentPage, parameters: nil, progress:nil, success: { (dataTask, data) -> Void in
            
            self.parceResults(data as! NSDictionary, callback: callback)
            
            },failure: { (dataTask, error) -> Void in
                self.error = error
                callback(client: self)
        })
    }
    static func parceVKAuthResult(result:String!) -> Bool {
        let updateResul = result.stringByReplacingOccurrencesOfString("#", withString: "&")
        let params:NSMutableDictionary! = NSMutableDictionary()
        for param in updateResul.componentsSeparatedByString("&") {
            let elements:[String] = param.componentsSeparatedByString("=")
            if elements.count > 1 {
                params.setValue(elements[1], forKey: elements[0])
            }
        }
        if params.valueForKey(APIClient.kAccessToken) != nil {
            APIClient.token = params.valueForKey(APIClient.kAccessToken) as? String
            NSUserDefaults.standardUserDefaults().setValue(APIClient.token, forKey: APIClient.kAccessToken)
            return true
        }
        return false
    }
    func logout () {
        self.manager.GET("https://oauth.vk.com/logout", parameters: nil, progress: nil, success: nil, failure: nil)
        APIClient.token = nil
        NSUserDefaults.standardUserDefaults().removeObjectForKey(APIClient.kAccessToken)
    }
}
