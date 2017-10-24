//
//  EventsResultsViewController.swift
//  FBSearch
//
//  Created by Hailey Yin on 4/19/17.
//  Copyright © 2017 Hailey Yin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class EventsResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var PreviousBtn: UIButton!
    
    @IBOutlet weak var NextBtn: UIButton!
    
    var keyword:String!
    
    var url: URL!

    var EventsArray = JSON({})
    
    var SelectedItem = JSON({})
    
    var favoriteString:[[String]] = []
    
    var currentPageInFavorite: Int = 1
    
    var Favorite:[[String]] = []
    
    @IBAction func previous(_ sender: Any) {
        if keyword != nil {
            url = URL(string:EventsArray["paging"]["previous"].string!)
            getUsersData(url)
        } else {
            currentPageInFavorite -= 1
            getFavorite()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if keyword != nil {
            url = URL(string:EventsArray["paging"]["next"].string!)
            getUsersData(url)
        } else {
            currentPageInFavorite += 1
            getFavorite()
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        tableView.tableFooterView = UIView(frame: .zero) // don't show empty cell
        if keyword != nil {
            url = URL(string:"https://graph.facebook.com/v2.8/search?q="+keyword+"&type=event&fields=id,name,picture.width(700).height(700)&limit=9&access_token=EAAVKzosa82MBADOXGg6ZCboNZBuVshiJOCxpDTSb2GZC0q8wrX9V2Gfu9YwEHyX5JwRZAvScGySyLglS9ZC3LAgaLSwy0ZCyWglroZBhuNNLGP07laTeTriZAFQcdhC6YatuF7FaYSPXWnSzZArCTKZAXQbvk0kgLdOjQZD")
            
            getUsersData(url)
        }
        
        getFavorite()
        
        SwiftSpinner.show(duration: 2.0, title: "Loading Data...")

    }
    
    func getFavorite() {
        if(UserDefaults.standard.array(forKey: "event") != nil){
            Favorite = UserDefaults.standard.array(forKey: "event")! as! [[String]]
            if keyword == nil {
                var start: Int = (currentPageInFavorite-1)*9
                var end: Int = Favorite.count-1
                if start>end {
                    currentPageInFavorite -= 1
                    start = (currentPageInFavorite-1)*9
                }
                if currentPageInFavorite > 1 {
                    self.PreviousBtn.isEnabled = true
                } else {
                    self.PreviousBtn.isEnabled = false
                }
                if start+9 < Favorite.count {
                    end = start+9
                    self.NextBtn.isEnabled = true
                } else {
                    self.NextBtn.isEnabled = false
                    favoriteString = Favorite
                }
                favoriteString = Array(Favorite[start...end])
            } else {
                favoriteString = Favorite
            }        }
    }
    
    func getUsersData(_ url: URL){
        
        Alamofire.request(url).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    self.EventsArray = JSON(value)
                    if self.EventsArray["paging"]["previous"].string != nil {
                        self.PreviousBtn.isEnabled = true
                    } else {
                        self.PreviousBtn.isEnabled = false
                    }
                    if self.EventsArray["paging"]["next"].string != nil {
                        self.NextBtn.isEnabled = true
                    } else {
                        self.NextBtn.isEnabled = false
                    }
                    
                    self.tableView.reloadData()
                }
            case false:
                print(response.result.error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if keyword != nil {
            return EventsArray["data"].count
        } else {
            return favoriteString.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as? CustomTableViewCell
        if keyword != nil {
            let name = EventsArray["data"][indexPath.row]["name"].string
            cell?.name.text = name
            let url = URL(string: EventsArray["data"][indexPath.row]["picture"]["data"]["url"].string!)
            let data = try! Data(contentsOf: url!)
            cell?.img.image = UIImage(data: data)
            cell?.favoriteBtn.setImage(UIImage(named: "empty.png"), for: .normal)
            for s in favoriteString {
                if EventsArray["data"][indexPath.row]["id"].string == s[0] {
                    cell?.favoriteBtn.setImage(UIImage(named: "filled.png"), for: .normal)
                }
            }
        } else {
            let name = favoriteString[indexPath.row][1]
            cell?.name.text = name
            let url = URL(string:favoriteString[indexPath.row][2])
            let data = try! Data(contentsOf: url!)
            cell?.img.image = UIImage(data: data)
            cell?.favoriteBtn.setImage(UIImage(named: "filled.png"), for: .normal)
        }
        
        return cell!
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        if keyword != nil {
            SelectedItem = EventsArray["data"][indexPath.row]
        } else {
            SelectedItem = ["id":favoriteString[indexPath.row][0],"name":favoriteString[indexPath.row][1], "picture":["data":["url":favoriteString[indexPath.row][2]]]]
        }
        performSegue(withIdentifier: "showEventsDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showEventsDetails" && SelectedItem["id"] != nil) {
            let next = (segue.destination as! UITabBarController)
            let AlbumsVC = next.viewControllers![0] as! AlbumsViewController
            AlbumsVC.SelectedItem = SelectedItem
            AlbumsVC.type = "event"
            let PostsVC = next.viewControllers![1] as! PostsViewController
            PostsVC.SelectedItem = SelectedItem
            PostsVC.type = "event"
            
            let leftBarBtn = UIBarButtonItem(title: "Results", style: .plain, target: self, action: #selector(backToPrevious))
            self.tabBarController?.navigationItem.backBarButtonItem = leftBarBtn
            
        }
    }
    
    //返回按钮点击响应
    func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavorite()
        self.tableView.reloadData()
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
