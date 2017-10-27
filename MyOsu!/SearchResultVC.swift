//
//  SearchResultVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/26/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController {
    
    var json = [String:Any]()
    
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var globalRank: UILabel!
    @IBOutlet weak var countryRank: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreateProfile()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
