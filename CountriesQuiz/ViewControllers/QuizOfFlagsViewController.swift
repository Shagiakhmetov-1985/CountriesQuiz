//
//  QuizOfFlagsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 09.01.2023.
//

import UIKit

class QuizOfFlagsViewController: UIViewController {
    
    private lazy var viewPanel: UIView = {
        let view = setView(color: UIColor(
            red: 102/255,
            green: 153/255,
            blue: 255/255,
            alpha: 1
        ))
        return view
    }()
    
    private lazy var buttonBackMenu: UIButton = {
        let button = setButton(
            title: "Главное меню",
            style: "mr_fontick",
            size: 15,
            colorTitle: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 252/255,
                alpha: 1
            ),
            colorBackgroud: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            radiusCorner: 14,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ).cgColor,
            radiusShadow: 2.5,
            shadowOffsetWidth: 2.5,
            shadowOffsetHeight: 2.5
        )
        button.addTarget(self, action: #selector(exitToMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentView: UIView = {
        let view = setView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuizOfFlagsVC()
        setupSubviews(subviews: viewPanel,
                      buttonBackMenu,
                      contentView
        )
        setConstraints()
    }
    
    private func setupQuizOfFlagsVC() {
        view.backgroundColor = UIColor(
            red: 54/255,
            green: 55/255,
            blue: 215/255,
            alpha: 1
        )
    }
    
    private func setupSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            viewPanel.topAnchor.constraint(equalTo: view.topAnchor),
            viewPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewPanel.heightAnchor.constraint(equalToConstant: fixConstraintsForViewPanelBySizeIphone())
        ])
        
        NSLayoutConstraint.activate([
            buttonBackMenu.topAnchor.constraint(equalTo: view.topAnchor, constant: fixConstraintsForButtonBySizeIphone()),
            buttonBackMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonBackMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -245)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: viewPanel.bottomAnchor, constant: 1),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fixConstraintsForViewPanelBySizeIphone() -> CGFloat {
        return view.frame.height > 736 ? 110 : 70
    }
    
    private func fixConstraintsForButtonBySizeIphone() -> CGFloat {
        return view.frame.height > 736 ? 60 : 30
    }
    
    @objc private func exitToMenu() {
        dismiss(animated: true)
    }
}
// MARK: - Setup view
extension QuizOfFlagsViewController {
    private func setView(color: UIColor? = nil) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let color = color {
            view.backgroundColor = color
        } else {
            setGradient(content: view)
        }
        return view
    }
    
    private func setGradient(content: UIView) {
        let gradientLayer = CAGradientLayer()
        let colorBlue = UIColor(red: 30/255, green: 113/255, blue: 204/255, alpha: 1)
        let colorLightBlue = UIColor(red: 102/255, green: 153/255, blue: 204/255, alpha: 1)
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorLightBlue.cgColor, colorBlue.cgColor]
        content.layer.addSublayer(gradientLayer)
    }
}
// MARK: - Setup button
extension QuizOfFlagsViewController {
    private func setButton(title: String,
                           style: String? = nil,
                           size: CGFloat,
                           colorTitle: UIColor? = nil,
                           colorBackgroud: UIColor? = nil,
                           radiusCorner: CGFloat,
                           borderWidth: CGFloat? = nil,
                           borderColor: CGColor? = nil,
                           shadowColor: CGColor? = nil,
                           radiusShadow: CGFloat? = nil,
                           shadowOffsetWidth: CGFloat? = nil,
                           shadowOffsetHeight: CGFloat? = nil,
                           isEnabled: Bool? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(colorTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: style ?? "", size: size)
        button.backgroundColor = colorBackgroud
        button.layer.cornerRadius = radiusCorner
        button.layer.borderWidth = borderWidth ?? 0
        button.layer.borderColor = borderColor
        button.layer.shadowColor = shadowColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = radiusShadow ?? 0
        button.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                           height: shadowOffsetHeight ?? 0
        )
        button.isEnabled = isEnabled ?? true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
