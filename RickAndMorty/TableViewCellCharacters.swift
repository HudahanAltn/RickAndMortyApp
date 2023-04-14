//
//  TableViewCellCharacters.swift
//  RickAndMorty
//
//  Created by Hüdahan Altun on 14.04.2023.
//

import UIKit

class TableViewCellCharacters: UITableViewCell {

    
    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var characterLabel: UILabel!

    @IBOutlet weak var genderIconImage: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .black
        characterLabel.textColor = UIColor(rgb:0xb2dae4)//rickblue
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
