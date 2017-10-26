//
//  SearchVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/26/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate{

    
    
    @IBOutlet weak var OsuSearchBar: UISearchBar!
    @IBOutlet weak var SearchResultStack: UIStackView!
    
    let API_URL = "https://osu.ppy.sh/api/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OsuSearchBar.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
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
