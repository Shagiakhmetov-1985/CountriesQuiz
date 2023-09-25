//
//  QuestionnaireCell.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 30.08.2023.
//

import UIKit

class QuestionnaireCell: UITableViewCell {
    let view = UIView()
    let image = UIImageView()
    let progressView = UIProgressView()
    let labelNumber = UILabel()
    let buttonFirst = UIView()
    var checkmarkFirst = UIImageView()
    let titleFirst = UILabel()
    let buttonSecond = UIView()
    var checkmarkSecond = UIImageView()
    let titleSecond = UILabel()
    let buttonThird = UIView()
    var checkmarkThird = UIImageView()
    let titleThird = UILabel()
    let buttonFourth = UIView()
    var checkmarkFourth = UIImageView()
    let titleFourth = UILabel()
    let stackView = UIStackView()
    
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
        setupView(subview: view)
        
        image.layer.borderWidth = 1
        
        setupProgressView(subview: progressView)
        setupLabel(labels: labelNumber, titleFirst, titleSecond, titleThird, titleFourth)
        
        setupViewForButton(subview: buttonFirst, image: checkmarkFirst, label: titleFirst)
        setupViewForButton(subview: buttonSecond, image: checkmarkSecond, label: titleSecond)
        setupViewForButton(subview: buttonThird, image: checkmarkThird, label: titleThird)
        setupViewForButton(subview: buttonFourth, image: checkmarkFourth, label: titleFourth)
        
        setupStackView(stackView: stackView)
        
        setupConstraints()
    }
}
// MARK: - Setup view
extension QuestionnaireCell {
    private func setupView(subview: UIView) {
        subview.backgroundColor = .greenHarlequin
        subview.layer.cornerRadius = 15
        subview.layer.shadowColor = UIColor.greenHarlequin.cgColor
        subview.layer.shadowOpacity = 0.6
        subview.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        addSubviews(subviews: image, progressView, labelNumber, stackView,
                    on: subview)
    }
    
    private func setupViewForButton(subview: UIView, image: UIImageView, label: UILabel) {
        subview.layer.cornerRadius = 8
        subview.layer.borderColor = UIColor.white.cgColor
        subview.layer.borderWidth = 1.5
        addSubviews(subviews: image, label, on: subview)
    }
}
// MARK: - Setup progress view
extension QuestionnaireCell {
    private func setupProgressView(subview: UIProgressView) {
        subview.progressTintColor = .white
        subview.trackTintColor = .white.withAlphaComponent(0.3)
        subview.layer.cornerRadius = 4
        subview.clipsToBounds = true
    }
}
// MARK: - Setup labels
extension QuestionnaireCell {
    private func setupLabel(labels: UILabel...) {
        labels.forEach { label in
            label.font = UIFont(name: "mr_fontick", size: 20)
            label.textAlignment = .center
        }
    }
}
// MARK: -  Setup stack view
extension QuestionnaireCell {
    private func setupStackView(stackView: UIStackView) {
        addArrangedSubviews(subviews: buttonFirst, buttonSecond,
                            buttonThird, buttonFourth, on: stackView)
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
    }
    
    private func addArrangedSubviews(subviews: UIView..., on stackView: UIStackView) {
        subviews.forEach { subview in
            stackView.addArrangedSubview(subview)
        }
    }
}
// MARK: - Setup constraints
extension QuestionnaireCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 180),
            image.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            progressView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 10),
            labelNumber.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        constraintsOnButton(image: checkmarkFirst, label: titleFirst, button: buttonFirst)
        constraintsOnButton(image: checkmarkSecond, label: titleSecond, button: buttonSecond)
        constraintsOnButton(image: checkmarkThird, label: titleThird, button: buttonThird)
        constraintsOnButton(image: checkmarkFourth, label: titleFourth, button: buttonFourth)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelNumber.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        setHeight(subviews: buttonFirst, buttonSecond, buttonThird, buttonFourth)
    }
    
    private func constraintsOnButton(image: UIImageView, label: UILabel, button: UIView) {
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        setupSquare(subview: image, sizes: 22)
    }
    
    private func setHeight(subviews: UIView...) {
        subviews.forEach { subview in
            NSLayoutConstraint.activate([
                subview.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
}
