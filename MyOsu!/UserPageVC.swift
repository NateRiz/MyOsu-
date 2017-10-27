//
//  UserPageVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/26/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit

class UserPageVC: UIPageViewController {

    var views = [UIViewController]()
    var json = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateViews()
        setViewControllers([views[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func populateViews(){
        for i in 0...1{
            print("Creating >>> " + String(i))
            let searchResultVC = self.storyboard!.instantiateViewController(withIdentifier: "searchResultVC"+String(i))
            if let srvc = searchResultVC as? SearchResultVC{
                srvc.json = self.json
            }
            else if let srvc = searchResultVC as? UserDetailedStatsVC{
                srvc.json = self.json
            }
            views.append(searchResultVC)
            
        }
    }

}
