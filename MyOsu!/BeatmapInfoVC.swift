//
//  BeatmapInfoVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 11/3/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import Alamofire


class BeatmapInfoCell: UITableViewCell{

    let info = UILabel()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        self.contentView.addSubview(info)
        self.contentView.backgroundColor = .clear
        info.textColor = .white
        info.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item:  info, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  info, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        print("added a label...")

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class SongVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    var image: UIImage?
    var name = ""
    var artist = ""
    var duration = ""
    var id = ""
    var pages = [Int]() // [self pg number, total page number]
    var json = [String:Any]()
    var info = [String]()
    let InfoTable = UITableView()
    let cellReuseIdentifier = "beatmapInfoCell"
    
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
        InfoView.backgroundColor = .clear
        InfoScroll.addSubview(InfoView)
        NSLayoutConstraint(item: InfoView, attribute: .leading, relatedBy: .equal, toItem: InfoScroll, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoView, attribute: .trailing, relatedBy: .equal, toItem: InfoScroll, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoView, attribute: .top, relatedBy: .equal, toItem: InfoScroll, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoView, attribute: .height, relatedBy: .equal, toItem: InfoScroll, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoView, attribute: .top, relatedBy: .equal, toItem: InfoScroll, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  InfoView, attribute: .width, relatedBy: .equal, toItem: InfoScroll, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        
        if let difficulty = self.json["version"] as? String{
            self.info.append("Version: " + difficulty)
        }
        if let circle_size = self.json["diff_size"] as? String{
            self.info.append("Circle Size: " + circle_size)
        }
        if let diff_drain = self.json["diff_drain"] as? String{
            self.info.append("Drain: " + diff_drain)
        }
        if let diff_overall = self.json["diff_overall"] as? String{
            self.info.append("Accuracy: " + diff_overall)
        }
        if let diff_approach = self.json["diff_approach"] as? String{
            self.info.append("Approach Rate: " + diff_approach)
        }
        
        self.InfoTable.delegate = self
        self.InfoTable.dataSource = self
        self.InfoTable.rowHeight = 64
        self.InfoTable.separatorStyle = .none
        self.InfoTable.register(BeatmapInfoCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        self.InfoTable.translatesAutoresizingMaskIntoConstraints = false
        self.InfoTable.backgroundColor = .clear
        InfoView.addSubview(self.InfoTable)
        NSLayoutConstraint(item: self.InfoTable, attribute: .top, relatedBy: .equal, toItem: InfoView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.InfoTable, attribute: .leading, relatedBy: .equal, toItem: InfoView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  self.InfoTable, attribute: .trailing, relatedBy: .equal, toItem: InfoView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  self.InfoTable, attribute: .bottom, relatedBy: .equal, toItem: InfoView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  self.InfoTable, attribute: .width, relatedBy: .equal, toItem: InfoView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        

        let PageDots = UIPageControl(frame: CGRect(x:168, y:130, width:39, height:37))
        PageDots.numberOfPages = self.pages[1]
        PageDots.currentPage = self.pages[0]
        PageDots.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(PageDots)
        NSLayoutConstraint(item: PageDots, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:  PageDots, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 610).isActive = true
        NSLayoutConstraint(item:  PageDots, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.info.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.InfoTable.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! BeatmapInfoCell
        cell.info.text = self.info[indexPath.row]
        
        
        return cell
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
