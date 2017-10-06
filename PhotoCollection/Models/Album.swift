//
//  Album.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/5/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class Album: NSObject {

    var userId: String
    var id: String
    var title: String
    
    override init(){
        self.userId = ""
        self.id = ""
        self.title = ""
    }
    
}
