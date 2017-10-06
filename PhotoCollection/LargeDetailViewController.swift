//
//  LargeDetailViewController.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/6/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import UIKit

class LargeDetailViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView!
    

    var photoItem: Photo = Photo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed(_:)))
        self.modalPresentationStyle = .formSheet
        // Do any additional setup after loading the view.
        
       
        
        configureView()
    }

    
    func configureView() {
        
        // Update the user interface for the detail item.
        self.navigationItem.title = photoItem.title
        
        //asynchronously download the large image
        self.imageView.downloadImageFromNetworkAtURL(url: photoItem.url)
    }
    
    @objc
    func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            //extra code here if needed
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
