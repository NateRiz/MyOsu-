//
//  MainVCViewController.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/29/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import FrostedSidebar
import SwiftSoup
import Alamofire

class NewsCell : UITableViewCell{
    
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
}
class RedditCell : UITableViewCell{
    
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
}

class MainVC: UIViewController , FrostedSidebarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    
    let imageArray = [UIImage(named:"search.png")!]
    let colorArray = [UIColor.white]
    var frostedSidebar: FrostedSidebar!
    var TitleLabels = [String]()
    var NewsLabels = [String]()
    var NewsLinks = [String]()
    let cellReuseIdentifier = "newsCell"
    var RedditTitles = [String]()
    var RedditNews = [String]()
    var RedditLinks = [String]()
    var RedditColors = [UIColor]()
    let redditCellIdentifier = "redditCell"
    
    
    @IBOutlet weak var NewsTable: UITableView!
    @IBOutlet weak var RedditTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetOsuNews()
        self.GetRedditNews()
        self.frostedSidebar = FrostedSidebar(itemImages: self.imageArray, colors: self.colorArray, selectionStyle: .all)
        self.frostedSidebar.delegate = self
        self.NewsTable.delegate = self
        self.NewsTable.dataSource = self
        self.NewsTable.rowHeight = 100
        self.RedditTable.delegate = self
        self.RedditTable.dataSource = self
        self.RedditTable.rowHeight = 100
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MenuButtonPress(_ sender: Any) {
        self.frostedSidebar.showInViewController( self, animated: true )
    }
    
    
    func sidebar(_ sidebar: FrostedSidebar, willShowOnScreenAnimated animated: Bool) {
        
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didShowOnScreenAnimated animated: Bool) {
        
    }
    
    func sidebar(_ sidebar: FrostedSidebar, willDismissFromScreenAnimated animated: Bool) {
        
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didDismissFromScreenAnimated animated: Bool) {
        
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didTapItemAtIndex index: Int) {
        if index == 0{
            let searchView = self.storyboard!.instantiateViewController(withIdentifier: "searchView") as! SearchVC
            self.present(searchView, animated:true, completion:nil)
            
        
        }
        
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didEnable itemEnabled: Bool, itemAtIndex index: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.NewsTable
        {
            return self.NewsLabels.count
        }
        else if tableView == self.RedditTable
        {
            return self.RedditTitles.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if tableView == self.NewsTable
        {
            let cell: NewsCell = self.NewsTable.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as! NewsCell
            cell.titleLabel.text = self.TitleLabels[indexPath.row]
            cell.newsLabel.text = self.NewsLabels[indexPath.row]
            
            cell.newsView.layer.masksToBounds = false
            cell.newsView.layer.shadowColor = UIColor.black.cgColor
            cell.newsView.layer.shadowOpacity = 0.5
            cell.newsView.layer.shadowOffset = CGSize(width: -1, height: 1)
            cell.newsView.layer.shadowRadius = 1
            cell.newsView.layer.shouldRasterize = true
            return cell
            
        }
        else if tableView == self.RedditTable
        {
            let cell: RedditCell = self.RedditTable.dequeueReusableCell(withIdentifier: self.redditCellIdentifier) as! RedditCell
            cell.titleLabel.text = self.RedditTitles[indexPath.row]
            
            cell.newsView.backgroundColor = self.RedditColors[indexPath.row]
            cell.newsView.layer.masksToBounds = false
            cell.newsView.layer.shadowColor = UIColor.black.cgColor
            cell.newsView.layer.shadowOpacity = 0.5
            cell.newsView.layer.shadowOffset = CGSize(width: -1, height: 1)
            cell.newsView.layer.shadowRadius = 1
            cell.newsView.layer.shouldRasterize = true
            return cell
            
        }
        print("Error: returning empty cell")
        return cell

        
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView == self.NewsTable
        {
            let url = URL(string: self.NewsLinks[indexPath.row])!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        else if tableView == self.RedditTable
        {
            let url = URL(string: self.RedditLinks[indexPath.row])!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    

    
    
    func GetOsuNews(){
        do {
            let html = try String(contentsOf:URL(string: "https://osu.ppy.sh/")!)
            let doc: Document = try SwiftSoup.parse(html)
            let body: Element? = doc.body()
            let elems = try body!.getElementsByClass("news-heading")
            for i in elems.array(){
                let titles: Elements = try i.select("b")
                self.TitleLabels.append(try titles.first()!.text())
                
                let linkA: Element = try! i.select("a").first()!
                let link: String = try! linkA.attr("href")
                
                self.NewsLinks.append(link)
            }

            let newsElems = try body!.getElementsByClass("news-text")
            for i in newsElems.array(){
                self.NewsLabels.append(try i.text())
            }
        }
        catch let error {
            print("Could not fetch news:")
            print(error)
        }
    }
    
    
    func GetRedditNews()
    {
        
        let url = URL(string: "https://www.reddit.com/r/osugame/.json")!
        Alamofire.request(url).responseJSON { response in
        if let json = response.result.value {
            //print("JSON: \(json)") // serialized json response
            if let jsonArray = json as? [String:Any]{
                if let data = jsonArray["data"] as? [String:Any]{
                    if let children = data["children"] as? NSArray{
                        
                        DispatchQueue.main.async {
                            self.RedditTable.beginUpdates()
                            for i in 0 ..< children.count{
                                if let child = children[i] as? [String:Any]{
                                    if let childData = child["data"] as? [String:Any]{
                                        if let title = childData["title"] as? String{
                                                self.RedditTitles.append(title)
                                                self.RedditColors.append(UIColor.white)
                                            
                                            }
                                        if let stickied = childData["stickied"] as? Bool{
                                            if stickied{
                                                self.RedditColors[(self.RedditColors.count - 1)] = UIColor(displayP3Red: 226/255, green: 247/255, blue: 227/255, alpha: 1.0)
                                            }
                                        }
                                        if let url = childData["url"] as? String{
                                            self.RedditLinks.append(url)
                                        }
                                        
                                         self.RedditTable.insertRows(at: [IndexPath(row: self.RedditTitles.count-1, section: 0)], with: .automatic)
                                        }
                                    }
                                
                                }
                            self.RedditTable.endUpdates()
                            
                        }
                        
                        
                    }
                    
                }
            }
        }
        
        }
        
    }
    
    
    
    
    
    
    
}

