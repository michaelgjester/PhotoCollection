//
//  MasterViewController.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/4/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    private var postArray:[Post] = []
    private var userArray:[User] = []
    private var albumArray:[Album] = []
    private var photoArray:[Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //configure the split view
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.title = "Challenge Accepted!"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120.0
        
        //app currently not using an + button to add new item, might add one later
        /*
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        */
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        //grab data from network
        self.performNetworkCalls()
        self.updateCoreData()
        
        //after networking completes, reload table
        //make sure table reload (and any other animations)
        //finishes reloading before showing detail information for first row
        UIView.animate(withDuration: 0, animations: {
            //first reload the data
            self.tableView.reloadData()
        }) { (finished) in
            //wait until the master table view is loaded
            //before displaying the detail view for the first row
            let indexPathForFirstRow:IndexPath = IndexPath.init(row: 0, section: 0)
            self.showDetailViewControllerForRowAtIndexPath(indexPath: indexPathForFirstRow)
        }
        
        
        
    }
    
    func performNetworkCalls(){
        
        //use a dispatch group to ensure all network calls are completed
        let dispatchGroup = DispatchGroup()
        
        
        //load users
        dispatchGroup.enter()
        NetworkingManager.loadObjectsWithCompletion(requestStringSuffix: "users") { [weak self](userArray:[NSObject]) in
            self?.userArray = userArray as! [User]
            dispatchGroup.leave()
        }
        
        //load posts
        dispatchGroup.enter()
        NetworkingManager.loadObjectsWithCompletion(requestStringSuffix: "posts") { [weak self](postArray:[NSObject]) in
            self?.postArray = postArray as! [Post]
            dispatchGroup.leave()
        }
        
        //load albums
        dispatchGroup.enter()
        NetworkingManager.loadObjectsWithCompletion(requestStringSuffix: "albums") { [weak self](albumArray:[NSObject]) in
            self?.albumArray = albumArray as! [Album]
            dispatchGroup.leave()
        }
        
        //load photos
        dispatchGroup.enter()
        NetworkingManager.loadObjectsWithCompletion(requestStringSuffix: "photos") { [weak self](photoArray:[NSObject]) in
            self?.photoArray = photoArray as! [Photo]
            dispatchGroup.leave()
        }
        
        //wait until network calls are complete
        dispatchGroup.wait()
    }
    
    func updateCoreData(){
        CoreDataManager.clearData()
        CoreDataManager.insertPostArray(postArray: self.postArray)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //app currently not using an + button to add new item, might add one later
    /*
    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    */
    

    // MARK: - Table View Delegate/DataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        //configure the text for the labels in the table view cells
        let postTitleLabel: UILabel = cell.viewWithTag(99) as! UILabel
        let postAuthorEmailLabel: UILabel = cell.viewWithTag(98) as! UILabel
        
        postTitleLabel.text = self.postArray[indexPath.row].title
    
        //user email is not in the post array objects, so use the userId field to
        //cross-reference the email address from the userArray
        let userId = self.postArray[indexPath.row].userId
        if let userForPost:User = self.userArray.first(where:{$0.id == userId}){
            postAuthorEmailLabel.text = userForPost.email
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.postArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetailViewControllerForRowAtIndexPath(indexPath: indexPath)
    }
    
    func showDetailViewControllerForRowAtIndexPath(indexPath:IndexPath){
        
        //note there is a one-to-one correlation between posts
        //and albums, i.e. there is a unique id field for each
        self.detailViewController?.postItem = self.postArray[indexPath.row]
        self.detailViewController?.albumItem = self.albumArray[indexPath.row]
        
        //get a subset of photos corresponding to only that album
        let albumId = self.detailViewController?.albumItem.id
        self.detailViewController?.photoCollectionArray = self.photoArray.filter({$0.albumId == albumId})
        
        //let the detail view controller configure itself now that it has the
        //proper model objects passed to it
        self.detailViewController?.configureView()
        
        //configure navigation items for the detail view controller
        self.detailViewController?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.detailViewController?.navigationItem.leftItemsSupplementBackButton = true
    }

}

