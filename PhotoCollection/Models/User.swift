//
//  User.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/4/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class User: NSObject {

    var id: String
    var name: String
    var username: String
    var email: String
    var address: String
    
    override init(){
        self.id = ""
        self.name = ""
        self.username = ""
        self.email = ""
        self.address = ""
    }
    
}
