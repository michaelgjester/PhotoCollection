//
//  NetworkingManager.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/4/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import Foundation

class NetworkingManager: NSObject {

    static let networkQueue: OperationQueue = OperationQueue()
    //OperationQueue.main
    
    static func loadPostsWithCompletion(completionHandler:@escaping ([Post])->Void) -> Void {
        
        let baseRequestString = "https://jsonplaceholder.typicode.com/posts/"
        
        
        guard let url = URL(string: baseRequestString) else {
            print("Error: cannot create URL")
            return
        }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config,
                                 delegate: nil,
                                 delegateQueue: networkQueue)
        
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
                        
                        let postArray: [Post] = self.processJsonResponse(postDictionaryArray: responseArray)

                        //perform completion handler on post array
                        completionHandler(postArray)
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
    
    static func loadUsersWithCompletion(completionHandler:@escaping ([User])->Void) -> Void {
        
        let baseRequestString = "https://jsonplaceholder.typicode.com/users/"
        
        
        guard let url = URL(string: baseRequestString) else {
            print("Error: cannot create URL")
            return
        }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config,
                                 delegate: nil,
                                 delegateQueue: networkQueue)
        
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
                        
                        
                        //print(" user responseDictionary = \(responseArray)")
                        
                        var userArray: [User] = self.processJsonResponseForUser(userDictionaryArray: responseArray)
                        
                        //print("user Array[0] =\(userArray[0])")
                        //perform completion handler on post array
                        completionHandler(userArray)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        task.resume()
    }
    
    private static func processJsonResponseForUser(userDictionaryArray:[[String:AnyObject]])->[User]{
        
        var userArray:[User] = []
        
        for currentUserDictionary in userDictionaryArray{
            let currentUser:User = User()
            currentUser.id = currentUserDictionary["id"]!.stringValue as String
            currentUser.name = currentUserDictionary["name"] as! String
            currentUser.username = currentUserDictionary["username"] as! String
            currentUser.email = currentUserDictionary["email"] as! String
            currentUser.address = "(mock address)" //currentUserDictionary["address"] as! String
            
            userArray.append(currentUser)
        }
        
        return userArray
    }
    
    static func loadObjectsWithCompletion(requestStringSuffix:String, completionHandler:@escaping ([NSObject])->Void) -> Void {
        
        let baseRequestString = "https://jsonplaceholder.typicode.com/"
        let fullRequestString = baseRequestString + requestStringSuffix + "/"
        
        guard let url = URL(string: fullRequestString) else {
            print("Error: cannot create URL")
            return
        }
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config,
                                 delegate: nil,
                                 delegateQueue: networkQueue)
        
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
                        
                        
                        var modelObjectArray: [NSObject] = []
                        
                        if (requestStringSuffix.elementsEqual("albums")){
                            modelObjectArray = self.processJsonResponseForAlbum(albumDictionaryArray: responseArray)
                        } else if (requestStringSuffix.elementsEqual("photos")){
                            modelObjectArray = self.processJsonResponseForPhoto(photoDictionaryArray: responseArray)
                        }
                        
                        //perform completion handler on model object array
                        completionHandler(modelObjectArray)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        task.resume()
    }
    
    private static func processJsonResponseForAlbum(albumDictionaryArray:[[String:AnyObject]])->[Album]{
        
        var albumArray:[Album] = []
        
        for currentAlbumDictionary in albumDictionaryArray{

            let currentAlbum:Album = Album()
            
            currentAlbum.userId = currentAlbumDictionary["userId"]!.stringValue as String
            currentAlbum.id = currentAlbumDictionary["id"]!.stringValue as String
            currentAlbum.title = currentAlbumDictionary["title"] as! String

            albumArray.append(currentAlbum)
        }
        
        return albumArray
    }
    
    private static func processJsonResponseForPhoto(photoDictionaryArray:[[String:AnyObject]])->[Photo]{
        
        var photoArray:[Photo] = []
        
        for currentPhotoDictionary in photoDictionaryArray{
            
            let currentPhoto:Photo = Photo()
            
            currentPhoto.albumId = currentPhotoDictionary["albumId"]!.stringValue as String
            currentPhoto.id = currentPhotoDictionary["id"]!.stringValue as String
            currentPhoto.title = currentPhotoDictionary["title"] as! String
            currentPhoto.url = currentPhotoDictionary["url"] as! String
            currentPhoto.thumbnailUrl = currentPhotoDictionary["thumbnailUrl"] as! String
            
            photoArray.append(currentPhoto)
        }
        
        return photoArray
    }
    
    /// Network call for downloading an image from the network
    ///
    /// - parameters:
    ///     - urlString - a string value associated with a URL containing an image,
    ///     e.g. "http://placehold.it/150/b04f2e"
    ///     - downloadCompletionHandler - callback executed after network response
    /// - returns: void
    static func downloadImageAtURL(urlString: String, downloadCompletionHandler:@escaping ((Data)->Void)){
        
        
        guard let url = URL(string: urlString) else {
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
                downloadCompletionHandler(data!)
            } else {
                print("Error: response in nil")
            }
            
        }
        
        task.resume()
    }
}
