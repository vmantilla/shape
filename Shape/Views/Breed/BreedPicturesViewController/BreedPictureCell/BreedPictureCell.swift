//
//  BreedPictureCell.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import UIKit
import Kingfisher

class BreedPictureCell: UICollectionViewCell {
    
    let pictureImageVIew: UIImageView = {
        let myImageView = UIImageView()
        myImageView.contentMode = .scaleAspectFit
        return myImageView
    }()
    
    let favoriteImageVIew: UIImageView = {
        let myImageView = UIImageView()
        myImageView.contentMode = .center
        return myImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with urlString: String, isFavorite: Bool) {
        let url = URL(string: urlString)
        contentView.addSubview(pictureImageVIew)
        contentView.addSubview(favoriteImageVIew)
        
        setFavorite(isFavorite)
        
        pictureImageVIew.translatesAutoresizingMaskIntoConstraints = false
        pictureImageVIew.topAnchor.constraint(equalTo:contentView.topAnchor).isActive = true
        pictureImageVIew.bottomAnchor.constraint(equalTo:contentView.bottomAnchor).isActive = true
        pictureImageVIew.trailingAnchor.constraint(equalTo:contentView.trailingAnchor).isActive = true
        pictureImageVIew.leadingAnchor.constraint(equalTo:contentView.leadingAnchor).isActive = true
        
        favoriteImageVIew.translatesAutoresizingMaskIntoConstraints = false
        favoriteImageVIew.centerYAnchor.constraint(equalTo: pictureImageVIew.centerYAnchor).isActive = true
        favoriteImageVIew.centerXAnchor.constraint(equalTo: pictureImageVIew.centerXAnchor).isActive = true
        favoriteImageVIew.widthAnchor.constraint(equalToConstant: 20).isActive = true
        favoriteImageVIew.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        pictureImageVIew.kf.setImage(with: url)
    }
    
    func setFavorite( _ value: Bool) {
        if value {
            favoriteImageVIew.image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
        } else {
            favoriteImageVIew.image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        }
    }
}
