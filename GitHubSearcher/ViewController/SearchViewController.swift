//
//  SearchViewController.swift
//  GitHubSearcher
//
//  Created by Rakesh Neela on 12/24/19.
//  Copyright © 2019 Rakesh Neela. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var userListView: UITableView!
    var userInformation: [UserDetails] = [UserDetails]()
    var searchActive : Bool = false
    var filtered:[String] = []
    
    public struct UserDetails {
        public var userName: String
        public var numberOfRepos: Int
        public var imageURL: String
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
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
    
    func getUserDetails(){
        do {
            if let file = Bundle.main.url(forResource: "userInformation", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [Any] {
                    for obj in object {
                        var details = obj as? [String: Any]
                        let objDetail = UserDetails(userName: details?["name"] as! String, numberOfRepos: details?["public_repos"] as! Int , imageURL: details?["avatar_url"] as! String)
                        print(objDetail)
                        self.userInformation.append(objDetail)
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
           
//            let url = URL(string: "https://api.github.com/users/octocat")!
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: request) {
//
//                (data, response, error) in
//                if let data = data {
//                    if let postResponse = String(data: data, encoding: .utf8) {
//                       // let json = try JSONSerialization.jsonObject(with: postResponse, options: [])
//                        print(postResponse)
//                    }
//                }
//            }
//            task.resume()
        } catch {
            print(error.localizedDescription)
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
//        for i in 0..<userInformation.count {
//            data[i] = userInformation[i].userName
//        }
//        filtered = data.filter({ (text) -> Bool in
//            let tmp: String = text as String
//            let range = tmp.rangeOfString(searchText, options: NSString.CompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    



}

