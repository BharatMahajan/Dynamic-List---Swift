//
//  ListTableViewCell.swift
//  REST-List
//
//  Created by Er. Bharat Mahajan on 07/11/17.
//  Copyright © 2017 Er. Bharat Mahajan. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPostImage: UIImageView!
    @IBOutlet weak var lblPostTitle: UILabel!
    @IBOutlet weak var lblPostDescription: UITextView!
    @IBOutlet weak var lblPostPublishDate: UILabel!
    @IBOutlet weak var imgActivityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
