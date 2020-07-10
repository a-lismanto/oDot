//
//  HeroCell.swift
//  oDot
//
//  Created by Andrew on 09/07/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import UIKit
import SDWebImage

class HeroCell: UITableViewCell {
    
    @IBOutlet weak var heroImageView: UIImageView?
    @IBOutlet weak var heroTitleLabel: UILabel?
    @IBOutlet weak var heroSubtitleLabel: UILabel?
    
    var hero: Hero?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        self.heroTitleLabel?.text = hero?.localized_name
        self.heroSubtitleLabel?.text = hero?.roles
        let imageUrl = UrlUtils.buildAvatarImageUrl(avatarUrlPiece: hero?.img ?? "")
        self.heroImageView?.sd_setImage(with: imageUrl, completed: nil)
    }
    
}
