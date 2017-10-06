//
//  DetailViewController.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/4/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    var postItem: Post = Post()
    var albumItem: Album = Album()
    var photoCollectionArray:[Photo] = []
    
    func configureView() {
        
        // Update the user interface for the detail item.
        
        /*
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.description
            }
        }
        */
        
        self.postTitleLabel.text = postItem.title
        self.postBodyLabel.text = postItem.body
        self.albumTitleLabel.text = albumItem.title
        
        /*
        if let label1 = postTitleLabel{
            label1.text = self.postItem.title
        }
        
        if let label2 = postBodyLabel{
            label2.text = self.postItem.body
        }
         */
 
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

