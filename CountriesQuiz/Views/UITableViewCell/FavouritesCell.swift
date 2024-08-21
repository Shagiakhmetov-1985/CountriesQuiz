//
//  FavouritesCell.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 15.08.2024.
//

import UIKit

class FavouritesCell: UITableViewCell {
    let flag = UIImageView()
    let name = UILabel()
    let arrow = UIImageView()
    private let radius: CGFloat = 27.5
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setSubviews()
        configure()
        setConstraints()
    }
    
    private func setSubviews() {
        addSubviews(subviews: flag, name, arrow, on: contentView)
    }
    
    private func addSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configure() {
        setImage(image: flag)
        setLabel(label: name)
        setImageArrow(image: arrow)
    }
}

extension FavouritesCell {
    private func setImage(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.cornerRadius = radius
        image.clipsToBounds = true
    }
    
    private func setImageArrow(image: UIImageView) {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        image.image = UIImage(systemName: "chevron.right", withConfiguration: size)
        image.tintColor = .white
    }
    
    private func setLabel(label: UILabel) {
        label.font = UIFont(name: "mr_fontick", size: 26)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
    }
}

extension FavouritesCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            flag.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            flag.widthAnchor.constraint(equalToConstant: radius * 2),
            flag.heightAnchor.constraint(equalToConstant: radius * 2)
        ])
        
        NSLayoutConstraint.activate([
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 75),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45)
        ])
        
        NSLayoutConstraint.activate([
            arrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
