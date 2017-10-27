//
//  SearchResultVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/26/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit

class StatsCell: UITableViewCell{
    
    @IBOutlet weak var StatLabel: UILabel!
    @IBOutlet weak var InfoLabel: UILabel!
    
}

class SearchResultVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    let statNames = ["Ranked Stats", "Hit Accuracy", "Play Count", "Total Score", "Current Level"]
    var userStats = [String]()
    let cellReuseIdentifier = "DSCell"
    
    
    var json = [String:Any]()
    
    @IBOutlet weak var DetailStatsTable: UITableView!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var globalRank: UILabel!
    @IBOutlet weak var countryRank: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreateProfile()
        self.DetailStatsTable.delegate = self
        self.DetailStatsTable.dataSource = self
        self.PopulateUserStats()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func CreateProfile()
    {
        if let name = self.json["username"] as? String{
            if let level = self.json["level"] as? String{
                DispatchQueue.main.async {
                    self.username.text = name + " | " + String(Int(Float(level)!))
                }
            }
        }
        guard let country = self.json["country"] as? String else{return}
        if let rank = self.json["pp_rank"] as? String{
            if let cRank = self.json["pp_country_rank"] as? String{
                DispatchQueue.main.async {
                    self.globalRank.text = "Global: " + rank
                    self.countryRank.text = country + ": " + cRank
                }
                
            }
        }
        self.getAvatar()

    }
    
    func getAvatar()
    {
        let url = URL(string: "https://a.ppy.sh/"+(self.json["user_id"] as! String))!
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
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.avatar.image = image
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:StatsCell = self.DetailStatsTable.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as! StatsCell
        
        cell.StatLabel.text = self.statNames[indexPath.row]
        cell.InfoLabel.text = self.userStats[indexPath.row]
        cell.alpha = 0
        
        return cell
    }
    
    func PopulateUserStats(){
        guard let ranked_score = self.json["ranked_score"] as? String else {return}
        guard let accuracy = self.json["accuracy"] as? String else {return}
        guard let playcount = self.json["playcount"] as? String else {return}
        guard let total_score = self.json["total_score"] as? String else {return}
        guard let level = self.json["level"] as? String else {return}
        self.userStats.append(ranked_score)
        self.userStats.append(accuracy)
        self.userStats.append(playcount)
        self.userStats.append(total_score)
        self.userStats.append(String(Int(Float(level)!)))
    }

}
