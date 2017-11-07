//
//  BeatmapSearchVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 11/1/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire

class SongSearchCell: UITableViewCell{
    @IBOutlet weak var SongImage: UIImageView!
    @IBOutlet weak var SongName: UILabel!
    @IBOutlet weak var SongArtist: UILabel!
    @IBOutlet weak var SongDuration: UILabel!
    @IBOutlet weak var SongView: UIView!
}

struct Song{
    var name = ""
    var artist = ""
    var duration = ""
    var id = ""
    var image : UIImage?
    
    init(name:String = "", artist:String = "", duration:String = "", id:String = "")
    {
        self.name = name
        self.artist = artist
        self.duration = duration
        self.id = id
    }
}

class BeatmapSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    
    
    var query = String()
    var statuses = [String]()
    var SearchResults = [Song]()
    @IBOutlet weak var SongTable: UITableView!
    @IBOutlet weak var SongSearchbar: UISearchBar!
    @IBOutlet weak var LoadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrapeSearch()
        SongTable.delegate = self
        SongTable.dataSource = self
        SongTable.rowHeight = 100
        SongSearchbar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SearchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        self.LoadingView.isHidden = false
        self.SongTable.isHidden = true
        
        let beatmapInfo = self.storyboard!.instantiateViewController(withIdentifier: "beatmapInfo") as! BeatmapInfoVC
        
        callAPI(song:SearchResults[indexPath.row], beatmapInfo:beatmapInfo){
            self.present(beatmapInfo, animated: true, completion: nil)
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SongSearchCell = self.SongTable.dequeueReusableCell(withIdentifier: "songSearchCell") as! SongSearchCell
    
        cell.SongName.text = SearchResults[indexPath.row].name
        cell.SongArtist.text = SearchResults[indexPath.row].artist
        cell.SongDuration.text = SearchResults[indexPath.row].duration
        if SearchResults[indexPath.row].image != nil{
            cell.SongImage.image = SearchResults[indexPath.row].image!
        }else{
            self.GetSongImage(id:SearchResults[indexPath.row].id, indexPath:indexPath)
        }
        cell.SongView.layer.cornerRadius = 4
        cell.SongView.layer.masksToBounds = false
        cell.SongView.layer.shadowColor = UIColor.black.cgColor
        cell.SongView.layer.shadowOpacity = 0.5
        cell.SongView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.SongView.layer.shadowRadius = 1
        cell.SongView.layer.shouldRasterize = true
        
        return cell
    }
    
    
    func scrapeSearch()
    {
        let statusQuery = self.statuses.joined(separator:",")
        self.query = self.query.replacingOccurrences(of: " ", with: "+")
        let url = "http://bloodcat.com/osu/?q=" + self.query + "&c=b&s="+statusQuery + "&m="
        do {
            //print(url)
            let html = try String(contentsOf:URL(string: url)!)
            let doc: Document = try SwiftSoup.parse(html)
            
            let body: Element? = doc.body()
            let elems = try body!.getElementsByClass("set")
            
            for elem in elems.array()
            {
                //print(try elem.text())
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
                self.SongTable.insertRows(at: [IndexPath(row: self.SearchResults.count-1, section:0)], with: .automatic)
                self.SongTable.endUpdates()
            }
        }
        catch let error {
            print("Could not fetch news:")
            print(error)
        }
    }
    
    
    func GetSongImage(id:String, indexPath:IndexPath)
    {
        //print(index,"song images now has",self.songImages.count)
        let url = URL(string: "https://b.ppy.sh/thumb/\(id).jpg")!
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let _ = response as? HTTPURLResponse {
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        if let image = UIImage(data: imageData){
                            //print("accessing index",index)
                            DispatchQueue.main.async {
                                self.SearchResults[indexPath.row].image = image
                                self.SongTable.reloadRows(at: [indexPath], with: .automatic)
                            }
                            
                        }
                        
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                        
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    
                }
            }
            }.resume()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text{
            self.query = query
            let group = DispatchGroup()
            DispatchQueue.main.async{
                group.enter()
                print("enter")
                self.SearchResults.removeAll()
                self.SongTable.reloadData()
                print("leave")
                group.leave()
            }
            
            
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            print("starting scrape")
            self.scrapeSearch()
        }))
            
        }
    }
    
    func callAPI(song:Song, beatmapInfo:BeatmapInfoVC, completion: @escaping ()->()) {
        Alamofire.request("https://osu.ppy.sh/api/get_beatmaps?&k=374c71b25b90368c6a0f3401983325ff98443313&s="+song.id).responseJSON { response in
            if let json = response.result.value {
                //print("JSON: \(json)") // serialized json response
                if let JsonList = json as? [[String:Any]]{
                    
                    for i in 0..<JsonList.count{
                        let set = SongVC()
                        set.name = song.name
                        set.image = song.image
                        set.artist = song.artist
                        set.duration = song.duration
                        set.id = song.id
                        set.pages = [i,JsonList.count]
                        set.json = JsonList[i]
                        beatmapInfo.SongViews.append(set)
                        
                    }
                    
                    
                }
                
            }

            return completion()
        }
        
    }

    @IBAction func CloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
