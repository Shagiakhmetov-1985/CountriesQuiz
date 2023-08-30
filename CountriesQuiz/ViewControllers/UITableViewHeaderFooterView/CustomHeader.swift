//
//  CustomHeader.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 30.08.2023.
//

import UIKit

class CustomHeader: UITableViewHeaderFooterView {
    let title = UILabel()
    let image = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        title.font = UIFont(name: "mr_fontick", size: 25)
        title.textColor = .white
        
        image.layer.borderWidth = 1
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        
        addSubviews(subviews: title, image)
        setupConstraints()
    }
    
    private func addSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            contentView.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

extension CustomHeader {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 140),
            image.widthAnchor.constraint(equalToConstant: 210)
        ])
    }
}
