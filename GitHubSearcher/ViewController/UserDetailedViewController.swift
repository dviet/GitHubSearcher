//
//  UserDetailedViewController.swift
//  GitHubSearcher
//
//  Created by Rakesh Neela on 12/25/19.
//  Copyright © 2019 Rakesh Neela. All rights reserved.
//

import UIKit

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
    
    
    func getUserDetails(){
        do {
            if let file = Bundle.main.url(forResource: "userInformation", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [Any] {
                    for obj in object {
                        var details = obj as? [String: Any]
                        userName.text =  details?["name"] as? String
                        userEmail.text = "rakeshneela@outlook.com"//details?["email"] as? String
                        userLocation.text = details?["location"] as? String
                        userJoinDate.text = details?["created_at"] as? String
                        //                        var num = details?["following"] as? Int
                        if let num = details?["following"] as? Int {
                            userFollowings.text =  "\(String(describing: num)) Following"
                        }
                        if let num = details?["followers"] as? Int {
                            userFollowers.text =  "\(String(describing: num)) Followers"
                        }
                        let url = URL(string: details?["avatar_url"] as! String)
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: url!)
                            DispatchQueue.main.async {
                                let image = UIImage(data: data!)
                                self.userImage.image = image
                            }
                        }
                        userDescription.text = "This is Rakesh executing program" //details?["bio"] as? String
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getRepoDetails(){
        do {
            if let file = Bundle.main.url(forResource: "userRepos", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [Any] {
                    for obj in object {
                        var details = obj as? [String: Any]
                        let objDetail = RepoDetails(name: details?["name"] as! String,
                                                    forkCount: details?["forks_count"] as! Int,
                                                    starCount: details?["open_issues"] as! Int)
                        print(objDetail)
                        self.repoInformation.append(objDetail)
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
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
