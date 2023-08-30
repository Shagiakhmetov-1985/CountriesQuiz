//
//  QuestionnaireCell.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 30.08.2023.
//

import UIKit

class QuestionnaireCell: UITableViewCell {
    let image = UIImageView()
    let title = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        configure()
    }
    
    private func configure() {
        title.font = UIFont(name: "mr_fontick", size: 23)
        title.numberOfLines = 0
        title.textAlignment = .center
        
        addSubviews(subviews: image, title)
        setupConstraints()
    }
    
    private func addSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
// MARK: - Setup constraints
extension QuestionnaireCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
