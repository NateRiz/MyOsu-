//
//  BeatmapSearchVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 11/1/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import SwiftSoup

class SongSearchCell: UITableViewCell{
    @IBOutlet weak var SongImage: UIImageView!
    @IBOutlet weak var SongName: UILabel!
    @IBOutlet weak var SongArtist: UILabel!
    @IBOutlet weak var SongDuration: UILabel!
}

struct Song{
    var name = ""
    var artist = ""
    var duration = ""
    var id = ""
    var image = UIImage()
    
    init(name:String = "", artist:String = "", duration:String = "", id:String = "")
    {
        self.name = name
        self.artist = artist
        self.duration = duration
        self.id = id
    }
}

class BeatmapSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    
    var query = String()
    var statuses = [String]()
    var SearchResults = [Song]()
    @IBOutlet weak var SongTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrapeSearch()
        SongTable.delegate = self
        SongTable.dataSource = self
        SongTable.rowHeight = 100
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SongSearchCell = self.SongTable.dequeueReusableCell(withIdentifier: "songSearchCell") as! SongSearchCell
        cell.SongName.text = SearchResults[indexPath.row].name
        cell.SongArtist.text = SearchResults[indexPath.row].artist
        cell.SongDuration.text = SearchResults[indexPath.row].duration
        cell.SongImage.image = SearchResults[indexPath.row].image
        
        
        return cell
    }
    
    
    func scrapeSearch()
    {
        self.query = "The quick brown fox"
        self.statuses = ["1","2","4"]
        let statusQuery = self.statuses.joined(separator:",")
        self.query = self.query.replacingOccurrences(of: " ", with: "+")
        let url = "http://bloodcat.com/osu/?q=" + self.query + "&c=b&s="+statusQuery + "&m="
        do {
            print(url)
            let html = try String(contentsOf:URL(string: url)!)
            let doc: Document = try SwiftSoup.parse(html)
            
            let body: Element? = doc.body()
            let elems = try body!.getElementsByClass("set")
            
            for elem in elems.array()
            {
                print(try elem.text())
                let text:[String] = try elem.text().components(separatedBy: " ")
                let id = text[0]
                var name = ""
                var itr = 1
                while text[itr] != "-"{
                    name+=text[itr] + " "
                    itr+=1
                }
                itr+=1
                var artist = ""
                while (Array(text[itr])[0]) != "["{
                    artist += text[itr] + " "
                    itr+=1
                }
                let duration = text[itr]
                self.SongTable.beginUpdates()
                SearchResults.append(Song(name:name, artist:artist, duration:duration, id:id))
                self.SongTable.endUpdates()
            }
        }
        catch let error {
            print("Could not fetch news:")
            print(error)
        }
    }
    
    
    
    
}
