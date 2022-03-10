//
//  BreedsListCell.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import UIKit

class BreedsListCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Asset.Colors.textDark.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateUI(_ name: String) {
        self.nameLabel.text = name.capitalized
    }
}
