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
        self.postTitleLabel.text = postItem.title
        self.postBodyLabel.text = postItem.body
        self.albumTitleLabel.text = albumItem.title
        
        
        self.photoCollectionView.reloadData()
 
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        //asynchronously download the thumbnail image for each cell
        let imageViewForCell:UIImageView = cell.viewWithTag(77) as! UIImageView
        imageViewForCell.downloadImageFromNetworkAtURL(url: photoCollectionArray[indexPath.row].thumbnailUrl)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

        
        let largeDetailViewController:LargeDetailViewController = LargeDetailViewController.init()
        largeDetailViewController.modalPresentationStyle = .formSheet
        largeDetailViewController.navigationItem.title = "Big Picture"
        let navController:UINavigationController = UINavigationController(rootViewController: largeDetailViewController)
        navController.modalPresentationStyle = .formSheet
        
        
        
        
        //largeDetailViewController.navigationBar.topItem = "Big Picture"
        
        
        
        self.present(navController, animated: true) {
            //completion after presenting view controller
        }
        
        
    }
    
}

