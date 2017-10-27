//
//  UserDetailedStatsVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/27/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit





class UserDetailedStatsVC: UIViewController{
    

    @IBOutlet weak var DetailStatsTable: UITableView!
    var json = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }


}
