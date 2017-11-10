//
//  UserDetailedStatsVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/27/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire

class SongCell : UITableViewCell{
    
    @IBOutlet weak var SongImage: UIImageView!
    @IBOutlet weak var SongName: UILabel!
}



class UserDetailedStatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var songNames = [String]()
    var songImages = [UIImage]()
    let cellReuseIdentifier = "SongCell"
    let API_URL = "https://osu.ppy.sh/api/"

    @IBOutlet weak var NoHistoryLabel: UIView!
    @IBOutlet weak var SongTable: UITableView!
    
    var history = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.history)
        self.SongTable.delegate = self
        self.SongTable.dataSource = self
        self.SongTable.allowsSelection = false
        self.SongTable.rowHeight = 80
        if self.history.count > 0{
            self.NoHistoryLabel.isHidden = true
            self.SongTable.isHidden = false
            self.PopulateSongNames()
            

        }else{
            self.NoHistoryLabel.isHidden = false
            self.SongTable.isHidden = true
        }
        

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
        cell.SongImage.image = self.songImages[indexPath.row]
        
        return cell
    }
    
    func ParseUserHistory(h:[String:Any]){
        do{
            if let html = h["display_html"] as? String{
                let doc: Document = try SwiftSoup.parse(html)
                self.songNames.append(try doc.text())
                
            }
        }catch let error {
            print("Could not fetch user history html:")
            print(error)
        }
    }
    
    func PopulateSongNames() {
        let group = DispatchGroup()
        for i in 0 ..< self.history.count{
            group.enter()
            self.ParseUserHistory(h:(self.history[i] as! [String:Any]))
            self.songImages.append(UIImage())
            if let event = self.history[i] as? [String:Any]{
                self.getAvatar(index: i, id:(event["beatmapset_id"] as! String))
                self.SongTable.beginUpdates()
                self.SongTable.insertRows(at: [IndexPath(row: self.songNames.count-1, section: 0)], with: .automatic)
                self.SongTable.endUpdates()
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            DispatchQueue.main.async {
                self.SongTable.reloadData()
            }
        }))

        
    }
    
    func getAvatar(index: Int, id: String)
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
                            self.songImages[index] = image
                            if index % 5 == 0{
                                DispatchQueue.main.async {
                                    self.SongTable.reloadData()
                                }
                                
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
    
}
