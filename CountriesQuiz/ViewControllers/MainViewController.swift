//
//  ViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 01.12.2022.
//

import UIKit
// MARK: - Delegate rewrite user defaults
protocol RewriteSettingDelegate {
    func rewriteSetting(setting: Setting)
}

class MainViewController: UIViewController {
    // MARK: - Private properties
    private lazy var labelMainCountries: UILabel = {
        let label = setLabel(
            title: "Countries",
            size: 55,
            style: "echorevival",
            color: UIColor(
                red: 184/255,
                green: 227/255,
                blue: 252/255,
                alpha: 1
            ),
            colorOfShadow: CGColor(
                red: 10/255,
                green: 10/255,
                blue: 10/255,
                alpha: 1
            ),
            radiusOfShadow: 4,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return label
    }()
    
    private lazy var labelMainQuiz: UILabel = {
        let label = setLabel(
            title: "Quiz",
            size: 50,
            style: "echorevival",
            color: UIColor(
                red: 184/255,
                green: 227/255,
                blue: 252/255,
                alpha: 1
            ),
            colorOfShadow: CGColor(
                red: 10/255,
                green: 10/255,
                blue: 10/255,
                alpha: 1
            ),
            radiusOfShadow: 4,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return label
    }()
    
    private var imageMain: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Worldmap")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var buttonQuizOfFlags: UIButton = {
        let button = setButton(title: "Quiz of flags",
                               size: 22,
                               colorTitle: UIColor(
                                red: 184/255,
                                green: 247/255,
                                blue: 252/255,
                                alpha: 1
                               ),
                               colorBackgroud: UIColor(
                                red: 125/255,
                                green: 222/255,
                                blue: 255/255,
                                alpha: 0.15
                               ),
                               radiusCorner: 10,
                               borderWidth: 3,
                               borderColor: UIColor(
                                red: 184/255,
                                green: 247/255,
                                blue: 252/255,
                                alpha: 1).cgColor,
                               shadowColor: UIColor(
                                red: 54/255,
                                green: 55/255,
                                blue: 252/255,
                                alpha: 1
                               ).cgColor,
                               radiusShadow: 3,
                               shadowOffsetWidth: 2,
                               shadowOffsetHeight: 2
        )
        button.addTarget(self, action: #selector(startQuizOfFlags), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonSetting: UIButton = {
        let button = setButton(title: "Setting",
                               size: 22,
                               colorTitle: UIColor(
                                red: 184/255,
                                green: 247/255,
                                blue: 252/255,
                                alpha: 1
                               ),
                               colorBackgroud: UIColor(
                                red: 125/255,
                                green: 222/255,
                                blue: 255/255,
                                alpha: 0.15
                               ),
                               radiusCorner: 10,
                               borderWidth: 3,
                               borderColor: UIColor(
                                red: 184/255,
                                green: 247/255,
                                blue: 252/255,
                                alpha: 1).cgColor,
                               shadowColor: UIColor(
                                red: 54/255,
                                green: 55/255,
                                blue: 252/255,
                                alpha: 1
                               ).cgColor,
                               radiusShadow: 3,
                               shadowOffsetWidth: 2,
                               shadowOffsetHeight: 2
        )
        button.addTarget(self, action: #selector(setting), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageQuestionmark: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "questionmark.square.dashed")
        image.tintColor = UIColor(
            red: 184/255,
            green: 247/255,
            blue: 252/255,
            alpha: 1
        )
        image.frame = CGRect(x: 180, y: 350, width: 75, height: 55)
        image.transform = image.transform.rotated(by: .pi / -9)
        image.layer.shadowColor = CGColor(
            red: 54/255,
            green: 55/255,
            blue: 252/255,
            alpha: 1
        )
        image.layer.shadowRadius = 2.5
        image.layer.shadowOpacity = 1
        image.layer.shadowOffset = CGSize(width: 0, height: 2)
        return image
    }()
    
    private lazy var imageFilemenu: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "filemenu.and.selection")
        image.tintColor = UIColor(
            red: 184/255,
            green: 247/255,
            blue: 252/255,
            alpha: 1
        )
        image.frame = CGRect(x: 138, y: 350, width: 75, height: 55)
        image.transform = image.transform.rotated(by: .pi / -9)
        image.layer.shadowColor = CGColor(
            red: 54/255,
            green: 55/255,
            blue: 252/255,
            alpha: 1
        )
        image.layer.shadowRadius = 2.5
        image.layer.shadowOpacity = 1
        image.layer.shadowOffset = CGSize(width: 0, height: 2)
        return image
    }()
    
    private lazy var labelQuizOfFlags: UILabel = {
        let label = setLabel(
            title: "Quiz of flags",
            size: 16,
            style: "Apple SD Gothic Neo",
            color: UIColor(
                red: 184/255,
                green: 227/255,
                blue: 252/255,
                alpha: 1
            )
        )
        return label
    }()
    
    private var settingDefault = StorageManager.shared.fetchSetting()
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setupSubviews(subviews: imageMain,
                      labelMainCountries,
                      labelMainQuiz,
                      buttonQuizOfFlags,
                      buttonSetting
        )
        setConstraints()
    }
    // MARK: - Private methods
    private func setupMenu() {
        
    }
    
    private func setupSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    // MARK: - Set constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageMain.topAnchor.constraint(equalTo: view.topAnchor),
            imageMain.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageMain.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageMain.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelMainCountries.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelMainCountries.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            labelMainCountries.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            labelMainQuiz.topAnchor.constraint(equalTo: labelMainCountries.topAnchor, constant: 45),
            labelMainQuiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 220),
            labelMainQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            buttonQuizOfFlags.topAnchor.constraint(equalTo: labelMainQuiz.topAnchor, constant: 150),
            buttonQuizOfFlags.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonQuizOfFlags.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            buttonSetting.topAnchor.constraint(equalTo: buttonQuizOfFlags.topAnchor, constant: 48),
            buttonSetting.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonSetting.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func startQuizOfFlags() {
        
    }
    
    @objc private func setting() {
        let settingVC = SettingViewController()
        settingVC.modalPresentationStyle = .fullScreen
        settingVC.settingDefault = settingDefault
        settingVC.delegate = self
        present(settingVC, animated: true)
    }
}
// MARK: - Setup label
extension MainViewController {
    private func setLabel(title: String,
                          size: CGFloat,
                          style: String,
                          color: UIColor,
                          colorOfShadow: CGColor? = nil,
                          radiusOfShadow: CGFloat? = nil,
                          shadowOffsetWidth: CGFloat? = nil,
                          shadowOffsetHeight: CGFloat? = nil) -> UILabel {
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup button
extension MainViewController {
    private func setButton(title: String,
                           size: CGFloat,
                           colorTitle: UIColor? = nil,
                           colorBackgroud: UIColor? = nil,
                           radiusCorner: CGFloat,
                           borderWidth: CGFloat? = nil,
                           borderColor: CGColor? = nil,
                           shadowColor: CGColor? = nil,
                           radiusShadow: CGFloat? = nil,
                           shadowOffsetWidth: CGFloat? = nil,
                           shadowOffsetHeight: CGFloat? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        button.setTitleColor(colorTitle, for: .normal)
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

extension MainViewController: RewriteSettingDelegate {
    func rewriteSetting(setting: Setting) {
        StorageManager.shared.rewriteSetting(setting: setting)
    }
}
