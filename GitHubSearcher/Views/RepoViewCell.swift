//
//  RepoViewCell.swift
//  GitHubSearcher
//
//  Created by Rakesh Neela on 12/25/19.
//  Copyright © 2019 Rakesh Neela. All rights reserved.
//

import UIKit

class RepoViewCell: UITableViewCell {

    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoForkCount: UILabel!
    @IBOutlet weak var repoStarCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
