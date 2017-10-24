//
//  ViewController.swift
//  FBSearch
//
//  Created by Hailey Yin on 4/17/17.
//  Copyright © 2017 Hailey Yin. All rights reserved.
//

import UIKit
import EasyToast

class ViewController: UIViewController {

    @IBOutlet weak var OpenSideMenu: UIBarButtonItem!
    @IBOutlet weak var SearchText: UITextField!
    
    @IBAction func Clear(_ sender: Any) {
        SearchText.text = ""
    }
    
    @IBAction func Search(_ sender: Any) {
        if(SearchText.text == "") {
            self.view.showToast("Enter a valid query", position: .bottom, popTime: 2, dismissOnTap: true)
        } else {
            self.performSegue(withIdentifier: "search", sender: self)
        }
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "search") {
            let next = (segue.destination as! UITabBarController)
            let UsersVC = next.viewControllers![0] as! UsersResultsViewController
            UsersVC.keyword = SearchText.text
            let PagesVC = next.viewControllers![1] as! PagesResultsViewController
            PagesVC.keyword = SearchText.text
            let EventsVC = next.viewControllers![2] as! EventsResultsViewController
            EventsVC.keyword = SearchText.text
            let PlacesVC = next.viewControllers![3] as! PlacesResultsViewController
            PlacesVC.keyword = SearchText.text
            let GroupsVC = next.viewControllers![4] as! GroupsResultsViewController
            GroupsVC.keyword = SearchText.text
        }
    }
    
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


}

