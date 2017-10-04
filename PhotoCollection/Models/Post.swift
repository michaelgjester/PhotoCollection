//
//  Post.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/4/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class Post: NSObject {

    var userId: String
    var id: String
    var title: String
    var body: String
    
    override init(){
        self.userId = ""
        self.id = ""
        self.title = ""
        self.body = ""
    }
    
}
