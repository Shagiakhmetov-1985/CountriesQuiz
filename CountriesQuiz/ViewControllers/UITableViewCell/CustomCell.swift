//
//  CustomCell.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 18.08.2023.
//

import UIKit

class CustomCell: UITableViewCell {
    let view = UIView()
    let image = UIImageView()
    let progressView = UIProgressView()
    let labelNumber = UILabel()
    let buttonFirst = UILabel()
    let buttonSecond = UILabel()
    let buttonThird = UILabel()
    let buttonFourth = UILabel()
    let timeUp = UILabel()
    var stackView = UIStackView()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupSubviews()
        setupDesign()
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
    
    private func setupDesign() {
        contentView.backgroundColor = .white
    }
    
    private func configure() {
        stackView = setupStackView(
            buttonFirst: buttonFirst, buttonSecond: buttonSecond,
            buttonThird: buttonThird, buttonFourth: buttonFourth)
        
        setupView(subview: view)
        
        image.layer.borderWidth = 1
        
        setupProgressView(subview: progressView)
        setupLabel(label: labelNumber, color: .white)
        
        setupLabelForButton(label: buttonFirst)
        setupLabelForButton(label: buttonSecond)
        setupLabelForButton(label: buttonThird)
        setupLabelForButton(label: buttonFourth)
        
        setupLabel(label: timeUp, color: .lightPurplePink)
        
        setupConstraints()
    }
}
// MARK: - Setup view
extension CustomCell {
    private func setupView(subview: UIView) {
        subview.backgroundColor = .cyanDark
        subview.layer.cornerRadius = 15
        subview.layer.shadowColor = UIColor.cyanDark.cgColor
        subview.layer.shadowOpacity = 0.6
        subview.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        addSubviews(subviews: image, progressView, labelNumber, stackView, timeUp,
                    on: subview)
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
    private func setupLabel(label: UILabel, color: UIColor) {
        label.font = UIFont(name: "mr_fontick", size: 20)
        label.textColor = color
        label.textAlignment = .center
    }
    
    private func setupLabelForButton(label: UILabel) {
        label.font = UIFont(name: "mr_fontick", size: 20)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
    }
}
// MARK: - Setup stack view
extension CustomCell {
    private func setupStackView(buttonFirst: UILabel, buttonSecond: UILabel,
                                buttonThird: UILabel, buttonFourth: UILabel) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [buttonFirst, buttonSecond, buttonThird, buttonFourth])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }
}
// MARK: - Setup constraints
extension CustomCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 180),
            image.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
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
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        setHeight(subviews: buttonFirst, buttonSecond, buttonThird, buttonFourth)
        
        NSLayoutConstraint.activate([
            timeUp.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            timeUp.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setHeight(subviews: UIView...) {
        subviews.forEach { subview in
            NSLayoutConstraint.activate([
                subview.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }
}
