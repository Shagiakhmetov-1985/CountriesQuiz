//
//  CorrectsCell.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 05.09.2024.
//

import UIKit

class CorrectsFlagCell: UITableViewCell {
    let image = UIImageView()
    let progressView = UIProgressView()
    let title = UILabel()
    private let radius: CGFloat = 27.5
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setSubviews()
        setConfigure()
        setConstraints()
    }
    
    private func setSubviews() {
        addSubviews(subviews: image, progressView, title, on: contentView)
    }
    
    private func addSubviews(subviews: UIView..., on otherSubviews: UIView) {
        subviews.forEach { subview in
            otherSubviews.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConfigure() {
        setImage(image: image)
        setProgressView(progressView: progressView)
        setLabel(label: title)
    }
}

extension CorrectsFlagCell {
    private func setImage(image: UIImageView) {
        image.layer.cornerRadius = radius
        image.layer.borderWidth = 1
        image.clipsToBounds = true
    }
    
    private func setProgressView(progressView: UIProgressView) {
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.layer.cornerRadius = progressView.frame.height / 2
        progressView.clipsToBounds = true
    }
    
    private func setLabel(label: UILabel) {
        label.font = UIFont(name: "mr_fontick", size: 23)
        label.textColor = .white
        label.textAlignment = .center
    }
}

extension CorrectsFlagCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            image.widthAnchor.constraint(equalToConstant: radius * 2),
            image.heightAnchor.constraint(equalToConstant: radius * 2)
        ])
        
        NSLayoutConstraint.activate([
            progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            progressView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}
