//
//  ChecklistItemCell.swift
//  ProjectTest
//
//  Created by Mariam Khan on 4/24/21.
//

import UIKit

// Custom Cell Class for Checklist Cells
class ChecklistItemCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel!
    
    // Configuring Checklist Item for Display
    func configure(for checklistitem: ChecklistItem) {
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
