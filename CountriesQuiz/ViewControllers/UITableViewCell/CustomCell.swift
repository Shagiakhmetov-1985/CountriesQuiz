//
//  CustomCell.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 18.08.2023.
//

import UIKit

class CustomCell: UITableViewCell {
    let image = UIImageView()
    let progressView = UIProgressView()
    let labelNumber = UILabel()
    let imageArrow = UIImageView()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupSubviews()
        configure()
    }
    
    private func setupSubviews() {
        addSubviews(subviews: image, progressView, labelNumber, imageArrow,
                    on: contentView)
    }
    
    private func addSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configure() {
        setupImage(image: image)
        setupProgressView(subview: progressView)
        setupLabel(label: labelNumber)
        setupImageArrow(image: imageArrow)
        
        setupConstraints()
    }
}
// MARK: - Setup image
extension CustomCell {
    private func setupImage(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.cornerRadius = radius()
        image.clipsToBounds = true
    }
    
    private func setupImageArrow(image: UIImageView) {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        image.image = UIImage(systemName: "chevron.right", withConfiguration: size)
        image.tintColor = .white
    }
}
// MARK: - Setup progress view
extension CustomCell {
    private func setupProgressView(subview: UIProgressView) {
        subview.progressTintColor = .white
        subview.trackTintColor = .white.withAlphaComponent(0.3)
        subview.layer.cornerRadius = 4
        subview.clipsToBounds = true
    }
}
// MARK: - Setup properties of labels
extension CustomCell {
    private func setupLabel(label: UILabel) {
        label.font = UIFont(name: "mr_fontick", size: 23)
        label.textColor = .white
        label.textAlignment = .center
    }
}
// MARK: - Setup constraints
extension CustomCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            image.widthAnchor.constraint(equalToConstant: radius() * 2),
            image.heightAnchor.constraint(equalToConstant: radius() * 2)
        ])
        
        NSLayoutConstraint.activate([
            progressView.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            progressView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 10),
            labelNumber.trailingAnchor.constraint(equalTo: imageArrow.leadingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            imageArrow.centerYAnchor.constraint(equalTo: labelNumber.centerYAnchor),
            imageArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func radius() -> CGFloat {
        27.5
    }
}
