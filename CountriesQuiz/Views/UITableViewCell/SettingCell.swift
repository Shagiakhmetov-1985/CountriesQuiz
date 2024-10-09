//
//  SettingCell.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 09.10.2024.
//

import UIKit

class SettingCell: UITableViewCell {
    let view = UIView()
    let image = UIImageView()
    let title = UILabel()
    let additional = UILabel()
    let arrow = UIImageView()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setSubviews()
        setConfigute()
        setConstraints()
    }
    
    private func setSubviews() {
        addSubviews(subviews: view, image, title, additional, arrow, on: contentView)
    }
    
    private func addSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setConfigute() {
        setView(view: view)
        setImage(image: image)
        setTitle(title: title, color: .blueMiddlePersian, size: 19)
        setTitle(title: additional, color: .blueMiddlePersian.withAlphaComponent(0.6), size: 21)
        setImageArrow(image: arrow)
    }
}

extension SettingCell {
    private func setView(view: UIView) {
        view.backgroundColor = .blueMiddlePersian
        view.layer.cornerRadius = 9
    }
    
    private func setImage(image: UIImageView) {
        image.tintColor = .white
    }
    
    private func setTitle(title: UILabel, color: UIColor, size: CGFloat) {
        title.textColor = color
        title.font = UIFont(name: "GillSans", size: size)
    }
    
    private func setImageArrow(image: UIImageView) {
        let size = UIImage.SymbolConfiguration(pointSize: 23)
        image.image = UIImage(systemName: "chevron.right", withConfiguration: size)
        image.tintColor = .blueMiddlePersian.withAlphaComponent(0.4)
    }
}

extension SettingCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 40),
            view.heightAnchor.constraint(equalToConstant: 40),
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            additional.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            additional.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            arrow.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
