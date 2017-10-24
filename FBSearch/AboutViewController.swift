//
//  AboutViewController.swift
//  FBSearch
//
//  Created by Hailey Yin on 4/18/17.
//  Copyright © 2017 Hailey Yin. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var OpenSideMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        OpenSideMenu.target = self.revealViewController()
        OpenSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
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

}
