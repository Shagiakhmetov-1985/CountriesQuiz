//
//  CustomLabelCell.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 22.08.2023.
//

import UIKit

class CustomLabelCell: UITableViewCell {
    let view = UIView()
    let labelName = UILabel()
    let progressView = UIProgressView()
    let labelNumber = UILabel()
    let viewFirst = UIView()
    let viewSecond = UIView()
    let viewThird = UIView()
    let viewFourth = UIView()
    let imageFirst = UIImageView()
    let imageSecond = UIImageView()
    let imageThird = UIImageView()
    let imageFourth = UIImageView()
    var stackViewFirst = UIStackView()
    var stackViewSecond = UIStackView()
    var stackView = UIStackView()
    let timeUp = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupSubviews()
        setupDesing()
        configure()
    }
    
    private func setupSubviews() {
        addSubviews(subviews: view, on: contentView)
    }
    
    private func addSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupDesing() {
        contentView.backgroundColor = .white
    }
    
    private func configure() {
        stackViewFirst = setupStackView(
            viewFirst: viewFirst, viewSecond: viewSecond)
        stackViewSecond = setupStackView(
            viewFirst: viewThird, viewSecond: viewFourth)
        stackView = setupStackView(
            stackViewFirst: stackViewFirst, stackViewSecond: stackViewSecond)
        
        setupView(subview: view)
        
        setupLabel(label: labelName, size: 30, color: .white)
        
        setupProgressView(subview: progressView)
        setupLabel(label: labelNumber, size: 20, color: .white)
        
        setupView(subview: viewFirst, image: imageFirst)
        setupView(subview: viewSecond, image: imageSecond)
        setupView(subview: viewThird, image: imageThird)
        setupView(subview: viewFourth, image: imageFourth)
        setupImage(images: imageFirst, imageSecond, imageThird, imageFourth)
        
        setupLabel(label: timeUp, size: 20, color: .lightPurplePink)
        
        setupConstraints()
    }
}
// MARK: - Setup view
extension CustomLabelCell {
    private func setupView(subview: UIView) {
        subview.backgroundColor = .cyanDark
        subview.layer.cornerRadius = 15
        subview.layer.shadowColor = UIColor.cyanDark.cgColor
        subview.layer.shadowOpacity = 0.6
        subview.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        addSubviews(subviews: labelName, progressView, labelNumber, stackView,
                    timeUp, on: subview)
    }
    
    private func setupView(subview: UIView, image: UIImageView) {
        subview.backgroundColor = .white.withAlphaComponent(0.9)
        subview.layer.cornerRadius = 8
        addSubviews(subviews: image, on: subview)
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
    private func setupLabel(label: UILabel, size: CGFloat, color: UIColor) {
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color
        label.textAlignment = .center
    }
}
// MARK: - Setup images
extension CustomLabelCell {
    private func setupImage(images: UIImageView...) {
        images.forEach { image in
            image.layer.borderWidth = 1
            image.clipsToBounds = true
            image.layer.cornerRadius = 4
        }
    }
}
// MARK: - Setup stack views
extension CustomLabelCell {
    private func setupStackView(viewFirst: UIView, viewSecond: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [viewFirst, viewSecond])
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        return stackView
    }
    
    private func setupStackView(stackViewFirst: UIStackView,
                                stackViewSecond: UIStackView) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [stackViewFirst, stackViewSecond])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        return stackView
    }
}
// MARK: - Setup constraints
extension CustomLabelCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            labelName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            labelName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            progressView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 10),
            labelNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelNumber.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 170)
        ])
        setupImageButton(image: imageFirst, on: viewFirst)
        setupImageButton(image: imageSecond, on: viewSecond)
        setupImageButton(image: imageThird, on: viewThird)
        setupImageButton(image: imageFourth, on: viewFourth)
        
        NSLayoutConstraint.activate([
            timeUp.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            timeUp.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupImageButton(image: UIView, on button: UIView) {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: button.topAnchor, constant: 4),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 4),
            image.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -4),
            image.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -4)
        ])
    }
    
    private func width() -> CGFloat {
        contentView.frame.width - 10
    }
}
