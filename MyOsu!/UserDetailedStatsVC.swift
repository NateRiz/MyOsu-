//
//  UserDetailedStatsVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/27/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import Alamofire

class SongCell : UITableViewCell{
    
    @IBOutlet weak var SongImage: UIImageView!
    @IBOutlet weak var SongName: UILabel!
}



class UserDetailedStatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var songNames = [String]()
    let cellReuseIdentifier = "SongCell"
    let API_URL = "https://osu.ppy.sh/api/"

    @IBOutlet weak var SongTable: UITableView!
    var history = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SongTable.delegate = self
        self.SongTable.dataSource = self
        self.SongTable.rowHeight = 80
        self.PopulateSongNames()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SongCell = self.SongTable.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as! SongCell
        
        cell.SongName.text = self.songNames[indexPath.row]
        
        
        return cell
    }
    
    func PopulateSongNames() {
        for i in 0..<5{
            if let event = self.history[i] as? [String:Any]{
                if let id = event["beatmap_id"] as? String{
                    self.searchBarSearchButtonClicked(beatmap: id, completion: {
                        self.SongTable.beginUpdates()
                        self.SongTable.insertRows(at: [IndexPath(row: self.songNames.count-1, section: 0)], with: .automatic)
                        self.SongTable.endUpdates()
                    }
                    )//img = https://b.ppy.sh/thumb/642845l.jpg
                }
            }
        }
        
    }
    
    func searchBarSearchButtonClicked(beatmap: String, completion: @escaping ()->()) {
        var songName = ""
        Alamofire.request(self.API_URL + "get_beatmaps?" + "&k=374c71b25b90368c6a0f3401983325ff98443313&b="+beatmap).responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                let parsed = (json as! [Any])[0] as! [String:Any]
                if let artist = parsed["artist"] as? String{
                    songName += (artist + " - ")
                }
                if let title = parsed["title"] as? String{
                    songName += (title + " ")
                }
                if let difficult = parsed["version"] as? String{
                    songName += ("[" + difficult + "}")
                }
                
            }
            print(songName)
            self.songNames.append(songName)
            completion()
        }
        

    }


}
