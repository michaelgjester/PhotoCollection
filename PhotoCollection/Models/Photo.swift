//
//  Photo.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class Photo: NSObject {

    var albumId: String
    var id: String
    var title: String
    var url: String
    var thumbnailUrl: String
    
    override init(){
        self.albumId = ""
        self.id = ""
        self.title = ""
        self.url = ""
        self.thumbnailUrl = ""
    }
    
}
