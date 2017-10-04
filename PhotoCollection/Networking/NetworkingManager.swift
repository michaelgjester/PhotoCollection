//
//  NetworkingManager.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/4/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import Foundation

class NetworkingManager: NSObject {


    static func loadPostsWithCompletion(completionHandler:@escaping ()->Void) -> Void {
        
        let baseRequestString = "https://jsonplaceholder.typicode.com/posts/"
        
        
        guard let url = URL(string: baseRequestString) else {
            print("Error: cannot create URL")
            return
        }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config,
                                 delegate: nil,
                                 delegateQueue: OperationQueue.main)
        
        // make the request with the session
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            //check 1: no errors
            guard error == nil else {
                print("error calling the request:\(error!)")
                return
            }
            
            //check 2: data is non-nil
            guard data != nil else {
                print("Error: data is nil")
                return
            }
            
            //check 3: response parameter is non-nil
            if response != nil {
                do {
                    
                    //JSON response is an array of dictionaries
                    if let responseArray = try JSONSerialization.jsonObject(with: data!, options: [])as? [[String: AnyObject]]{
                        
                        
                        print("responseDictionary = \(responseArray)")
                        
                        var postArray: [Post] = self.processJsonResponse(postDictionaryArray: responseArray)
                        
                        print("postArray[0] =\(postArray[0])")
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        task.resume()
    }
    
    private static func processJsonResponse(postDictionaryArray:[[String:AnyObject]])->[Post]{
        
        var postArray:[Post] = []
        
        for currentPostDictionary in postDictionaryArray{
            let currentPost:Post = Post()
            currentPost.userId = currentPostDictionary["userId"]!.stringValue as String
            currentPost.id = currentPostDictionary["id"]!.stringValue as String
            currentPost.title = currentPostDictionary["title"] as! String
            currentPost.body = currentPostDictionary["body"] as! String
            
            postArray.append(currentPost)
        }
        
        return postArray
    }
    
}
