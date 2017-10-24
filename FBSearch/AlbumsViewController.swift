//
//  AlbumsViewController.swift
//  FBSearch
//
//  Created by Hailey Yin on 4/20/17.
//  Copyright © 2017 Hailey Yin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import EasyToast
import FacebookShare

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var SelectedItem:JSON = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    var AlbumsArray = JSON({})
    
    var url: URL!
    
    var selectedIndex = -1
    
    var type: String!
    
    var isFavorite: Int = 0
    
    var favoriteString:[[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero) // don't show empty cell
        var urlstring:String!
        urlstring = "https://graph.facebook.com/v2.8/"+SelectedItem["id"].string!+"?fields=id,name,picture.width(700).height(700),albums.limit(5){name,photos.limit(2){name,picture}}&access_token=EAAVKzosa82MBADOXGg6ZCboNZBuVshiJOCxpDTSb2GZC0q8wrX9V2Gfu9YwEHyX5JwRZAvScGySyLglS9ZC3LAgaLSwy0ZCyWglroZBhuNNLGP07laTeTriZAFQcdhC6YatuF7FaYSPXWnSzZArCTKZAXQbvk0kgLdOjQZD"
        let escape = urlstring.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        url = URL(string: escape!)
        print(url)
        getUsersData(url)
        getFavorite()
    }
    
    func getUsersData(_ url: URL){
        
        Alamofire.request(url).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    self.AlbumsArray = JSON(value)
                    self.tableView.reloadData()
                }
            case false:
                print(response.result.error)
            }
        }
    }
    
    func getFavorite() {
        if(UserDefaults.standard.array(forKey: type) != nil){
            favoriteString = UserDefaults.standard.array(forKey: type)! as! [[String]]
            
            for s in favoriteString {
                if SelectedItem["id"].string == s[0] {
                    isFavorite = 1
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlbumsArray["albums"]["data"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumcell", for: indexPath) as? AlbumsTableViewCell
        let name = AlbumsArray["albums"]["data"][indexPath.row]["name"].string
        cell?.label.text = name
        if (AlbumsArray["albums"].exists()) {
            if(AlbumsArray["albums"]["data"][indexPath.row]["photos"].exists()) {
                if let url1=URL(string:AlbumsArray["albums"]["data"][indexPath.row]["photos"]["data"][0]["picture"].string!){
                    let data1 = try! Data(contentsOf: url1)
                    cell?.img1.image = UIImage(data: data1)
                }
                if let url2=URL(string:AlbumsArray["albums"]["data"][indexPath.row]["photos"]["data"][1]["picture"].string!){
                    let data2 = try! Data(contentsOf: url2)
                    cell?.img2.image = UIImage(data: data2)
                }
            }
           
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedIndex == indexPath.row){
            return 400
        } else {
            return 50
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if AlbumsArray["albums"].count>0
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndex == indexPath.row){
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Details"
        
        let logButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "options.png"), style: .plain, target: self, action: #selector(others))
        self.tabBarController?.navigationItem.rightBarButtonItem = logButton

    }
    
    func others() {
        let alertController = UIAlertController(title: "", message: "Menu", preferredStyle: .actionSheet)
        var text: String!
        if isFavorite == 0 {
            text = "Add to Favorites"
        } else {
            text = "Remove from Favorites"
        }
        let cancelAction = UIAlertAction(title: text, style: .default, handler: favoriteClicked)
        let deleteAction = UIAlertAction(title: "Share", style: .default, handler: share)
        let archiveAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func favoriteClicked(alert: UIAlertAction) {
        if isFavorite==0 {
            isFavorite = 1
            let item = [SelectedItem["id"].string, SelectedItem["name"].string, SelectedItem["picture"]["data"]["url"].string, type]
            favoriteString.append(item as! [String])
            UserDefaults.standard.set(favoriteString, forKey: type)
            self.view.showToast("Added to favorites!", position: .bottom, popTime: 2, dismissOnTap: true)

        } else {
            isFavorite = 0
            for (index,s) in favoriteString.enumerated() {
                if SelectedItem["id"].string == s[0] {
                    favoriteString.remove(at: index)
                }
            }
            self.view.showToast("Removed from favorites!", position: .bottom, popTime: 2, dismissOnTap: true)
            UserDefaults.standard.set(favoriteString, forKey: type)
        }
    }
    
    func share(alert: UIAlertAction) {
//        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
//        let url = SelectedItem["picture"]["data"]["url"].string!
//        content.contentURL = URL(string: url)
//        content.contentTitle = SelectedItem["name"].string
//        content.contentDescription = "FB Share for CSCI571"
//        content.imageURL = URL(string: url)
//        FBSDKShareDialog.show(from: self, with: content, delegate: self)
        
        let url = SelectedItem["picture"]["data"]["url"].string!
        let name = SelectedItem["name"].string!
        let content = LinkShareContent(url: URL(string: url)!, title:name, description:"FB Share for CSCI571", imageURL: URL(string: url))
        print(content)
        let shareDialog = ShareDialog(content: content)
        
        shareDialog.mode = .feedWeb
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            switch result {
            case .success:
                self.view.showToast("Shared!", position: .bottom, popTime: 2, dismissOnTap: true)
            case .failed:
                self.view.showToast("Shared failed!", position: .bottom, popTime: 2, dismissOnTap: true)
            case .cancelled:
                self.view.showToast("Shared cancelled!", position: .bottom, popTime: 2, dismissOnTap: true)
            }
        }
        do {
            try shareDialog.show()
        } catch {
            print("shareDialog error")
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
