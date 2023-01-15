//
//  QuizOfFlagsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 09.01.2023.
//

import UIKit

class QuizOfFlagsViewController: UIViewController {
    // MARK: - Setup subviews
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
    
    private lazy var progressView: UIProgressView = {
        let progressView = setProgressView(
            radius: 7,
            progressColor: UIColor(
                red: 51/255,
                green: 81/255,
                blue: 204/255,
                alpha: 1
            ),
            trackColor: UIColor(
                red: 51/255,
                green: 81/255,
                blue: 204/255,
                alpha: 0.3
            ),
            borderWidth: 2.5,
            borderColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            progress: 0.9
        )
        return progressView
    }()
    
    private lazy var labelTimer: UILabel = {
        let label = setLabel(
            title: "0",
            size: 20,
            style: "mr_fontick",
            color: .black,
            colorOfShadow: UIColor.white.cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 0.3,
            shadowOffsetHeight: 0.3
        )
        return label
    }()
    
    private lazy var labelQuiz: UILabel = {
        let label = setLabel(
            title: "Флаг страны?",
            size: 30,
            style: "mr_fontick",
            color: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            colorOfShadow: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ).cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return label
    }()
    
    private lazy var imageFlag: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "afghanistan")
        image.clipsToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor(
            red: 153/255,
            green: 204/255,
            blue: 255/255,
            alpha: 1
        ).cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var labelNumberQuiz: UILabel = {
        let label = setLabel(
            title: "Вопрос 1 из 20",
            size: 30,
            style: "mr_fontick",
            color: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            colorOfShadow: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ).cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return label
    }()
    
    private lazy var buttonAnswerFirst: UIButton = {
        let button = setButton(
            title: "Ответ 1",
            style: "mr_fontick",
            size: 18,
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
            radiusCorner: 16,
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
        button.addTarget(self, action: #selector(firstButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonAnswerSecond: UIButton = {
        let button = setButton(
            title: "Ответ 2",
            style: "mr_fontick",
            size: 18,
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
            radiusCorner: 16,
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
        return button
    }()
    
    private lazy var buttonAnswerThird: UIButton = {
        let button = setButton(
            title: "Ответ 3",
            style: "mr_fontick",
            size: 18,
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
            radiusCorner: 16,
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
        return button
    }()
    
    private lazy var buttonAnswerFourth: UIButton = {
        let button = setButton(
            title: "Ответ 4",
            style: "mr_fontick",
            size: 18,
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
            radiusCorner: 16,
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
        return button
    }()
    
    private var imageFlagSpring: NSLayoutConstraint!
    private var buttonFirstSpring: NSLayoutConstraint!
    private var buttonSecondSpring: NSLayoutConstraint!
    private var buttonThirdSpring: NSLayoutConstraint!
    private var buttonFourthSpring: NSLayoutConstraint!
    
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuizOfFlagsVC()
        setupSubviews(subviews: viewPanel,
                      buttonBackMenu,
                      contentView,
                      progressView,
                      labelTimer,
                      labelQuiz,
                      imageFlag,
                      labelNumberQuiz,
                      buttonAnswerFirst,
                      buttonAnswerSecond,
                      buttonAnswerThird,
                      buttonAnswerFourth
        )
        setConstraints()
        setupHideSubviews()
        hideSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startGame()
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
    
    private func setupHideSubviews() {
        imageFlagSpring.constant += view.bounds.width
        buttonFirstSpring.constant += view.bounds.width
        buttonSecondSpring.constant += view.bounds.width
        buttonThirdSpring.constant += view.bounds.width
        buttonFourthSpring.constant += view.bounds.width
    }
    
    private func hideSubviews() {
        imageFlag.isHidden = true
        buttonAnswerFirst.isHidden = true
        buttonAnswerSecond.isHidden = true
        buttonAnswerThird.isHidden = true
        buttonAnswerFourth.isHidden = true
    }
    
    private func startGame() {
        timer = Timer.scheduledTimer(
            timeInterval: 1, target: self, selector: #selector(showSubviews),
            userInfo: nil, repeats: false)
    }
    
    @objc private func showSubviews() {
        timer.invalidate()
        
        imageFlag.isHidden = false
        buttonAnswerFirst.isHidden = false
        buttonAnswerSecond.isHidden = false
        buttonAnswerThird.isHidden = false
        buttonAnswerFourth.isHidden = false
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            self.imageFlagSpring.constant -= self.view.bounds.width
            self.buttonFirstSpring.constant -= self.view.bounds.width
            self.buttonSecondSpring.constant -= self.view.bounds.width
            self.buttonThirdSpring.constant -= self.view.bounds.width
            self.buttonFourthSpring.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
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
            buttonBackMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonBackMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -245)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: viewPanel.bottomAnchor, constant: 1),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: viewPanel.bottomAnchor, constant: 26),
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.widthAnchor.constraint(equalToConstant: setupWidthConstraint()),
            progressView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: progressView.topAnchor, constant: 4),
            labelTimer.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            labelQuiz.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 30),
            labelQuiz.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 30),
            imageFlag.widthAnchor.constraint(equalToConstant: 300),
            imageFlag.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            labelNumberQuiz.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 30),
            labelNumberQuiz.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        buttonFirstSpring = NSLayoutConstraint(
            item: buttonAnswerFirst, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(buttonFirstSpring)
        NSLayoutConstraint.activate([
            buttonAnswerFirst.topAnchor.constraint(equalTo: labelNumberQuiz.bottomAnchor, constant: 30),
            buttonAnswerFirst.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        
        buttonSecondSpring = NSLayoutConstraint(
            item: buttonAnswerSecond, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(buttonSecondSpring)
        NSLayoutConstraint.activate([
            buttonAnswerSecond.topAnchor.constraint(equalTo: buttonAnswerFirst.bottomAnchor, constant: 8),
            buttonAnswerSecond.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        
        buttonThirdSpring = NSLayoutConstraint(
            item: buttonAnswerThird, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(buttonThirdSpring)
        NSLayoutConstraint.activate([
            buttonAnswerThird.topAnchor.constraint(equalTo: buttonAnswerSecond.bottomAnchor, constant: 8),
            buttonAnswerThird.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        
        buttonFourthSpring = NSLayoutConstraint(
            item: buttonAnswerFourth, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(buttonFourthSpring)
        NSLayoutConstraint.activate([
            buttonAnswerFourth.topAnchor.constraint(equalTo: buttonAnswerThird.bottomAnchor, constant: 8),
            buttonAnswerFourth.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
    }
    
    private func setupWidthConstraint() -> CGFloat {
        view.bounds.width - 40
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
    
    @objc private func firstButtonPress() {
        
    }
}
// MARK: - Setup view
extension QuizOfFlagsViewController {
    private func setView(color: UIColor? = nil, cornerRadius: CGFloat? = nil,
                         borderWidth: CGFloat? = nil, borderColor: UIColor? = nil,
                         shadowColor: UIColor? = nil, shadowRadius: CGFloat? = nil,
                         shadowOffsetWidth: CGFloat? = nil,
                         shadowOffsetHeight: CGFloat? = nil) -> UIView {
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
// MARK: - Setup label
extension QuizOfFlagsViewController {
    private func setLabel(title: String,
                          size: CGFloat,
                          style: String,
                          color: UIColor,
                          colorOfShadow: CGColor? = nil,
                          radiusOfShadow: CGFloat? = nil,
                          shadowOffsetWidth: CGFloat? = nil,
                          shadowOffsetHeight: CGFloat? = nil,
                          numberOfLines: Int? = nil,
                          textAlignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: style, size: size)
        label.textColor = color
        label.layer.shadowColor = colorOfShadow
        label.layer.shadowRadius = radiusOfShadow ?? 0
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                          height: shadowOffsetHeight ?? 0
        )
        label.numberOfLines = numberOfLines ?? 0
        label.textAlignment = textAlignment ?? .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup progress view
extension QuizOfFlagsViewController {
    private func setProgressView(radius: CGFloat, progressColor: UIColor,
                                 trackColor: UIColor, borderWidth: CGFloat,
                                 borderColor: UIColor, progress: Float) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = radius
        progressView.clipsToBounds = true
        progressView.progressTintColor = progressColor
        progressView.trackTintColor = trackColor
        progressView.layer.borderWidth = borderWidth
        progressView.layer.borderColor = borderColor.cgColor
        progressView.progress = progress
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
}
