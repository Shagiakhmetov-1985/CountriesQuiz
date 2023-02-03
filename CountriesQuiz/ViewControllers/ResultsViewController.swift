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
    
    private lazy var labelButtonFirst: UIView = {
        let view = setViewForLabel()
        
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
        
        view.addSubview(label)
        
        setConstraintsForLabel(label: label, view: view)
        return view
    }()
    
    private lazy var labelButtonSecond: UIView = {
        let view = setViewForLabel()
        
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
        
        view.addSubview(label)
        
        setConstraintsForLabel(label: label, view: view)
        return view
    }()
    
    private lazy var labelButtonThird: UIView = {
        let view = setViewForLabel()
        
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
        
        view.addSubview(label)
        
        setConstraintsForLabel(label: label, view: view)
        return view
    }()
    
    private lazy var labelButtonFourth: UIView = {
        let view = setViewForLabel()
        
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
        
        view.addSubview(label)
        
        setConstraintsForLabel(label: label, view: view)
        return view
    }()
    
    private lazy var labelTimeUp: UILabel = {
        let label = setLabel(
            title: "Время вышло!",
            size: 20,
            style: "mr_fontick",
            color: UIColor(
                red: 255/255,
                green: 102/255,
                blue: 102/255,
                alpha: 1),
            colorOfShadow: UIColor(
                red: 113/255,
                green: 0,
                blue: 0,
                alpha: 1).cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            textAlignment: .center)
        return label
    }()
    
    var results: [Results]!
    var countries: [Countries]!
    
    private var views: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingVC()
        setupSubviews(subviews: viewPanel,
                      buttonBackMenu,
                      contentView)
        checkResults()
        setConstraints()
        setConstraintsForView()
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
    
    private func setupSubviewsOnScrollView(subviews: UIView...) {
        subviews.forEach { subview in
            scrollView.addSubview(subview)
        }
    }
    
    private func setupSubviewsOnView(view: UIView, subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func checkResults() {
        switch results.count {
        case 0:
            print("all correct answers")
        case ..<3:
            print("less than 3 wrong answers")
            lessThanThreeWrongAnswers()
        default:
            print("more than 2 wrong answers")
        }
    }
    
    private func lessThanThreeWrongAnswers() {
        results.forEach { result in
            let view = setViewForResults()
            
            let label = setLabelForResults(text: result.currentQuestion)
            
            let imageFlag = setImageFlagForResults(imageFlag: result.question.flag)
            
            let buttonFirst = setButtonForResults(text: result.buttonFirst.name)
            let buttonSecond = setButtonForResults(text: result.buttonSecond.name)
            let buttonThird = setButtonForResults(text: result.buttonThird.name)
            let buttonFourth = setButtonForResults(text: result.buttonFourth.name)
            
            setupSubviewsOnView(view: view, subviews: label, imageFlag, buttonFirst,
                                buttonSecond, buttonThird, buttonFourth)
            
            setConstraintsOnView(view: view, label: label, imageFlag: imageFlag,
                                 buttonFirst: buttonFirst, buttonSecond: buttonSecond,
                                 buttonThird: buttonThird, buttonFourth: buttonFourth)
            
            views.append(view)
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
        /*
        NSLayoutConstraint.activate([
            labelTimeUp.topAnchor.constraint(equalTo: labelButtonFourth.bottomAnchor, constant: 6),
            labelTimeUp.centerXAnchor.constraint(equalTo: miniViewController.centerXAnchor),
            labelTimeUp.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        */
    }
    
    private func setConstraintsForLabel(label: UILabel, view: UIView) {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setConstraintsOnView(
        view: UIView, label: UILabel, imageFlag: UIImageView, buttonFirst: UIView,
        buttonSecond: UIView, buttonThird: UIView, buttonFourth: UIView) {
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
            ])
            
            NSLayoutConstraint.activate([
                imageFlag.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
                imageFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageFlag.widthAnchor.constraint(equalToConstant: 180),
                imageFlag.heightAnchor.constraint(equalToConstant: 110)
            ])
            
            NSLayoutConstraint.activate([
                buttonFirst.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 16),
                buttonFirst.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonFirst.heightAnchor.constraint(equalToConstant: 22),
                buttonFirst.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                buttonFirst.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
            
            NSLayoutConstraint.activate([
                buttonSecond.topAnchor.constraint(equalTo: buttonFirst.bottomAnchor, constant: 6),
                buttonSecond.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonSecond.heightAnchor.constraint(equalToConstant: 22),
                buttonSecond.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                buttonSecond.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
            
            NSLayoutConstraint.activate([
                buttonThird.topAnchor.constraint(equalTo: buttonSecond.bottomAnchor, constant: 6),
                buttonThird.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonThird.heightAnchor.constraint(equalToConstant: 22),
                buttonThird.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                buttonThird.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
            
            NSLayoutConstraint.activate([
                buttonFourth.topAnchor.constraint(equalTo: buttonThird.bottomAnchor, constant: 6),
                buttonFourth.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonFourth.heightAnchor.constraint(equalToConstant: 22),
                buttonFourth.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                buttonFourth.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
    }
    
    private func setConstraintsForView() {
        if views.isEmpty {
            print("Все вопросы отвечены правильно!")
        } else {
            setupSubviewsOnContentView(subviews: scrollView)
            var height: CGFloat = 0
            var multiplier: CGFloat = 1
            views.forEach { subview in
                setupSubviewsOnScrollView(subviews: subview)
                let constraint = 30 * multiplier + setupHeightConstraint() * height
                
                NSLayoutConstraint.activate([
                    subview.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: constraint),
                    subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    subview.widthAnchor.constraint(equalToConstant: setupWidthConstraint()),
                    subview.heightAnchor.constraint(equalToConstant: setupHeightConstraint())
                ])
                
                height += 1
                multiplier += 1
            }
        }
    }
    
    private func fixConstraintsForViewPanelBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 110 : 70
    }
    
    private func fixConstraintsForButtonBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 60 : 30
    }
    
    private func setupWidthConstraint() -> CGFloat {
        view.frame.width - 60
    }
    
    private func setupHeightConstraint() -> CGFloat {
        315
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
    
    private func setViewForResults() -> UIView {
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
    }
    
    private func setButtonForResults(text: String) -> UIView {
        let view = setViewForLabel()
        
        let label = setLabel(
            title: text,
            size: 15,
            style: "mr_fontick",
            color: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 252/255,
                alpha: 1),
            textAlignment: .center)
        
        view.addSubview(label)
        
        setConstraintsForLabel(label: label, view: view)
        return view
    }
    
    private func setViewForLabel() -> UIView {
        let view = setView(
            color: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1),
            cornerRadius: 5,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1),
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            tag: 1)
        return view
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
        label.layer.shadowColor = colorOfShadow
        label.layer.shadowRadius = radiusOfShadow ?? 0
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                          height: shadowOffsetHeight ?? 0)
        label.numberOfLines = numberOfLines ?? 0
        label.textAlignment = textAlignment ?? .natural
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setLabelForResults(text: Int) -> UILabel {
        let label = setLabel(
            title: "Вопрос \(text) из \(countries.count)",
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
    }
}
// MARK: - Setup image flag
extension ResultsViewController {
    private func setImageFlagForResults(imageFlag: String) -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: imageFlag)
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor(
            red: 54/255,
            green: 55/255,
            blue: 215/255,
            alpha: 1).cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
}
