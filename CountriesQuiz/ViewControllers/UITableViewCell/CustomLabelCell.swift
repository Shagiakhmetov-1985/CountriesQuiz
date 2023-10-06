//
//  CustomLabelCell.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 22.08.2023.
//

import UIKit

class CustomLabelCell: UITableViewCell {
    let labelCountry = UILabel()
    let progressView = UIProgressView()
    let labelNumber = UILabel()
    let imageArrow = UIImageView()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupSubviews()
        configure()
    }
    
    private func setupSubviews() {
        addSubviews(subviews: labelCountry, progressView, labelNumber,
                    imageArrow, on: contentView)
    }
    
    private func addSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configure() {
        setupLabel(label: labelCountry, size: 26)
        setupProgressView(subview: progressView)
        setupLabel(label: labelNumber, size: 23)
        setupImageArrow(image: imageArrow)
        
        setupConstraints()
    }
}
// MARK: - Setup progress view
extension CustomLabelCell {
    private func setupProgressView(subview: UIProgressView) {
        subview.progressTintColor = .white
        subview.trackTintColor = .white.withAlphaComponent(0.3)
        subview.layer.cornerRadius = 4
        subview.clipsToBounds = true
    }
}
// MARK: - Setup properties of labels
extension CustomLabelCell {
    private func setupLabel(label: UILabel, size: CGFloat) {
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
    }
}
// MARK: - Setup images
extension CustomLabelCell {
    private func setupImageArrow(image: UIImageView) {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        image.image = UIImage(systemName: "chevron.right", withConfiguration: size)
        image.tintColor = .white
    }
}
// MARK: - Setup constraints
extension CustomLabelCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            labelCountry.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            labelCountry.trailingAnchor.constraint(equalTo: imageArrow.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: labelCountry.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            progressView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 10),
            labelNumber.trailingAnchor.constraint(equalTo: imageArrow.leadingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            imageArrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageArrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
