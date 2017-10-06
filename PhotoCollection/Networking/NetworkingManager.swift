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
    
    /// Network call for retrieving model objects
    ///
    /// - parameters:
    ///     - requestStringSuffix - a string value such as "posts", "users", which becomes part of the request string
    ///
    ///     - completionHandler - callback executed after network response
    /// - returns: void
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
                        
                        //depending upon the request string we process the json response differently
                        var modelObjectArray: [NSObject] = []
                        if(requestStringSuffix.elementsEqual("posts")){
                            modelObjectArray = self.processJsonResponseForPosts(postDictionaryArray: responseArray)
                        } else if (requestStringSuffix.elementsEqual("users")){
                            modelObjectArray = self.processJsonResponseForUser(userDictionaryArray: responseArray)
                        } else if (requestStringSuffix.elementsEqual("albums")){
                            modelObjectArray = self.processJsonResponseForAlbum(albumDictionaryArray: responseArray)
                        } else if (requestStringSuffix.elementsEqual("photos")){
                            modelObjectArray = self.processJsonResponseForPhoto(photoDictionaryArray: responseArray)
                        } else {
                            print("Error: unrecognized request string")
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
    
    private static func processJsonResponseForPosts(postDictionaryArray:[[String:AnyObject]])->[Post]{
        
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
