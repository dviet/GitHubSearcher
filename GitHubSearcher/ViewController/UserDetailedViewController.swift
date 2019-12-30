//
//  UserDetailedViewController.swift
//  GitHubSearcher
//
//  Created by Rakesh Neela on 12/25/19.
//  Copyright © 2019 Rakesh Neela. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import OAuthSwift

class UserDetailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userJoinDate: UILabel!
    @IBOutlet weak var userFollowings: UILabel!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var repoSearchBar: UISearchBar!
    @IBOutlet weak var repoListView: UITableView!
    
    var repoInformation: [RepoDetails] = [RepoDetails]()
    var defaultSelectedUser: String = ""
    
    public struct UserDetails {
        public var userName: String
        public var userEmail: String
        public var userLocation: String
        public var userJoinDate: String
        public var userFollowers: String
        public var userFollowing: String
        public var imageURL: String
        public var userDescription: String
    }
    
    public struct RepoDetails {
        public var name: String
        public var forkCount: Int
        public var starCount: Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        getUserDetails()
        getRepoDetails()
    }
    
    func customizeUI() {
        self.title = "GitHub Searcher"
        self.navigationController?.navigationBar.titleTextAttributes?.updateValue(UIFont.systemFont(ofSize: 20.0), forKey: NSAttributedString.Key.font)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    
    //    func getUserDetails(){
    //        do {
    //            if let file = Bundle.main.url(forResource: "userInformation", withExtension: "json") {
    //                let data = try Data(contentsOf: file)
    //                let json = try JSONSerialization.jsonObject(with: data, options: [])
    //                if let object = json as? [Any] {
    //                    for obj in object {
    //                        var details = obj as? [String: Any]
    //                        userName.text =  details?["name"] as? String
    //                        userEmail.text = "rakeshneela@outlook.com"//details?["email"] as? String
    //                        userLocation.text = details?["location"] as? String
    //                        userJoinDate.text = details?["created_at"] as? String
    //                        //                        var num = details?["following"] as? Int
    //                        if let num = details?["following"] as? Int {
    //                            userFollowings.text =  "\(String(describing: num)) Following"
    //                        }
    //                        if let num = details?["followers"] as? Int {
    //                            userFollowers.text =  "\(String(describing: num)) Followers"
    //                        }
    //                        let url = URL(string: details?["avatar_url"] as! String)
    //                        DispatchQueue.global().async {
    //                            let data = try? Data(contentsOf: url!)
    //                            DispatchQueue.main.async {
    //                                let image = UIImage(data: data!)
    //                                self.userImage.image = image
    //                            }
    //                        }
    //                        userDescription.text = "This is Rakesh executing program" //details?["bio"] as? String
    //                    }
    //                } else {
    //                    print("JSON is invalid")
    //                }
    //            } else {
    //                print("no file")
    //            }
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //    }
    
    //    func getRepoDetails(){
    //        do {
    //            if let file = Bundle.main.url(forResource: "userRepos", withExtension: "json") {
    //                let data = try Data(contentsOf: file)
    //                let json = try JSONSerialization.jsonObject(with: data, options: [])
    //                if let object = json as? [Any] {
    //                    for obj in object {
    //                        var details = obj as? [String: Any]
    //                        let objDetail = RepoDetails(name: details?["name"] as! String,
    //                                                    forkCount: details?["forks_count"] as! Int,
    //                                                    starCount: details?["open_issues"] as! Int)
    //                        print(objDetail)
    //                        self.repoInformation.append(objDetail)
    //                    }
    //                } else {
    //                    print("JSON is invalid")
    //                }
    //            } else {
    //                print("no file")
    //            }
    //        } catch {
    //            print(error.localizedDescription)
    //        }
    //    }
    
    func getUserDetails() {
        let todoEndpoint: String = "https://api.github.com/users/\(defaultSelectedUser)?client_id=0672968a79a44ead81d0&client_secret=39e627f2d0e910d6f7bbcc60b1c4cd7417eea96a"
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                guard let details = response.result.value as? [String: Any] else {
                    print("didn't get user details as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                self.userName.text =  details["name"] as? String
                self.userEmail.text = details["email"] as? String
                self.userLocation.text = details["location"] as? String
                self.userJoinDate.text = details["created_at"] as? String
                if let num = details["following"] as? Int {
                    self.userFollowings.text =  "\(String(describing: num)) Following"
                }
                if let num = details["followers"] as? Int {
                    self.userFollowers.text =  "\(String(describing: num)) Followers"
                }
                let url = URL(string: details["avatar_url"] as! String)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        self.userImage.image = image
                    }
                }
                self.userDescription.text = details["bio"] as? String
        }
    }
    
    
    func getRepoDetails(){
        let todoEndpoint: String = "https://api.github.com/users/\(defaultSelectedUser)/repos?client_id=0672968a79a44ead81d0&client_secret=39e627f2d0e910d6f7bbcc60b1c4cd7417eea96a"
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /repos/1")
                    print(response.result.error!)
                    return
                }
                
                guard let json = response.result.value as? [[String: Any]] else {
                    print("didn't get repo details as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                for i in 0..<json.count {
                    let objDetail = RepoDetails(name: json[i]["name"] as! String,
                                                forkCount: json[i]["forks_count"] as! Int,
                                                starCount: json[i]["stargazers_count"] as! Int)
                    self.repoInformation.append(objDetail)
                }
                self.repoListView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < repoInformation.count {
            let cell = repoListView.dequeueReusableCell(withIdentifier: "repoInfoCell") as! RepoViewCell
            cell.repoName?.text = repoInformation[indexPath.row].name
            cell.repoForkCount?.text = "\(String(repoInformation[indexPath.row].forkCount)) Forks"
            cell.repoStarCount?.text = "\(String(repoInformation[indexPath.row].starCount)) Stars"
            return cell
        }
        return UITableViewCell()
    }
    
    
}
