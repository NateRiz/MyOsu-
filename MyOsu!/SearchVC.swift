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

    
    
    @IBOutlet weak var NoResultsLabel: UIView!
    @IBOutlet weak var OsuSearchBar: UISearchBar!
    
    
    let API_URL = "https://osu.ppy.sh/api/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OsuSearchBar.delegate = self
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
