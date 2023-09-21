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
    let buttonFirst = UILabel()
    let checkmarkFirst = UIImageView()
    let titleFirst = UILabel()
    let buttonSecond = UILabel()
    let checkmarkSecond = UIImageView()
    let titleSecond = UILabel()
    let buttonThird = UILabel()
    let checkmarkThird = UIImageView()
    let titleThird = UILabel()
    let buttonFoutrh = UILabel()
    let checkmarkFourth = UIImageView()
    let titleFourth = UILabel()
    let timeUp = UILabel()
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
        setView(subview: view)
        
        image.layer.borderWidth = 1
        
        setProgressView(subview: progressView)
        
        
        setupConstraints()
    }
}
// MARK: - Setup view
extension QuestionnaireCell {
    private func setView(subview: UIView) {
        subview.backgroundColor = .greenHarlequin
        subview.layer.cornerRadius = 15
        subview.layer.shadowColor = UIColor.greenHarlequin.cgColor
        subview.layer.shadowOpacity = 0.6
        subview.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        addSubviews(subviews: image, progressView, labelNumber, stackView, timeUp,
                    on: subview)
    }
}
// MARK: - Setup progress view
extension QuestionnaireCell {
    private func setProgressView(subview: UIProgressView) {
        subview.progressTintColor = .white
        subview.trackTintColor = .white.withAlphaComponent(0.3)
        subview.layer.cornerRadius = 4
        subview.clipsToBounds = true
    }
}
// MARK: - Setup constraints
extension QuestionnaireCell {
    private func setupConstraints() {
        
    }
}
