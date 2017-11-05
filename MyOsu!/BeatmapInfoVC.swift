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
        view.backgroundColor = UIColor(displayP3Red: 108/255, green: 116/255, blue: 194/255, alpha: 1.0)
        
        let PageDots = UIPageControl(frame: CGRect(x:168, y:130, width:39, height:37))
        PageDots.numberOfPages = self.pages[1]
        PageDots.currentPage = self.pages[0]
        PageDots.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(PageDots)
        NSLayoutConstraint(item: PageDots, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  PageDots, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 610).isActive = true
        NSLayoutConstraint(item:  PageDots, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        let SongImageView = UIImageView()
        SongImageView.contentMode = .scaleAspectFit
        SongImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(SongImageView)
        NSLayoutConstraint(item: SongImageView, attribute: .leading, relatedBy: .equal, toItem:view, attribute: .leading, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: SongImageView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item: SongImageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -259).isActive = true
        if self.image != nil{
            SongImageView.image = self.image!
        }else{
            print("image is nil :(")
        }
        
        
        let TempView = UIView()
        TempView.translatesAutoresizingMaskIntoConstraints = false
        TempView.backgroundColor = UIColor.clear
        view.addSubview(TempView)
        NSLayoutConstraint(item: TempView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: TempView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  TempView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  TempView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: TempView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 128).isActive = true
        NSLayoutConstraint(item: TempView, attribute: .top, relatedBy: .equal, toItem: SongImageView, attribute: .bottom, multiplier: 1, constant: 8).isActive = true
 
        
        let StaticStack = UIStackView() //Static parts of each set.. name, artist, etc
        StaticStack.translatesAutoresizingMaskIntoConstraints = false
        StaticStack.axis = .vertical
        StaticStack.distribution = .fillProportionally
        StaticStack.backgroundColor = .red
        view.addSubview(StaticStack)
        NSLayoutConstraint(item: StaticStack, attribute: .leading, relatedBy: .equal, toItem: SongImageView, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: StaticStack, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: StaticStack, attribute: .top, relatedBy: .equal, toItem: SongImageView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: StaticStack, attribute: .bottom, relatedBy: .equal, toItem: SongImageView, attribute: .bottom, multiplier: 1, constant:0).isActive = true
        
        
        
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
        
        
    }
    
}

class BeatmapInfoVC: UIPageViewController {

    
    var SongViews = [SongVC]()
    var SongJsons = [[String:Any]]()
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
