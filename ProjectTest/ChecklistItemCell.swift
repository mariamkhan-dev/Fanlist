//
//  ChecklistItemCell.swift
//  ProjectTest
//
//  Created by mk on 4/24/21.
//

import UIKit

class ChecklistItemCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: - Helper Method
    func configure(for checklistitem: ChecklistItem) {
        // potential issue bc i was forced in to using a !
        if checklistitem.checklistTitle!.isEmpty {
        descriptionLabel.text = "(No Description)"
      } else {
        descriptionLabel.text = checklistitem.checklistTitle
      }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
