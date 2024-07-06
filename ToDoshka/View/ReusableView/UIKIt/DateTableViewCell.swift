//
//  DateTableViewCell.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 05.07.2024.
//

import UIKit

final class DateTableViewCell: UITableViewCell {
    static let reuseId = "DateTableCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.layer.cornerRadius = 0
        self.layer.maskedCorners = []
        self.textLabel?.attributedText = nil
        self.textLabel?.textColor = .label
    }
}
