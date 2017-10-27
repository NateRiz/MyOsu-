//
//  UserPageVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/26/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit



class UserPageVC: UIPageViewController{
    
    var views = [UIViewController]()
    var currentPage = 0
    var json = [String:Any]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        self.populateViews()
        setViewControllers([views[currentPage]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func populateViews(){
        for i in 0...1{
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
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right:
                    self.currentPage = self.mod(self.currentPage-1,self.views.count)
                    setViewControllers([self.views[self.currentPage]], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
                    break
                case UISwipeGestureRecognizerDirection.left:
                    self.currentPage = ((self.currentPage+1)%self.views.count)
                    setViewControllers([self.views[self.currentPage]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                    break
                default:
                    break
            }
        }
    }
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }




}
