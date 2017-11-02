//
//  BeatmapSearchVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 11/1/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import SwiftSoup

class BeatmapSearchVC: UIViewController {
    
    var query = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrapeSearch()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrapeSearch()
    {
        self.query = "The quick brown fox"
        self.query = self.query.replacingOccurrences(of: " ", with: "+")
        let url = "http://bloodcat.com/osu/?q=" + self.query
        do {
            print(url)
            let html = try String(contentsOf:URL(string: url)!)
            let doc: Document = try SwiftSoup.parse(html)
            
            let body: Element? = doc.body()
            let elems = try body!.getElementsByClass("set")
            
            for elem in elems.array()
            {
                print(try elem.text())
            }
        }
        catch let error {
            print("Could not fetch news:")
            print(error)
        }
    }
    
    
}
