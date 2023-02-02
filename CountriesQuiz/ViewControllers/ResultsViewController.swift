//
//  ResultsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 25.01.2023.
//

import UIKit

class ResultsViewController: UIViewController {
    private lazy var viewPanel: UIView = {
        let view = setView(
            color: UIColor(
                red: 153/255,
                green: 215/255,
                blue: 102/255,
                alpha: 1),
            tag: 1)
        return view
    }()
    
    private lazy var buttonBackMenu: UIButton = {
        let button = setButton(
            title: "Главное меню",
            style: "mr_fontick",
            size: 15,
            colorTitle: UIColor(
                red: 51/255,
                green: 133/255,
                blue: 51/255,
                alpha: 1),
            colorBackgroud: UIColor(
                red: 224/255,
                green: 255/255,
                blue: 224/255,
                alpha: 1),
            radiusCorner: 14,
            shadowColor: UIColor(
                red: 51/255,
                green: 83/255,
                blue: 51/255,
                alpha: 1).cgColor,
            radiusShadow: 2.5,
            shadowOffsetWidth: 2.5,
            shadowOffsetHeight: 2.5)
        button.addTarget(self, action: #selector(exitToMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = setView(
            tag: 2)
        view.frame.size = contentSize
        return view
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 150)
    }
    
    private lazy var miniViewController: UIView = {
        let view = setView(
            cornerRadius: radiusMiniViewController(),
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1),
            shadowRadius: 3.5,
            shadowOffsetWidth: 3.5,
            shadowOffsetHeight: 3.5,
            tag: 3)
        return view
    }()
    
    private lazy var labelNumberQuiz: UILabel = {
        let label = setLabel(
            title: "Вопрос 1 из 20",
            size: 25,
            style: "mr_fontick",
            color: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1),
            colorOfShadow: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1).cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            textAlignment: .center)
        return label
    }()
    
    private lazy var imageFlag: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "australia")
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor(
            red: 54/255,
            green: 55/255,
            blue: 215/255,
            alpha: 1).cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var labelButtonFirst: UILabel = {
        let label = setLabel(
            title: "Ответ 1",
            size: 15,
            style: "mr_fontick",
            color: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 252/255,
                alpha: 1),
            textAlignment: .center)
        return label
    }()
    
    private lazy var labelButtonSecond: UILabel = {
        let label = setLabel(
            title: "Ответ 2",
            size: 15,
            style: "mr_fontick",
            color: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 252/255,
                alpha: 1),
            textAlignment: .center)
        return label
    }()
    
    private lazy var labelButtonThird: UILabel = {
        let label = setLabel(
            title: "Ответ 3",
            size: 15,
            style: "mr_fontick",
            color: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 252/255,
                alpha: 1),
            textAlignment: .center)
        return label
    }()
    
    private lazy var labelButtonFourth: UILabel = {
        let label = setLabel(
            title: "Ответ 4",
            size: 15,
            style: "mr_fontick",
            color: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 252/255,
                alpha: 1),
            textAlignment: .center)
        return label
    }()
    
    var results: [Results]!
    
    private let shadowView = ShadowView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingVC()
        setupSubviews(subviews: viewPanel,
                      buttonBackMenu,
                      contentView)
        setupSubviewsOnMiniViewController(subviews: labelNumberQuiz,
                                          imageFlag,
                                          labelButtonFirst,
                                          labelButtonSecond,
                                          labelButtonThird,
                                          labelButtonFourth)
        setupSubviewsOnContentView(subviews: scrollView)
        setupSubviewsOnScrollView(subviews: miniViewController)
        setConstraints()
    }
    
    private func setupSettingVC() {
        view.backgroundColor = UIColor(
            red: 51/255,
            green: 83/255,
            blue: 51/255,
            alpha: 1)
    }
    
    private func setupSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupSubviewsOnContentView(subviews: UIView...) {
        subviews.forEach { subview in
            contentView.addSubview(subview)
        }
    }
    
    private func setupSubviewsOnMiniViewController(subviews: UIView...) {
        subviews.forEach { subview in
            miniViewController.addSubview(subview)
        }
    }
    
    private func setupSubviewsOnScrollView(subviews: UIView...) {
        subviews.forEach { subview in
            scrollView.addSubview(subview)
        }
    }
    // MARK: - Setup constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            viewPanel.topAnchor.constraint(equalTo: view.topAnchor),
            viewPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewPanel.heightAnchor.constraint(equalToConstant: fixConstraintsForViewPanelBySizeIphone())
        ])
        
        NSLayoutConstraint.activate([
            buttonBackMenu.topAnchor.constraint(equalTo: view.topAnchor, constant: fixConstraintsForButtonBySizeIphone()),
            buttonBackMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 245),
            buttonBackMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: viewPanel.bottomAnchor, constant: 1),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            miniViewController.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 30),
            miniViewController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            miniViewController.widthAnchor.constraint(equalToConstant: setupWidthConstraint()),
            miniViewController.heightAnchor.constraint(equalToConstant: setupHeightConstraint())
        ])
        
        NSLayoutConstraint.activate([
            labelNumberQuiz.topAnchor.constraint(equalTo: miniViewController.topAnchor, constant: 12),
            labelNumberQuiz.centerXAnchor.constraint(equalTo: miniViewController.centerXAnchor),
            labelNumberQuiz.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: labelNumberQuiz.bottomAnchor, constant: 12),
            imageFlag.centerXAnchor.constraint(equalTo: miniViewController.centerXAnchor),
            imageFlag.widthAnchor.constraint(equalToConstant: 180),
            imageFlag.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        NSLayoutConstraint.activate([
            labelButtonFirst.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 16),
            labelButtonFirst.centerXAnchor.constraint(equalTo: miniViewController.centerXAnchor),
            labelButtonFirst.heightAnchor.constraint(equalToConstant: 22),
            labelButtonFirst.leadingAnchor.constraint(equalTo: miniViewController.leadingAnchor, constant: 30),
            labelButtonFirst.trailingAnchor.constraint(equalTo: miniViewController.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            labelButtonSecond.topAnchor.constraint(equalTo: labelButtonFirst.bottomAnchor, constant: 6),
            labelButtonSecond.centerXAnchor.constraint(equalTo: miniViewController.centerXAnchor),
            labelButtonSecond.heightAnchor.constraint(equalToConstant: 22),
            labelButtonSecond.leadingAnchor.constraint(equalTo: miniViewController.leadingAnchor, constant: 30),
            labelButtonSecond.trailingAnchor.constraint(equalTo: miniViewController.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            labelButtonThird.topAnchor.constraint(equalTo: labelButtonSecond.bottomAnchor, constant: 6),
            labelButtonThird.centerXAnchor.constraint(equalTo: miniViewController.centerXAnchor),
            labelButtonThird.heightAnchor.constraint(equalToConstant: 22),
            labelButtonThird.leadingAnchor.constraint(equalTo: miniViewController.leadingAnchor, constant: 30),
            labelButtonThird.trailingAnchor.constraint(equalTo: miniViewController.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            labelButtonFourth.topAnchor.constraint(equalTo: labelButtonThird.bottomAnchor, constant: 6),
            labelButtonFourth.centerXAnchor.constraint(equalTo: miniViewController.centerXAnchor),
            labelButtonFourth.heightAnchor.constraint(equalToConstant: 22),
            labelButtonFourth.leadingAnchor.constraint(equalTo: miniViewController.leadingAnchor, constant: 30),
            labelButtonFourth.trailingAnchor.constraint(equalTo: miniViewController.trailingAnchor, constant: -30)
        ])
    }
    
    private func fixConstraintsForViewPanelBySizeIphone() -> CGFloat {
        return view.frame.height > 736 ? 110 : 70
    }
    
    private func fixConstraintsForButtonBySizeIphone() -> CGFloat {
        return view.frame.height > 736 ? 60 : 30
    }
    
    private func setupWidthConstraint() -> CGFloat {
        view.frame.width - 60
    }
    
    private func setupHeightConstraint() -> CGFloat {
        300
    }
    
    private func radiusMiniViewController() -> CGFloat {
        15
    }
    
    @objc private func exitToMenu() {
        dismiss(animated: true)
    }
}

// MARK: - Setup view
extension ResultsViewController {
    private func setView(color: UIColor? = nil, cornerRadius: CGFloat? = nil,
                         borderWidth: CGFloat? = nil, borderColor: UIColor? = nil,
                         shadowColor: UIColor? = nil, shadowRadius: CGFloat? = nil,
                         shadowOffsetWidth: CGFloat? = nil,
                         shadowOffsetHeight: CGFloat? = nil,
                         tag: Int? = nil) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = cornerRadius ?? 0
        view.layer.borderWidth = borderWidth ?? 0
        view.layer.borderColor = borderColor?.cgColor
        view.layer.shadowColor = shadowColor?.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = shadowRadius ?? 0
        view.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                         height: shadowOffsetHeight ?? 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = tag ?? 0
        
        switch tag {
        case 1:
            view.backgroundColor = color
        case 2:
            setGradient(content: view)
        default:
            setGradientMiniViewController(content: view)
        }
        
        return view
    }
    
    private func setGradient(content: UIView) {
        let gradientLayer = CAGradientLayer()
        let colorGreen = UIColor(red: 102/255, green: 255/255, blue: 102/255, alpha: 1)
        let colorLightGreen = UIColor(red: 204/255, green: 255/255, blue: 204/255, alpha: 1)
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorLightGreen.cgColor, colorGreen.cgColor]
        content.layer.addSublayer(gradientLayer)
    }
    
    private func setGradientMiniViewController(content: UIView) {
        let gradientLayer = CAGradientLayer()
        let colorGreen = UIColor(red: 30/255, green: 113/255, blue: 204/255, alpha: 1)
        let colorLightGreen = UIColor(red: 102/255, green: 153/255, blue: 204/255, alpha: 1)
        gradientLayer.frame.size.width = setupWidthConstraint()
        gradientLayer.frame.size.height = setupHeightConstraint()
        gradientLayer.cornerRadius = radiusMiniViewController()
        gradientLayer.colors = [colorLightGreen.cgColor, colorGreen.cgColor]
        content.layer.addSublayer(gradientLayer)
    }
}
// MARK: - Setup button
extension ResultsViewController {
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
                           isEnabled: Bool? = nil,
                           tag: Int? = nil) -> UIButton {
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
                                           height: shadowOffsetHeight ?? 0)
        button.isEnabled = isEnabled ?? true
        button.tag = tag ?? 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
// MARK: - Setup label
extension ResultsViewController {
    private func setLabel(title: String,
                          size: CGFloat,
                          style: String,
                          color: UIColor,
                          backgroundColor: UIColor? = nil,
                          radiusCorner: CGFloat? = nil,
                          colorOfShadow: CGColor? = nil,
                          radiusOfShadow: CGFloat? = nil,
                          shadowOffsetWidth: CGFloat? = nil,
                          shadowOffsetHeight: CGFloat? = nil,
                          numberOfLines: Int? = nil,
                          textAlignment: NSTextAlignment? = nil,
                          opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: style, size: size)
        label.textColor = color
        label.backgroundColor = backgroundColor ?? .clear
        label.layer.cornerRadius = radiusCorner ?? 0
        label.layer.shadowColor = colorOfShadow
        label.layer.shadowRadius = radiusOfShadow ?? 0
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                          height: shadowOffsetHeight ?? 0)
        label.numberOfLines = numberOfLines ?? 0
        label.textAlignment = textAlignment ?? .natural
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }
}
