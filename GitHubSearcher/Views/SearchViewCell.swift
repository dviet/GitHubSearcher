//
//  SearchViewCell.swift
//  GitHubSearcher
//
//  Created by Rakesh Neela on 12/24/19.
//  Copyright © 2019 Rakesh Neela. All rights reserved.
//

import UIKit

class SearchViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var repoNumberLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
