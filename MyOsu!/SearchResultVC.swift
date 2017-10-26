//
//  SearchResultVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/26/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController {
    
    var json = [String:Any]()
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreateProfile()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func CreateProfile()
    {
        if let name = self.json["username"] as? String{
            DispatchQueue.main.async {
                self.username.text = name
            }
        }

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
