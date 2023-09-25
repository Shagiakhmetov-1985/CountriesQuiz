//
//  QuestionnaireLabelCell.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 25.09.2023.
//

import UIKit

class QuestionnaireLabelCell: UITableViewCell {
    let view = UIView()
    let labelCountry = UILabel()
    let progressView = UIProgressView()
    let labelNumber = UILabel()
    let buttonFirst = UIView()
    let checkmarkFirst = UIImageView()
    let imageFirst = UIImageView()
    let buttonSecond = UIView()
    let checkmarkSecond = UIImageView()
    let imageSecond = UIImageView()
    let buttonThird = UIView()
    let checkmarkThird = UIImageView()
    let imageThird = UIImageView()
    let buttonFourth = UIView()
    let checkmarkFourth = UIImageView()
    let imageFourth = UIImageView()
    let stackViewTop = UIStackView()
    let stackViewBottom = UIStackView()
    let stackView = UIStackView()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupDesign()
        setupSubviews()
        configure()
    }
    
    private func setupDesign() {
        contentView.backgroundColor = .white
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
    
    private func configure() {
        setupView(subview: view)
        
        setupLabel(label: labelCountry, size: 30)
        
        setupProgressView(subview: progressView)
        setupLabel(label: labelNumber, size: 20)
        
        setupViewForButton(subview: buttonFirst, checkmark: checkmarkFirst,
                           flag: imageFirst)
        setupViewForButton(subview: buttonSecond, checkmark: checkmarkSecond,
                           flag: imageSecond)
        setupViewForButton(subview: buttonThird, checkmark: checkmarkThird,
                           flag: imageThird)
        setupViewForButton(subview: buttonFourth, checkmark: checkmarkFourth,
                           flag: imageFourth)
        
        setupStackView(buttonFirst: buttonFirst, buttonSecond: buttonSecond,
                       stackView: stackViewTop)
        setupStackView(buttonFirst: buttonThird, buttonSecond: buttonFourth,
                       stackView: stackViewBottom)
        setupStackView(stackViewFirst: stackViewTop, stackViewSecond: stackViewBottom,
                       stackView: stackView)
        
        setupConstraints()
    }
}
// MARK: - Setup view
extension QuestionnaireLabelCell {
    private func setupView(subview: UIView) {
        subview.backgroundColor = .greenHarlequin
        subview.layer.cornerRadius = 15
        subview.layer.shadowColor = UIColor.greenHarlequin.cgColor
        subview.layer.opacity = 0.6
        subview.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        addSubviews(subviews: labelCountry, progressView, labelNumber,
                    stackView, on: subview)
    }
    
    private func setupViewForButton(subview: UIView, checkmark: UIImageView, flag: UIImageView) {
        subview.layer.cornerRadius = 8
        subview.layer.borderColor = UIColor.white.cgColor
        subview.layer.borderWidth = 1.5
        addSubviews(subviews: checkmark, flag, on: subview)
    }
}
// MARK: - Setup progress view
extension QuestionnaireLabelCell {
    private func setupProgressView(subview: UIProgressView) {
        subview.progressTintColor = .white
        subview.trackTintColor = .white.withAlphaComponent(0.3)
        subview.layer.cornerRadius = 4
        subview.clipsToBounds = true
    }
}
// MARK: - Setup label
extension QuestionnaireLabelCell {
    private func setupLabel(label: UILabel, size: CGFloat) {
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textAlignment = .center
    }
}
// MARK: - Setup stack views
extension QuestionnaireLabelCell {
    private func setupStackView(buttonFirst: UIView, buttonSecond: UIView,
                                stackView: UIStackView) {
        addArrangedSubviews(subviews: buttonFirst, buttonSecond, on: stackView)
        stackView.spacing = 5
        stackView.distribution = .fillEqually
    }
    
    private func setupStackView(stackViewFirst: UIStackView, stackViewSecond: UIStackView,
                                stackView: UIStackView) {
        addArrangedSubviews(subviews: stackViewFirst, stackViewSecond, on: stackView)
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
extension QuestionnaireLabelCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            labelCountry.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            labelCountry.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: labelCountry.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            progressView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 10),
            labelNumber.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        constraintsOnButtons(checkmark: checkmarkFirst, flag: imageFirst, button: buttonFirst)
        constraintsOnButtons(checkmark: checkmarkSecond, flag: imageSecond, button: buttonSecond)
        constraintsOnButtons(checkmark: checkmarkThird, flag: imageThird, button: buttonThird)
        constraintsOnButtons(checkmark: checkmarkFourth, flag: imageFourth, button: buttonFourth)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelNumber.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func constraintsOnButtons(checkmark: UIImageView, flag: UIImageView,
                                      button: UIView) {
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 3),
            flag.topAnchor.constraint(equalTo: button.topAnchor, constant: 3),
            flag.leadingAnchor.constraint(equalTo: checkmark.trailingAnchor, constant: 3),
            flag.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -3),
            flag.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -3)
        ])
        setupSquare(subview: checkmark, sizes: 22)
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
}
