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
    var label = -1
    override func viewDidLoad(){
        super.viewDidLoad()
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 108/255, green: 116/255, blue: 194/255, alpha: 1.0)
        let label = UILabel(frame: CGRect(x:0, y:0, width:100, height:100))
        label.text = String(self.label)
        view.addSubview(label)
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
                    for i in 0...JsonList.count{
                        let x = SongVC()
                        x.label = i
                        self.SongViews.append(x)
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
