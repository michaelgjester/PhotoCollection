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
        navigationItem.leftBarButtonItem = editButtonItem

        navigationItem.title = "Challenge Accepted!"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        
        /*
        let loadPostsCompletionHandler: ([Post]) -> Void = {[weak self] (postArray:[Post]) -> Void in
            self?.postArray = postArray
            self?.tableView.reloadData()
        }
        NetworkingManager.loadPostsWithCompletion(completionHandler:loadPostsCompletionHandler)
        */
        
        let loadUserCompletionHandler: ([User]) -> Void = {[weak self] (userArray:[User]) -> Void in
            //populate the user array
            self?.userArray = userArray
            
            //once user array is complete, populate the posts
            let loadPostsCompletionHandler: ([Post]) -> Void = {[weak self] (postArray:[Post]) -> Void in
                self?.postArray = postArray
                self?.tableView.reloadData()
            }
            NetworkingManager.loadPostsWithCompletion(completionHandler:loadPostsCompletionHandler)
        }
        NetworkingManager.loadUsersWithCompletion(completionHandler:loadUserCompletionHandler)
        
        //load albums
        NetworkingManager.loadObjectsWithCompletion(requestStringSuffix: "albums") { [weak self](albumArray:[NSObject]) in
            self?.albumArray = albumArray as! [Album]
        }
        
        //load photos
        NetworkingManager.loadObjectsWithCompletion(requestStringSuffix: "photos") { [weak self](photoArray:[NSObject]) in
            self?.photoArray = photoArray as! [Photo]
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120.0
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    */

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        //let object = objects[indexPath.row] as! NSDate
        //cell.textLabel!.text = object.description
        
        //cell.textLabel!.text = self.postArray[indexPath.row].title
        let postTitleLabel: UILabel = cell.viewWithTag(99) as! UILabel
        let postAuthorEmailLabel: UILabel = cell.viewWithTag(98) as! UILabel
        
        postTitleLabel.text = self.postArray[indexPath.row].title
        
        let userId = self.postArray[indexPath.row].userId
        
        if let userForPost:User = self.userArray.first(where:{$0.id == userId}){
            postAuthorEmailLabel.text = userForPost.email
            //cell.detailTextLabel?.text = userForPost.name
            
            //cell.textLabel!.text = userForPost.name
        }
        
//        if let userForPost:User = self.userArray.index(where:{ $0.id == userId }) as? User{
//            //let eventSourceForLocal = eventStore.sources[index]
//            cell.detailTextLabel!.text = userForPost.name
//        }
        
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //objects.remove(at: indexPath.row)
            self.postArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //FIXME
        print("selected row = \(indexPath.row)")
        
        //note there is a one-to-one correlation between posts
        //and albums, i.e. there is a unique id field for each
        self.detailViewController?.postItem = self.postArray[indexPath.row]
        self.detailViewController?.albumItem = self.albumArray[indexPath.row]
        
        self.detailViewController?.configureView()
        
        //controller.detailItem = object
        self.detailViewController?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.detailViewController?.navigationItem.leftItemsSupplementBackButton = true
    }

}

