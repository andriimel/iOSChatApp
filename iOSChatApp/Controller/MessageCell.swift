//
//  MessageCell.swift
//  ChatApp
//
//  Created by Andrii Melnyk on 1/16/24.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var messageBubble: UIView!{
        didSet{
            messageBubble.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!{
        didSet{
            rightImageView.layer.masksToBounds = true
            rightImageView.layer.cornerRadius = rightImageView.bounds.height/2
            rightImageView.layer.borderWidth = 3
            rightImageView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var leftImageView: UIImageView! {
        didSet {
            leftImageView.layer.masksToBounds = true
            leftImageView.layer.cornerRadius = leftImageView.bounds.height/2
            leftImageView.layer.borderWidth = 3
            leftImageView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        contentView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: 340,
                                        height: 100)
        
        
    }
    
    static let identifier = "MessageCell"
    static func nib() -> UINib {
        return UINib(nibName: "MessageCell", bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
