//
//  UIImage+Networking.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import Foundation

import UIKit

extension UIImageView{
    
    /// Method to populate image in ImageView with an image downloaded from the network
    ///
    /// NOTE: On initial call for a given image/request string, a spinner is displayed while
    /// the image is asynchronously being retrieved.
    ///
    /// On subsequent calls, the image will be retrieved from the ImageCache without extraneous network calls
    ///
    /// - parameters:
    ///     - url - string value of a url containing an image
    ///     e.g. http://placehold.it/150/b04f2e
    /// - returns: void
    func downloadImageFromNetworkAtURL(url: String){
        
        //check to see if valid URL is being used (e.g. could be empty)
        let isValidURL = url.contains("http://") || url.contains("https://")
        if !isValidURL{
            self.image =  UIImage(named:"defaultThumbnail.png")
            return
        }
        
        //first check to see if we have a cached image, if so return early
        if let cachedImage = ImageCache.sharedInstance.object(forKey: url as NSString){
            self.image = cachedImage
            return
        }
        
        //if no cached image, perform a network call to retrieve image
        //show activity spinner
        let activityIndicatorFrame: CGRect = CGRect.init(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView.init(frame: activityIndicatorFrame)
        spinner.color = UIColor.black
        spinner.backgroundColor = UIColor.gray
        spinner.hidesWhenStopped = true
        self.addSubview(spinner)
        spinner.startAnimating()
        
        
        let downloadImageCompletionHandler: ((Data) -> Void) = { [weak self] (imageData:Data) -> Void in
            
            DispatchQueue.main.async {
                if let imageFromData = UIImage.init(data:imageData){
                    //populate the image in the image view
                    //cache the image for the next time it is needed
                    self?.image = imageFromData
                    ImageCache.sharedInstance.setObject(imageFromData, forKey: url as NSString)
                }
            }
            
            
            //stop spinner
            spinner.stopAnimating()
        }
        
        NetworkingManager.downloadImageAtURL(urlString: url, downloadCompletionHandler: downloadImageCompletionHandler)
        
    }
    
}
