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

class NewsCell : UITableViewCell{
    
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
}

class MainVC: UIViewController , FrostedSidebarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    
    
    let imageArray = [UIImage(named:"search.png")!]
    let colorArray = [UIColor.white]
    var frostedSidebar: FrostedSidebar!
    var TitleLabels = [String]()
    var NewsLabels = [String]()
    var NewsLinks = [String]()
    var cellReuseIdentifier = "newsCell"
    
    
    @IBOutlet weak var NewsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetOsuNews()
        self.frostedSidebar = FrostedSidebar(itemImages: self.imageArray, colors: self.colorArray, selectionStyle: .all)
        self.frostedSidebar.delegate = self
        self.NewsTable.delegate = self
        self.NewsTable.dataSource = self
        self.NewsTable.rowHeight = 100
        
        
        
        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.NewsLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsCell = self.NewsTable.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as! NewsCell
        cell.titleLabel.text = self.TitleLabels[indexPath.row]
        cell.newsLabel.text = self.NewsLabels[indexPath.row]
        cell.alpha = 0
        
        cell.newsView.layer.masksToBounds = false
        cell.newsView.layer.shadowColor = UIColor.black.cgColor
        cell.newsView.layer.shadowOpacity = 0.5
        cell.newsView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.newsView.layer.shadowRadius = 1
        cell.newsView.layer.shouldRasterize = true

        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(self.NewsLinks[indexPath.row])
        let url = URL(string: self.NewsLinks[indexPath.row])!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didEnable itemEnabled: Bool, itemAtIndex index: Int) {
        
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
    
    
    
    
    
    
    
    
}

