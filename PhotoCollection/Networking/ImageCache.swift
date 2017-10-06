//
//  ImageCache.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class ImageCache: NSCache<NSString, UIImage> {

    static let sharedInstance = ImageCache()
    
    private override init(){
        super.init()
    }
    
}
