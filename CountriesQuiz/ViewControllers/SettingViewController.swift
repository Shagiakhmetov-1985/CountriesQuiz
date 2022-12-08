//
//  SettingViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.12.2022.
//

import UIKit

class SettingViewController: UIViewController {
    // MARK: - Private properties
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
        button.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = setView()
        view.frame.size = contentSize
        return view
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 500)
    }
    
    private lazy var labelNumberQuestions: UILabel = {
        let label = setLabel(
            title: "Количество вопросов:",
            size: 28,
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
            shadowOffsetHeight: 2,
            numberOfLines: 1
        )
        return label
    }()
    
    private lazy var labelNumber: UILabel = {
        let label = setLabel(
            title: "20",
            size: 28,
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
    
    private lazy var stackViewNumberQuestion: UIStackView = {
        let stackView = setStackViewLabels(autoresizingConstraints: false,
                                           labelFirst: labelNumberQuestions,
                                           labelSecond: labelNumber)
        return stackView
    }()
    
    private lazy var pickerViewNumberQuestion: UIPickerView = {
        let pickerView = setPickerView(
            backgroundColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            cornerRadius: 13
        )
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var labelAllCountries: UILabel = {
        let label = setLabel(
            title: """
            Все страны мира
            Количество стран: 245
            """,
            size: 26,
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
    
    private lazy var toggleAllCountries: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ),
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return toggle
    }()
    
    private lazy var stackViewAllCountries: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelAllCountries,
                                     toggle: toggleAllCountries
        )
        return stackView
    }()
    
    private lazy var labelAmericaContinent: UILabel = {
        let label = setLabel(
            title: """
            Континент Америки
            Количество стран: 55
            """,
            size: 26,
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
    
    private lazy var toggleAmericaContinent: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ),
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return toggle
    }()
    
    private lazy var stackViewAmericaContinent: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelAmericaContinent,
                                     toggle: toggleAmericaContinent
        )
        return stackView
    }()
    
    private lazy var labelEuropeContinent: UILabel = {
        let label = setLabel(
            title: """
            Континент Европы
            Количество стран: 51
            """,
            size: 26,
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
    
    private lazy var toggleEuropeContinent: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ),
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return toggle
    }()
    
    private lazy var stackViewEuropeContinent: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelEuropeContinent,
                                     toggle: toggleEuropeContinent
        )
        return stackView
    }()
    
    private lazy var labelAfricaContinent: UILabel = {
        let label = setLabel(
            title: """
            Континент Африки
            Количество стран: 59
            """,
            size: 26,
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
    
    private lazy var toggleAfricaContinent: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ),
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return toggle
    }()
    
    private lazy var stackViewAfricaContinent: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelAfricaContinent,
                                     toggle: toggleAfricaContinent
        )
        return stackView
    }()
    
    private lazy var labelAsiaContinent: UILabel = {
        let label = setLabel(
            title: """
            Континент Азии
            Количество стран: 54
            """,
            size: 26,
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
    
    private lazy var toggleAsiaContinent: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ),
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return toggle
    }()
    
    private lazy var stackViewAsiaContinent: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelAsiaContinent,
                                     toggle: toggleAsiaContinent
        )
        return stackView
    }()
    
    private lazy var labelOceaniaContinent: UILabel = {
        let label = setLabel(
            title: """
            Континент Океании
            Количество стран: 26
            """,
            size: 26,
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
    
    private lazy var toggleOceaniaContinent: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1
            ),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ),
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1
            ).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return toggle
    }()
    
    private lazy var stackViewOceaniaContinent: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelOceaniaContinent,
                                     toggle: toggleOceaniaContinent
        )
        return stackView
    }()
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingVC()
        setupSubviews(subviews: viewPanel,
                      buttonBackMenu,
                      contentView
        )
        setupSubviewsOnContentView(subviews: scrollView)
        setupSubviewsOnScrollView(subviews: stackViewNumberQuestion,
                                  pickerViewNumberQuestion,
                                  stackViewAllCountries,
                                  stackViewAmericaContinent,
                                  stackViewEuropeContinent,
                                  stackViewAfricaContinent,
                                  stackViewAsiaContinent,
                                  stackViewOceaniaContinent
        )
        setConstraints()
    }
    // MARK: - Private methods
    private func setupSettingVC() {
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
    // MARK: - Setup constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            viewPanel.topAnchor.constraint(equalTo: view.topAnchor),
            viewPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewPanel.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            buttonBackMenu.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
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
            stackViewNumberQuestion.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 14),
            stackViewNumberQuestion.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewNumberQuestion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            pickerViewNumberQuestion.topAnchor.constraint(equalTo: stackViewNumberQuestion.bottomAnchor, constant: 12),
            pickerViewNumberQuestion.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pickerViewNumberQuestion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pickerViewNumberQuestion.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        NSLayoutConstraint.activate([
            stackViewAllCountries.topAnchor.constraint(equalTo: pickerViewNumberQuestion.bottomAnchor, constant: 15),
            stackViewAllCountries.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewAllCountries.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackViewAmericaContinent.topAnchor.constraint(equalTo: stackViewAllCountries.bottomAnchor, constant: 15),
            stackViewAmericaContinent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewAmericaContinent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackViewEuropeContinent.topAnchor.constraint(equalTo: stackViewAmericaContinent.bottomAnchor, constant: 15),
            stackViewEuropeContinent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewEuropeContinent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackViewAfricaContinent.topAnchor.constraint(equalTo: stackViewEuropeContinent.bottomAnchor, constant: 15),
            stackViewAfricaContinent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewAfricaContinent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackViewAsiaContinent.topAnchor.constraint(equalTo: stackViewAfricaContinent.bottomAnchor, constant: 15),
            stackViewAsiaContinent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewAsiaContinent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackViewOceaniaContinent.topAnchor.constraint(equalTo: stackViewAsiaContinent.bottomAnchor, constant: 15),
            stackViewOceaniaContinent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewOceaniaContinent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func backToMenu() {
        dismiss(animated: true)
    }
}
// MARK: - Setup view
extension SettingViewController {
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
extension SettingViewController {
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
                           shadowOffsetHeight: CGFloat? = nil) -> UIButton {
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
// MARK: - Setup label
extension SettingViewController {
    private func setLabel(title: String,
                          size: CGFloat,
                          style: String,
                          color: UIColor,
                          colorOfShadow: CGColor? = nil,
                          radiusOfShadow: CGFloat? = nil,
                          shadowOffsetWidth: CGFloat? = nil,
                          shadowOffsetHeight: CGFloat? = nil,
                          numberOfLines: Int? = nil) -> UILabel {
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup picker view
extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        91
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        let title = "\(row + 10)"
        let attributed = NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "mr_fontick", size: 28) ?? "",
            .foregroundColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 252/255,
                alpha: 1)
        ])
        label.attributedText = attributed
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelNumber.text = "\(row + 10)"
    }
    
    private func setPickerView(backgroundColor: UIColor,
                               cornerRadius: CGFloat) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = backgroundColor
        pickerView.layer.cornerRadius = cornerRadius
        return pickerView
    }
}
// MARK: - Setup toggle
extension SettingViewController {
    private func setToggle(toggleColor: UIColor,
                           onColor: UIColor,
                           shadowColor: CGColor? = nil,
                           shadowRadius: CGFloat? = nil,
                           shadowOffsetWidth: CGFloat? = nil,
                           shadowOffsetHeight: CGFloat? = nil) -> UISwitch {
        let toggle = UISwitch()
        toggle.thumbTintColor = toggleColor
        toggle.onTintColor = onColor
        toggle.layer.shadowColor = shadowColor
        toggle.layer.shadowRadius = shadowRadius ?? 0
        toggle.layer.shadowOpacity = 1
        toggle.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                           height: shadowOffsetHeight ?? 0
        )
        return toggle
    }
}
// MARK: - Setup stack view
extension SettingViewController {
    private func setStackViewLabels(autoresizingConstraints: Bool,
                                    labelFirst: UILabel,
                                    labelSecond: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [labelFirst, labelSecond])
        stackView.translatesAutoresizingMaskIntoConstraints = autoresizingConstraints
        stackView.spacing = view.frame.width - (view.frame.width - 29)
        return stackView
    }
    
    private func setStackView(autoresizingConstraints: Bool,
                              label: UILabel,
                              toggle: UISwitch) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [label, toggle])
        stackView.translatesAutoresizingMaskIntoConstraints = autoresizingConstraints
        stackView.alignment = .center
        return stackView
    }
}
