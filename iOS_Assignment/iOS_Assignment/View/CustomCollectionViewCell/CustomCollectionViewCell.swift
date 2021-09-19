//
//  customCollectionViewCell.swift
//  Practice
//
//  Created by leo on 20/9/21.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 4
    }
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
        voteCountLabel.text = ""
    }
    
}
