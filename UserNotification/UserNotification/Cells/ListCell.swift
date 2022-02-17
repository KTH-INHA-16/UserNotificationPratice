//
//  ListCell.swift
//  UserNotification
//
//  Created by Nick on 2022/02/17.
//

import UIKit

class ListCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentLabel.adjustsFontSizeToFitWidth = true
        contentLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(value: UserRequest) {
        contentLabel.text = value.title
        timeLabel.text = value.time
    }
}
