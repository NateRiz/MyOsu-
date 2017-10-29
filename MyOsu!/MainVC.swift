//
//  MainVCViewController.swift
//  MyOsu!
//
//  Created by Robert Wei on 10/29/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit
import FrostedSidebar

class MainVC: UIViewController , FrostedSidebarDelegate{
    
    
    let imageArray = [UIImage(named:"search.png")!]
    let colorArray = [UIColor.white]
    var frostedSidebar: FrostedSidebar!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frostedSidebar = FrostedSidebar(itemImages: self.imageArray, colors: self.colorArray, selectionStyle: .all)
        self.frostedSidebar.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func MenuButtonPress(_ sender: Any) {
        self.frostedSidebar.showInViewController( self, animated: true )
    }
    
    func sidebar(_ sidebar: FrostedSidebar, willShowOnScreenAnimated animated: Bool) {
        print(1)
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didShowOnScreenAnimated animated: Bool) {
        print(2)
    }
    
    func sidebar(_ sidebar: FrostedSidebar, willDismissFromScreenAnimated animated: Bool) {
        print(3)
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didDismissFromScreenAnimated animated: Bool) {
        print(4)
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didTapItemAtIndex index: Int) {
        if index == 0{
            let searchView = self.storyboard!.instantiateViewController(withIdentifier: "searchView") as! SearchVC
            self.present(searchView, animated:true, completion:nil)
            
        
        }
        
    }
    
    func sidebar(_ sidebar: FrostedSidebar, didEnable itemEnabled: Bool, itemAtIndex index: Int) {
        print(6)
    }
    
}

