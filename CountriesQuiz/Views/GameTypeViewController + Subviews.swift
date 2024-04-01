//
//  GameTypeViewController + Subviews.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 01.04.2024.
//

import UIKit

// MARK: - Setup views
extension GameTypeViewController {
    func setupView(color: UIColor, radius: CGFloat? = nil, addSubview: UIView? = nil,
                   addButton: UIButton? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius ?? 0
        view.translatesAutoresizingMaskIntoConstraints = false
        if let image = addSubview {
            view.addSubview(image)
        } else if let button = addButton {
            view.addSubview(button)
            view.layer.shadowColor = color.cgColor
            view.layer.shadowOpacity = 0.4
            view.layer.shadowOffset = CGSize(width: 0, height: 6)
        }
        return view
    }
}
// MARK: - Setup images
extension GameTypeViewController {
    func setupImage(image: String, color: UIColor, size: CGFloat) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup labels
extension GameTypeViewController {
    func setupLabel(color: UIColor, title: String, size: CGFloat, style: String,
                            alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = UIFont(name: style, size: size)
        label.textAlignment = alignment ?? .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func settingLabel(label: UILabel, size: CGFloat) {
        label.textColor = .white
        label.font = UIFont(name: "Gill Sans", size: size)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    }
}
// MARK: - Setup buttons
extension GameTypeViewController {
    func setupButton(image: String, action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func setupButton(image: String, color: UIColor, action: Selector,
                             isEnabled: Bool? = nil) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = Button(type: .system)
        button.backgroundColor = color
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = isEnabled ?? true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func setupButton(color: UIColor, labelFirst: UILabel,
                             labelSecond: UILabel, image: UIImageView? = nil,
                             tag: Int, isEnabled: Bool? = nil) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = 20
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changeSetting), for: .touchUpInside)
        button.tag = tag
        button.isEnabled = isEnabled ?? true
        if let image = image {
            viewModel.setupSubviews(subviews: labelFirst, labelSecond, image, on: button)
        } else {
            viewModel.setupSubviews(subviews: labelFirst, labelSecond, on: button)
        }
        return button
    }
    
    func setupButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = Button(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(viewModel.colorFavourite, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 25)
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func setupButton(color: UIColor, addLabelFirst: UILabel,
                             addLabelSecond: UILabel, tag: Int? = nil) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = color
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 13
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.tag = tag ?? 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continents), for: .touchUpInside)
        viewModel.setupSubviews(subviews: addLabelFirst, addLabelSecond, on: button)
        return button
    }
    
    func setCheckmarkButton(image: String) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = viewModel.background
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(countdown), for: .touchUpInside)
        return button
    }
}
// MARK: - Setup stack views
extension GameTypeViewController {
    func setupStackView(buttonFirst: UIButton, buttonSecond: UIButton,
                                buttonThird: UIButton? = nil,
                                spacing: CGFloat? = nil) -> UIStackView {
        var arrangedSubviews: [UIView] = []
        if let buttonThird = buttonThird {
            arrangedSubviews = [buttonFirst, buttonSecond, buttonThird]
        } else {
            arrangedSubviews = [buttonFirst, buttonSecond]
        }
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.spacing = spacing ?? 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func setupStackView(labelTop: UILabel, labelBottom: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [labelTop, labelBottom])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func setupStackView(view: UIView, stackView: UIStackView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [view, stackView])
        stackView.spacing = 10
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func setupStackView(view: UIView, label: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [view, label])
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup picker views
extension GameTypeViewController {
    func setupPickerView(color: UIColor? = nil, tag: Int) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = color
        pickerView.layer.cornerRadius = 13
        pickerView.tag = tag
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }
}
