//
//  DetailViewController.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/4/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
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
        
        
        
        self.photoCollectionView.reloadData()
        
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
        
        //set the delegate methods
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.delegate = self
        
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

    // MARK: - CollectionView Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return photoCollectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        let imageViewForCell:UIImageView = cell.viewWithTag(77) as! UIImageView
        
        imageViewForCell.downloadImageFromNetworkAtURL(url: photoCollectionArray[indexPath.row].thumbnailUrl)
        
        return cell
    }

    
}

