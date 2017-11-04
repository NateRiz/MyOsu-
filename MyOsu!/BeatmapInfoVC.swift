//
//  BeatmapInfoVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 11/3/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import Alamofire

class SongVC: UIViewController{
    var image: UIImage?
    var name = ""
    var artist = ""
    var duration = ""
    var id = ""
    var pages = [Int]() // [self pg number, total page number]
    
    override func loadView() {
        view = UIView()
        print(self.pages)
        let PageDots = UIPageControl(frame: CGRect(x:168, y:130, width:39, height:37))
        //PageDots.updateCurrentPageDisplay()
        PageDots.numberOfPages = self.pages[1]
        PageDots.currentPage = self.pages[0]
        PageDots.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(PageDots)
        NSLayoutConstraint(item: PageDots, attribute: .centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  PageDots, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .top, multiplier: 1, constant: 610).isActive = true
        NSLayoutConstraint(item:  PageDots, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        view.backgroundColor = UIColor(displayP3Red: 108/255, green: 116/255, blue: 194/255, alpha: 1.0)
        var SongImageView = UIImageView(frame: CGRect(x:123, y:0, width:128, height: 128))
        SongImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(SongImageView)
        NSLayoutConstraint(item: SongImageView, attribute: .leading, relatedBy: .equal, toItem:view, attribute: .leading, multiplier: 1, constant: 123).isActive = true
        NSLayoutConstraint(item: SongImageView, attribute: .trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -124).isActive = true
        NSLayoutConstraint(item: SongImageView, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: SongImageView, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -539).isActive = true
        
        if self.image != nil{
            SongImageView.image = self.image!
        }else{
            print("image is nil :(")
        }
        
        
    }
    
}

class BeatmapInfoVC: UIPageViewController {
    var name = String()
    var artist = String()
    var duration = String()
    var id = String()
    var image: UIImage?
    
    
    var SongViews = [SongVC]()
    var CurrentPage = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callAPI()


        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                self.CurrentPage = self.mod(self.CurrentPage-1,self.SongViews.count)
                setViewControllers([self.SongViews[self.CurrentPage]], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
                break
            case UISwipeGestureRecognizerDirection.left:
                self.CurrentPage = ((self.CurrentPage+1)%self.SongViews.count)
                setViewControllers([self.SongViews[self.CurrentPage]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                break
            default:
                break
            }
        }
    }
    
    func callAPI(){
        Alamofire.request("https://osu.ppy.sh/api/get_beatmaps?&k=374c71b25b90368c6a0f3401983325ff98443313&s="+self.id).responseJSON { response in
            if let json = response.result.value {
                //print("JSON: \(json)") // serialized json response
                if let JsonList = json as? [[String:Any]]{
                    for i in 0..<JsonList.count{
                        let set = SongVC()
                        set.name = self.name
                        set.image = self.image
                        set.artist = self.artist
                        set.duration = self.duration
                        set.id = self.id
                        set.pages = [i,JsonList.count]
                        self.SongViews.append(set)
                    }
                    if self.SongViews.count > 0{
                        self.CurrentPage = 0
                        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
                        swipeLeft.direction = .left
                        self.view.addGestureRecognizer(swipeLeft)
                        
                        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
                        swipeRight.direction = .right
                        self.view.addGestureRecognizer(swipeRight)
                        self.setViewControllers([self.SongViews[self.CurrentPage]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                        
                    }
                }
                
            }
        }
    }
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
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
