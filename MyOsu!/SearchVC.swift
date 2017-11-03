//
//  SearchVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/26/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import Alamofire

class SearchVC: UIViewController, UISearchBarDelegate{

    let SongTypes = [UIButton()]
    
    
    
    @IBOutlet weak var ButtonStack: UIStackView!
    @IBOutlet weak var RankedButton: CustomButton!
    @IBOutlet weak var QualifiedButton: CustomButton!
    @IBOutlet weak var ApprovedButton: CustomButton!
    @IBOutlet weak var UnrankedButton: CustomButton!
    @IBOutlet weak var LovedButton: CustomButton!
    

    @IBOutlet weak var BeatmapButton: UIButton!
    @IBOutlet weak var UserButton: UIButton!
    @IBOutlet weak var NoResultsLabel: UIView!
    @IBOutlet weak var OsuSearchBar: UISearchBar!
    var selected = ""
    
    
    let API_URL = "https://osu.ppy.sh/api/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OsuSearchBar.delegate = self
        self.UserButton.tintColor = UIColor.yellow
        self.selected="User"
        self.ButtonStack.isHidden = true
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BeatmapSearchButton(_ sender: Any) {
        self.BeatmapButton.tintColor = UIColor.yellow
        self.UserButton.tintColor = UIColor.white
        self.selected = "Beatmap"
        self.ButtonStack.isHidden = false
    }
    @IBAction func UserSearchButton(_ sender: Any) {
        self.UserButton.tintColor = UIColor.yellow
        self.BeatmapButton.tintColor = UIColor.white
        self.selected = "User"
        self.ButtonStack.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if self.selected == "User"{
            if let query = searchBar.text{
                Alamofire.request(self.API_URL + "get_user?" + "&k=374c71b25b90368c6a0f3401983325ff98443313&event_days=31&u="+query).responseJSON { response in
                    if let json = response.result.value {
                        //print("JSON: \(json)") // serialized json response
                        let userPageVC = self.storyboard?.instantiateViewController(withIdentifier: "UserPageControl") as! UserPageVC
                        if let jsonArray = json as? NSArray{
                            if jsonArray.count > 0{
                                if let jsonDict = jsonArray[0] as? [String:Any]{
                                    userPageVC.json = jsonDict
                                    self.NoResultsLabel.isHidden = true
                                    self.present(userPageVC, animated: true, completion: nil)
                                }else{
                                    self.NoResultsLabel.isHidden = false
                                }
                            }else{
                                self.NoResultsLabel.isHidden = false
                            }
                        }else{
                            self.NoResultsLabel.isHidden = false
                        }
                        
                        
                        
                    }else{
                        self.NoResultsLabel.isHidden = false
                    }
                    
                }
            }
        }
        else if self.selected == "Beatmap"{
            let beatmapSearchVC = self.storyboard?.instantiateViewController(withIdentifier: "beatmapSearch") as! BeatmapSearchVC
            if let query = searchBar.text{
                beatmapSearchVC.query = query
                self.present(beatmapSearchVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == UISwipeGestureRecognizerDirection.down{
                self.dismiss(animated: true, completion: nil)
            }
        }
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
