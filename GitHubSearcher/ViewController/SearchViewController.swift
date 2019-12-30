//
//  SearchViewController.swift
//  GitHubSearcher
//
//  Created by Rakesh Neela on 12/24/19.
//  Copyright © 2019 Rakesh Neela. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import OAuthSwift
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var userListView: UITableView!
    var userInformation: [UserDetails] = [UserDetails]()
    var searchActive : Bool = false
    var filtered:[String] = []
    var totalUserIds: [String] = []
    
    public struct UserDetails {
        public var userName: String
        public var numberOfRepos: Int
        public var imageURL: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListOfUsers()
        customizeUI()
        userSearchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        customizeUI()
    }
    
    func customizeUI() {
        self.title = "GitHub Searcher"
        self.navigationController?.navigationBar.titleTextAttributes?.updateValue(UIFont.systemFont(ofSize: 20.0), forKey: NSAttributedString.Key.font)
    }
    
    
    func getListOfUsers() {
        let todoEndpoint: String = "https://api.github.com/users?client_id=0672968a79a44ead81d0&client_secret=39e627f2d0e910d6f7bbcc60b1c4cd7417eea96a"
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                guard let json = response.result.value as? [[String: Any]] else {
                    print("didn't get object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                for i in 0..<json.count {
                    self.totalUserIds.append(json[i]["login"] as! String)
                }
                self.processUserDetails()
        }
    }
    
    func processUserDetails() {
        for i in 0..<totalUserIds.count {
            let todoEndpoint: String = "https://api.github.com/users/\(totalUserIds[i])?client_id=0672968a79a44ead81d0&client_secret=39e627f2d0e910d6f7bbcc60b1c4cd7417eea96a"
            Alamofire.request(todoEndpoint)
                .responseJSON { response in
                    // check for errors
                    guard response.result.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("error calling GET on /todos/1")
                        print(response.result.error!)
                        return
                    }
                    
                    guard let json = response.result.value as? [String: Any] else {
                        print("didn't get user details as JSON from API")
                        if let error = response.result.error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    
                    guard let userName = json["name"] as? String else {
                        print("Could not get name from JSON")
                        return
                    }
                    guard let numberOfRepos = json["public_repos"] as? Int else {
                        print("Could not get numberOfReps from JSON")
                        return
                    }
                    guard let imageURL = json["avatar_url"] as? String else {
                        print("Could not get Avatar URL from JSON")
                        return
                    }
                    let objDetail = UserDetails(userName: userName, numberOfRepos: numberOfRepos, imageURL: imageURL)
                    self.userInformation.append(objDetail)
                    self.userListView.reloadData()
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        var data: [String]
        //        for i in 0..<totalUserIds.count {
        //            data[i] = totalUserIds[i]
        //        }
        //        filtered = data.filter({ (text) -> Bool in
        //        let tmp: String = text as String
        //        let range = tmp.rangeOfString(searchText, options: NSString.CompareOptions.CaseInsensitiveSearch)
        //                    return range.location != NSNotFound
        //        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.userListView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let view = segue.destination as? UserDetailedViewController
        guard view != nil else { return }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < userInformation.count {
            let cell = userListView.dequeueReusableCell(withIdentifier: "userSearchCell") as! SearchViewCell
            cell.userName?.text = userInformation[indexPath.row].userName
            cell.repoNumberLabel?.text = String(userInformation[indexPath.row].numberOfRepos)
            
            let url = URL(string: userInformation[indexPath.row].imageURL)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    cell.userImage.image = image
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UserDetailVC") as? UserDetailedViewController else { return }
        vc.defaultSelectedUser = totalUserIds[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


