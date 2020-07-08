//
//  ComboBoxCell.swift
//  Homework 20
//
//  Created by Олександр Олексин on 12/29/19.
//  Copyright © 2019 Oleksandr Oleksyn. All rights reserved.
//

import UIKit

final class ComboBoxCell: UITableViewCell {

    @IBOutlet weak var questionTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override func prepareForReuse() {
        questionTitle.text = nil
    }
    
}
