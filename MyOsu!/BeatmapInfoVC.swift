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
    var json = [String:Any]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 108/255, green: 116/255, blue: 194/255, alpha: 1.0)
        
        let StaticView = UIView()
        StaticView.backgroundColor = UIColor(displayP3Red: 255/255, green: 176/255, blue: 233/255, alpha: 1.0)
        StaticView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(StaticView)
        NSLayoutConstraint(item: StaticView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  StaticView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  StaticView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  StaticView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        
        
        let SongImageView = UIImageView()
        SongImageView.contentMode = .scaleAspectFit
        SongImageView.translatesAutoresizingMaskIntoConstraints = false
        StaticView.addSubview(SongImageView)
        NSLayoutConstraint(item: SongImageView, attribute: .leading, relatedBy: .equal, toItem:StaticView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: SongImageView, attribute: .top, relatedBy: .equal, toItem: StaticView, attribute: .top, multiplier: 1, constant: 4).isActive = true
                NSLayoutConstraint(item: SongImageView, attribute: .bottom, relatedBy: .equal, toItem: StaticView, attribute: .bottom, multiplier: 1, constant: -4).isActive = true
        NSLayoutConstraint(item: SongImageView, attribute: .trailing, relatedBy: .equal, toItem: StaticView, attribute: .trailing, multiplier: 1, constant: -259).isActive = true
        if self.image != nil{
            SongImageView.image = self.image!
        }else{
            print("image is nil :(")
        }
      
        let StaticStack = UIStackView() //Static parts of each set.. name, artist, etc
        StaticStack.translatesAutoresizingMaskIntoConstraints = false
        StaticStack.axis = .vertical
        StaticStack.distribution = .fillProportionally
        StaticView.addSubview(StaticStack)
        NSLayoutConstraint(item: StaticStack, attribute: .leading, relatedBy: .equal, toItem: SongImageView, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: StaticStack, attribute: .right, relatedBy: .equal, toItem: StaticView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: StaticStack, attribute: .top, relatedBy: .equal, toItem: SongImageView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: StaticStack, attribute: .bottom, relatedBy: .equal, toItem: StaticView, attribute: .bottom, multiplier: 1, constant:0).isActive = true
        
        let NameLabel = UILabel()
        NameLabel.font = UIFont(name: "System", size: 18)
        NameLabel.text = self.name
        StaticStack.addArrangedSubview(NameLabel)
        let ArtistLabel = UILabel()
        ArtistLabel.font = UIFont(name: "System", size: 14)
        ArtistLabel.text = self.artist
        ArtistLabel.textColor = UIColor.gray
        StaticStack.addArrangedSubview(ArtistLabel)
        let DurationLabel = UILabel()
        DurationLabel.text = self.duration
        DurationLabel.font = UIFont(name: "System", size: 14)
        StaticStack.addArrangedSubview(DurationLabel)
        
        
        
        let InfoScroll = UIScrollView()
        InfoScroll.translatesAutoresizingMaskIntoConstraints = false
        InfoScroll.backgroundColor = UIColor(displayP3Red: 255/255, green: 176/255, blue: 233/255, alpha: 1.0)
        view.addSubview(InfoScroll)
        NSLayoutConstraint(item: InfoScroll, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoScroll, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoScroll, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: InfoScroll, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 128).isActive = true
        NSLayoutConstraint(item: InfoScroll, attribute: .top, relatedBy: .equal, toItem: StaticView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        let InfoView = UIView()
        InfoView.translatesAutoresizingMaskIntoConstraints = false
        InfoScroll.addSubview(InfoView)
        NSLayoutConstraint(item: InfoView, attribute: .leading, relatedBy: .equal, toItem: InfoScroll, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoView, attribute: .trailing, relatedBy: .equal, toItem: InfoScroll, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoView, attribute: .top, relatedBy: .equal, toItem: InfoScroll, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoView, attribute: .bottom, relatedBy: .equal, toItem: InfoScroll, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        
        let InfoStack = UIStackView()
        InfoStack.axis = .vertical
        StaticStack.distribution = .fillEqually
        InfoStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(InfoStack)
        NSLayoutConstraint(item: InfoStack, attribute: .top, relatedBy: .equal, toItem: InfoView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: InfoStack, attribute: .leading, relatedBy: .equal, toItem: InfoView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoStack, attribute: .trailing, relatedBy: .equal, toItem: InfoView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoStack, attribute: .bottom, relatedBy: .equal, toItem: InfoView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        


        print(self.json)
        if let difficulty = self.json["version"] as? String{
            let versionLabel = UILabel()
            versionLabel.textColor = .white
            versionLabel.text = "Version: " + difficulty
            InfoStack.addArrangedSubview(versionLabel)
        }
        if let circle_size = self.json["diff_size"] as? String{
            let circle = UILabel()
            circle.textColor = .white
            circle.text = "Circle Size: " + circle_size
            InfoStack.addArrangedSubview(circle)
        }
        if let diff_drain = self.json["diff_drain"] as? String{
            let drain = UILabel()
            drain.textColor = .white
            drain.text = "Drain: " + diff_drain
            InfoStack.addArrangedSubview(drain)
        }
        if let diff_overall = self.json["diff_overall"] as? String{
            let accuracy = UILabel()
            accuracy.textColor = .white
            accuracy.text = "Accuracy: " + diff_overall
            InfoStack.addArrangedSubview(accuracy)
        }
        if let diff_approach = self.json["diff_approach"] as? String{
            let approach = UILabel()
            approach.textColor = .white
            approach.text = "Approach Rate: " + diff_approach
            InfoStack.addArrangedSubview(approach)
        }
        
        
        
        
        

        let PageDots = UIPageControl(frame: CGRect(x:168, y:130, width:39, height:37))
        PageDots.numberOfPages = self.pages[1]
        PageDots.currentPage = self.pages[0]
        PageDots.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(PageDots)
        NSLayoutConstraint(item: PageDots, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  PageDots, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 610).isActive = true
        NSLayoutConstraint(item:  PageDots, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
}

class BeatmapInfoVC: UIPageViewController {

    
    var SongViews = [SongVC]()
    var CurrentPage = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreateViews()
    
        
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
    
    func CreateViews(){
        
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
