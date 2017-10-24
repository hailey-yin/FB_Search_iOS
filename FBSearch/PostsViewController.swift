//
//  PostsViewController.swift
//  FBSearch
//
//  Created by Hailey Yin on 4/20/17.
//  Copyright © 2017 Hailey Yin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var SelectedItem:JSON = [:]
    
    var url: URL!
    
    @IBOutlet weak var tableView: UITableView!
    
    var PostsArray = JSON({})

    var type: String!
    
    var isFavorite: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var urlstring:String!
        urlstring = "https://graph.facebook.com/v2.8/"+SelectedItem["id"].string!+"?fields=id,name,picture.width(700).height(700),posts.limit(5)&access_token=EAAVKzosa82MBADOXGg6ZCboNZBuVshiJOCxpDTSb2GZC0q8wrX9V2Gfu9YwEHyX5JwRZAvScGySyLglS9ZC3LAgaLSwy0ZCyWglroZBhuNNLGP07laTeTriZAFQcdhC6YatuF7FaYSPXWnSzZArCTKZAXQbvk0kgLdOjQZD"
        let escape = urlstring.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        url = URL(string: escape!)
        getUsersData(url)
    }
    
    func getUsersData(_ url: URL){
        
        Alamofire.request(url).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    self.PostsArray = JSON(value)
                    self.tableView.reloadData()
                }
            case false:
                print(response.result.error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostsArray["posts"]["data"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postcell", for: indexPath) as? PostsTableViewCell

        let url = URL(string:PostsArray["picture"]["data"]["url"].string!)
        let data = try! Data(contentsOf: url!)
        cell?.img.image = UIImage(data: data)
        
        let text = PostsArray["posts"]["data"][indexPath.row]["message"].string
        cell?.message.text = text
        
        let time = PostsArray["posts"]["data"][indexPath.row]["created_time"].string
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name:"UTC")! as TimeZone
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: time!)
        dateFormatter.dateFormat="d MMM yyyy HH:mm:ss"
        let timestamp = dateFormatter.string(from: date!)
        cell?.time.text = timestamp
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if PostsArray["posts"].count>0
        {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine;
            self.tableView.backgroundView = nil
            numOfSections = 1
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data found."
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView  = noDataLabel
            self.tableView.separatorStyle  = .none
        }
        return numOfSections
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
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
