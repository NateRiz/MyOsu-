//
//  BeatmapInfoVC.swift
//  MyOsu!
//
//  Created by Robert Wei on 11/3/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import Alamofire

class BeatmapInfoVC: UIViewController {
    var name = String()
    var artist = String()
    var duration = String()
    var id = String()
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callAPI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callAPI(){
        print(self.id)
        Alamofire.request("https://osu.ppy.sh/api/get_beatmaps?&k=374c71b25b90368c6a0f3401983325ff98443313&s="+self.id).responseJSON { response in
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
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
