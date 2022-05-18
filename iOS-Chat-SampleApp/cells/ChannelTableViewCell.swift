//
//  ChannelTableViewCell.swift
//  iOS-Chat-SampleApp
//
//  Created by Mark on 18/5/2565 BE.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var displayName: UILabel!
       @IBOutlet weak var timeLabel: UILabel!
       @IBOutlet weak var avatar: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.backgroundColor = UIColor.lightGray
        avatar.layer.cornerRadius = avatar.frame.size.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
