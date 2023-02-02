//
//  SettingViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.12.2022.
//

import UIKit

class SettingViewController: UIViewController {
    // MARK: - Subviews
    private lazy var viewPanel: UIView = {
        let view = setView(
            color: UIColor(
                red: 102/255,
                green: 153/255,
                blue: 255/255,
                alpha: 1))
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
                alpha: 1),
            colorBackgroud: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1),
            radiusCorner: 14,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1).cgColor,
            radiusShadow: 2.5,
            shadowOffsetWidth: 2.5,
            shadowOffsetHeight: 2.5)
        button.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonDefaultSetting: UIButton = {
        let lightBlue = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
        let blue = UIColor(red: 54/255, green: 55/255, blue: 252/255, alpha: 1)
        let darkBlue = UIColor(red: 54/255, green: 55/255, blue: 215/255, alpha: 1)
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        let darkGray = UIColor(red: 72/255, green: 72/255, blue: 72/255, alpha: 1)
        let button = setButton(
            title: "Сброс",
            style: "mr_fontick",
            size: 15,
            colorTitle: conditions() ? blue : gray,
            colorBackgroud: conditions() ? lightBlue : lightGray,
            radiusCorner: 14,
            shadowColor: conditions() ? darkBlue.cgColor : darkGray.cgColor,
            radiusShadow: 2.5,
            shadowOffsetWidth: 2.5,
            shadowOffsetHeight: 2.5,
            isEnabled: conditions() ? true : false)
        button.addTarget(self, action: #selector(defaultSetting), for: .touchUpInside)
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
        CGSize(width: view.frame.width, height: view.frame.height + fixSizeForContentViewBySizeIphone())
    }
    
    private lazy var labelNumberQuestions: UILabel = {
        let label = setLabel(
            title: "Количество вопросов:",
            size: 26,
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
            numberOfLines: 1,
            textAlignment: .right)
        return label
    }()
    
    private lazy var labelNumber: UILabel = {
        let label = setLabel(
            title: "\(settingDefault.countQuestions)",
            size: 26,
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
                alpha: 1),
            cornerRadius: 13,
            tag: 1,
            isEnabled: true)
        return pickerView
    }()
    
    private lazy var labelAllCountries: UILabel = {
        let label = setLabel(
            title: """
            Все страны мира
            Количество стран: \(FlagsOfCountries.shared.countries.count)
            """,
            size: 26,
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
            shadowOffsetHeight: 2)
        return label
    }()
    
    private lazy var toggleAllCountries: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1),
            isOn: settingDefault.allCountries,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        return toggle
    }()
    
    private lazy var stackViewAllCountries: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelAllCountries,
                                     toggle: toggleAllCountries)
        return stackView
    }()
    
    private lazy var labelAmericaContinent: UILabel = {
        let label = setLabel(
            title: """
            Континент Америки
            Количество стран: \(FlagsOfCountries.shared.countriesOfAmericanContinent.count)
            """,
            size: 26,
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
            shadowOffsetHeight: 2)
        return label
    }()
    
    private lazy var toggleAmericaContinent: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1),
            isOn: settingDefault.americaContinent,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        return toggle
    }()
    
    private lazy var stackViewAmericaContinent: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelAmericaContinent,
                                     toggle: toggleAmericaContinent)
        return stackView
    }()
    
    private lazy var labelEuropeContinent: UILabel = {
        let label = setLabel(
            title: """
            Континент Европы
            Количество стран: \(FlagsOfCountries.shared.countriesOfEuropeanContinent.count)
            """,
            size: 26,
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
            shadowOffsetHeight: 2)
        return label
    }()
    
    private lazy var toggleEuropeContinent: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1),
            isOn: settingDefault.europeContinent,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        return toggle
    }()
    
    private lazy var stackViewEuropeContinent: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelEuropeContinent,
                                     toggle: toggleEuropeContinent)
        return stackView
    }()
    
    private lazy var labelAfricaContinent: UILabel = {
        let label = setLabel(
            title: """
            Континент Африки
            Количество стран: \(FlagsOfCountries.shared.countriesOfAfricanContinent.count)
            """,
            size: 26,
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
            shadowOffsetHeight: 2)
        return label
    }()
    
    private lazy var toggleAfricaContinent: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1),
            isOn: settingDefault.africaContinent,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        return toggle
    }()
    
    private lazy var stackViewAfricaContinent: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelAfricaContinent,
                                     toggle: toggleAfricaContinent)
        return stackView
    }()
    
    private lazy var labelAsiaContinent: UILabel = {
        let label = setLabel(
            title: """
            Континент Азии
            Количество стран: \(FlagsOfCountries.shared.countriesOfAsianContinent.count)
            """,
            size: 26,
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
            shadowOffsetHeight: 2)
        return label
    }()
    
    private lazy var toggleAsiaContinent: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1),
            isOn: settingDefault.asiaContinent,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        return toggle
    }()
    
    private lazy var stackViewAsiaContinent: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelAsiaContinent,
                                     toggle: toggleAsiaContinent)
        return stackView
    }()
    
    private lazy var labelOceaniaContinent: UILabel = {
        let label = setLabel(
            title: """
            Континент Океании
            Количество стран: \(FlagsOfCountries.shared.countriesOfOceanContinent.count)
            """,
            size: 26,
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
            shadowOffsetHeight: 2)
        return label
    }()
    
    private lazy var toggleOceaniaContinent: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1),
            isOn: settingDefault.oceaniaContinent,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        return toggle
    }()
    
    private lazy var stackViewOceaniaContinent: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelOceaniaContinent,
                                     toggle: toggleOceaniaContinent)
        return stackView
    }()
    
    private lazy var labelTimeElapsed: UILabel = {
        let label = setLabel(
            title: "Обратный отсчет",
            size: 26,
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
            shadowOffsetHeight: 2)
        return label
    }()
    
    private lazy var toggleTimeElapsed: UISwitch = {
        let toggle = setToggle(
            toggleColor: UIColor(
                red: 153/255,
                green: 204/255,
                blue: 255/255,
                alpha: 1),
            onColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1),
            isOn: settingDefault.timeElapsed.timeElapsed,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1).cgColor,
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        return toggle
    }()
    
    private lazy var stackViewTimeElapsed: UIStackView = {
        let stackView = setStackView(autoresizingConstraints: false,
                                     label: labelTimeElapsed,
                                     toggle: toggleTimeElapsed)
        return stackView
    }()
    
    private lazy var labelTimeElapsedQuestion: UILabel = {
        let lightBlue = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
        let blue = UIColor(red: 54/255, green: 55/255, blue: 215/255, alpha: 1).cgColor
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        let label = setLabel(
            title: isEnabledText(),
            size: 26,
            style: "mr_fontick",
            color: settingDefault.timeElapsed.timeElapsed ? lightBlue : lightGray,
            colorOfShadow: settingDefault.timeElapsed.timeElapsed ? blue : gray,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            numberOfLines: 1,
            textAlignment: .right)
        return label
    }()
    
    private lazy var labelTimeElapsedNumber: UILabel = {
        let lightBlue = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
        let blue = UIColor(red: 54/255, green: 55/255, blue: 215/255, alpha: 1).cgColor
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        let label = setLabel(
            title: setLabelNumberQuestions(),
            size: 26,
            style: "mr_fontick",
            color: settingDefault.timeElapsed.timeElapsed ? lightBlue : lightGray,
            colorOfShadow: settingDefault.timeElapsed.timeElapsed ? blue : gray,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            textAlignment: .center)
        return label
    }()
    
    private lazy var stackViewLabelTimeElapsed: UIStackView = {
        let stackView = setStackViewLabels(autoresizingConstraints: false,
                                           labelFirst: labelTimeElapsedQuestion,
                                           labelSecond: labelTimeElapsedNumber)
        return stackView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let lightBlue = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
        let blue = UIColor(red: 54/255, green: 55/255, blue: 215/255, alpha: 1)
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        let segment = setSegmentedControl(
            background: settingDefault.timeElapsed.timeElapsed ? lightBlue : lightGray,
            segmentColor: settingDefault.timeElapsed.timeElapsed ? blue : gray,
            elements: ["Один вопрос", "Все вопросы"],
            titleSelectedColor: settingDefault.timeElapsed.timeElapsed ? lightBlue : lightGray,
            titleNormalColor: settingDefault.timeElapsed.timeElapsed ? blue : gray,
            setIndex: settingDefault.timeElapsed.questionSelect.oneQuestion ? 0 : 1,
            isEnabled: settingDefault.timeElapsed.timeElapsed ? true : false)
        return segment
    }()
    
    private lazy var pickerViewOneQuestion: UIPickerView = {
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        let pickerView = setPickerView(
            backgroundColor: settingDefault.timeElapsed.timeElapsed ? isEnabledColor(tag: 2) : lightGray,
            cornerRadius: 13,
            tag: 2,
            isEnabled: settingDefault.timeElapsed.timeElapsed ? isEnabled(tag: 2) : false)
        return pickerView
    }()
    
    private lazy var pickerViewAllQuestions: UIPickerView = {
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        let pickerView = setPickerView(
            backgroundColor: settingDefault.timeElapsed.timeElapsed ? isEnabledColor(tag: 3) : lightGray,
            cornerRadius: 13,
            tag: 3,
            isEnabled: settingDefault.timeElapsed.timeElapsed ? isEnabled(tag: 3) : false)
        return pickerView
    }()
    
    private lazy var stackViewPickerViews: UIStackView = {
        let stackView = setStackViewPickerViews(autoresizingConstraints: false,
                                                pickerViewFirst: pickerViewOneQuestion,
                                                pickerViewSecond: pickerViewAllQuestions)
        return stackView
    }()
    
    var settingDefault: Setting!
    var delegate: RewriteSettingDelegate!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingVC()
        setupSubviews(subviews: viewPanel,
                      buttonBackMenu,
                      buttonDefaultSetting,
                      contentView)
        setupSubviewsOnContentView(subviews: scrollView)
        setupSubviewsOnScrollView(subviews: stackViewNumberQuestion,
                                  pickerViewNumberQuestion,
                                  stackViewAllCountries,
                                  stackViewAmericaContinent,
                                  stackViewEuropeContinent,
                                  stackViewAfricaContinent,
                                  stackViewAsiaContinent,
                                  stackViewOceaniaContinent,
                                  stackViewTimeElapsed,
                                  stackViewLabelTimeElapsed,
                                  segmentedControl,
                                  stackViewPickerViews)
        setConstraints()
    }
    // MARK: - Private methods
    private func setupSettingVC() {
        view.backgroundColor = UIColor(
            red: 54/255,
            green: 55/255,
            blue: 215/255,
            alpha: 1)
        
        let countQuestion = settingDefault.countQuestions
        let currentRowCountQuestion = countQuestion - 10
        pickerViewNumberQuestion.selectRow(currentRowCountQuestion, inComponent: 0, animated: false)
        
        let currentRowOneQuestion = settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime - 6
        pickerViewOneQuestion.selectRow(currentRowOneQuestion, inComponent: 0, animated: false)
        
        let currentTimeAllQuestion = settingDefault.timeElapsed.questionSelect.questionTime.allQuestionsTime
        let currentRowAllQuestion = currentTimeAllQuestion - (4 * countQuestion)
        pickerViewAllQuestions.selectRow(currentRowAllQuestion, inComponent: 0, animated: false)
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
            viewPanel.heightAnchor.constraint(equalToConstant: fixConstraintsForViewPanelBySizeIphone())
        ])
        
        NSLayoutConstraint.activate([
            buttonBackMenu.topAnchor.constraint(equalTo: view.topAnchor, constant: fixConstraintsForButtonBySizeIphone()),
            buttonBackMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonBackMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -245)
        ])
        
        NSLayoutConstraint.activate([
            buttonDefaultSetting.topAnchor.constraint(equalTo: view.topAnchor, constant: fixConstraintsForButtonBySizeIphone()),
            buttonDefaultSetting.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 245),
            buttonDefaultSetting.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
            stackViewNumberQuestion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelNumber.widthAnchor.constraint(equalToConstant: 55)
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
        
        NSLayoutConstraint.activate([
            stackViewTimeElapsed.topAnchor.constraint(equalTo: stackViewOceaniaContinent.bottomAnchor, constant: 30),
            stackViewTimeElapsed.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewTimeElapsed.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackViewLabelTimeElapsed.topAnchor.constraint(equalTo: stackViewTimeElapsed.bottomAnchor, constant: 15),
            stackViewLabelTimeElapsed.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewLabelTimeElapsed.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelTimeElapsedQuestion.widthAnchor.constraint(equalToConstant: 285),
            labelTimeElapsedNumber.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: stackViewLabelTimeElapsed.bottomAnchor, constant: 15),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackViewPickerViews.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15),
            stackViewPickerViews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewPickerViews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pickerViewOneQuestion.widthAnchor.constraint(equalToConstant: 160),
            pickerViewOneQuestion.heightAnchor.constraint(equalToConstant: 110),
            pickerViewAllQuestions.widthAnchor.constraint(equalToConstant: 160),
            pickerViewAllQuestions.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    private func fixConstraintsForViewPanelBySizeIphone() -> CGFloat {
        return view.frame.height > 736 ? 110 : 70
    }
    
    private func fixSizeForContentViewBySizeIphone() -> CGFloat {
        return view.frame.height > 736 ? 140 : 280
    }
    
    private func fixConstraintsForButtonBySizeIphone() -> CGFloat {
        return view.frame.height > 736 ? 60 : 30
    }
    // MARK: - Activating buttons
    @objc private func backToMenu() {
        dismiss(animated: true)
    }
    
    @objc private func defaultSetting() {
        showAlert(setting: settingDefault)
    }
    
    private func buttonIsEnabled(isEnabled: Bool, titleColor: UIColor,
                                 backgroundColor: UIColor, shadowColor: CGColor) {
        buttonDefaultSetting.isEnabled = isEnabled
        buttonDefaultSetting.setTitleColor(titleColor, for: .normal)
        buttonDefaultSetting.backgroundColor = backgroundColor
        buttonDefaultSetting.layer.shadowColor = shadowColor
    }
    
    private func conditions() -> Bool {
        !settingDefault.allCountries && settingDefault.countQuestions > 50
    }
    // MARK: - Setting label of number questions
    private func setLabelNumberQuestions() -> String {
        let text: String
        if pickerViewOneQuestion.isUserInteractionEnabled {
            text = "\(settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime)"
        } else {
            text = "\(settingDefault.timeElapsed.questionSelect.questionTime.allQuestionsTime)"
        }
        return text
    }
    // MARK: - Setting of toggles
    @objc private func toggleAction(target: UISwitch) {
        switch target {
            
        case toggleAllCountries:
            
            if !toggleAmericaContinent.isOn, !toggleEuropeContinent.isOn, !toggleAfricaContinent.isOn,
               !toggleAsiaContinent.isOn, !toggleOceaniaContinent.isOn {
                toggleOn(toggles: toggleAllCountries)
            } else {
                toggleOff(toggles: toggleAmericaContinent, toggleEuropeContinent,
                          toggleAfricaContinent, toggleAsiaContinent, toggleOceaniaContinent)
            }
            
        case toggleAmericaContinent, toggleEuropeContinent, toggleAfricaContinent,
            toggleAsiaContinent, toggleOceaniaContinent:
            
            if toggleAmericaContinent.isOn, toggleEuropeContinent.isOn, toggleAfricaContinent.isOn,
               toggleAsiaContinent.isOn, toggleOceaniaContinent.isOn {
                toggleOff(toggles: toggleAmericaContinent, toggleEuropeContinent,
                          toggleAfricaContinent, toggleAsiaContinent, toggleOceaniaContinent)
                toggleOn(toggles: toggleAllCountries)
            } else if !toggleAllCountries.isOn, !toggleAmericaContinent.isOn, !toggleEuropeContinent.isOn,
                      !toggleAfricaContinent.isOn, !toggleAsiaContinent.isOn, !toggleOceaniaContinent.isOn {
                toggleOn(toggles: toggleAllCountries)
            } else {
                toggleOff(toggles: toggleAllCountries)
            }
            
        default:
            
            settingDefault.timeElapsed.timeElapsed = target.isOn ? true : false
            delegate.rewriteSetting(setting: settingDefault)
            
            let lightBlue = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
            let blue = UIColor(red: 54/255, green: 55/255, blue: 215/255, alpha: 1)
            let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
            let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
            let font = UIFont(name: "mr_fontick", size: 26)
            
            labelTimeElapsedQuestion.textColor = target.isOn ? lightBlue : lightGray
            labelTimeElapsedQuestion.layer.shadowColor = target.isOn ? blue.cgColor : gray.cgColor
            labelTimeElapsedNumber.textColor = target.isOn ? lightBlue : lightGray
            labelTimeElapsedNumber.layer.shadowColor = target.isOn ? blue.cgColor : gray.cgColor
            
            segmentedControl.isUserInteractionEnabled = target.isOn ? true : false
            segmentedControl.backgroundColor = target.isOn ? lightBlue : lightGray
            segmentedControl.selectedSegmentTintColor = target.isOn ? blue : gray
            
            let titleSelectedColor: UIColor = target.isOn ? lightBlue : lightGray
            segmentedControl.setTitleTextAttributes([
                NSAttributedString.Key
                    .font: font ?? "",
                    .foregroundColor: titleSelectedColor
            ], for: .selected)
            let titleNormalColor: UIColor = target.isOn ? blue : gray
            segmentedControl.setTitleTextAttributes([
                NSAttributedString.Key
                    .font: font ?? "",
                    .foregroundColor: titleNormalColor
            ], for: .normal)
            
            pickerViewOneQuestion.isUserInteractionEnabled = target.isOn ? isEnabled(tag: 2) : false
            pickerViewOneQuestion.backgroundColor = target.isOn ? isEnabledColor(tag: 2) : lightGray
            pickerViewOneQuestion.reloadAllComponents()
            pickerViewAllQuestions.isUserInteractionEnabled = target.isOn ? isEnabled(tag: 3) : false
            pickerViewAllQuestions.backgroundColor = target.isOn ? isEnabledColor(tag: 3) : lightGray
            pickerViewAllQuestions.reloadAllComponents()
            
        }
        
        toggleRewrite(allCountries: toggleAllCountries.isOn, americaContinent: toggleAmericaContinent.isOn,
                      europeContinent: toggleEuropeContinent.isOn, africaContinent: toggleAfricaContinent.isOn,
                      asiaContinent: toggleAsiaContinent.isOn, oceaniaContinent: toggleOceaniaContinent.isOn)
        setupRowsPickerView(allCountries: toggleAllCountries.isOn, americaContinent: toggleAmericaContinent.isOn,
                            europeContinent: toggleEuropeContinent.isOn, africaContinent: toggleAfricaContinent.isOn,
                            asiaContinent: toggleAsiaContinent.isOn, oceaniaContinent: toggleOceaniaContinent.isOn)
        
        let lightBlue = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
        let blue = UIColor(red: 54/255, green: 55/255, blue: 215/255, alpha: 1)
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        conditions() ?
        buttonIsEnabled(
            isEnabled: true,
            titleColor: blue,
            backgroundColor: lightBlue,
            shadowColor: blue.cgColor) :
        buttonIsEnabled(
            isEnabled: false,
            titleColor: gray,
            backgroundColor: lightGray,
            shadowColor: gray.cgColor)
    }
    
    private func toggleOff(toggles: UISwitch...) {
        toggles.forEach { toggle in
            toggle.setOn(false, animated: true)
        }
    }
    
    private func toggleOn(toggles: UISwitch...) {
        toggles.forEach { toggle in
            toggle.setOn(true, animated: true)
        }
    }
    
    private func toggleRewrite(allCountries: Bool,
                               americaContinent: Bool,
                               europeContinent: Bool,
                               africaContinent: Bool,
                               asiaContinent: Bool,
                               oceaniaContinent: Bool) {
        settingDefault.allCountries = allCountries
        settingDefault.americaContinent = americaContinent
        settingDefault.europeContinent = europeContinent
        settingDefault.africaContinent = africaContinent
        settingDefault.asiaContinent = asiaContinent
        settingDefault.oceaniaContinent = oceaniaContinent
        delegate.rewriteSetting(setting: settingDefault)
    }
    
    private func setupRowsPickerView(allCountries: Bool,
                                     americaContinent: Bool,
                                     europeContinent: Bool,
                                     africaContinent: Bool,
                                     asiaContinent: Bool,
                                     oceaniaContinent: Bool) {
        var countRows = checkAllCountries(toggle: allCountries) +
        checkAmericaContinent(toggle: americaContinent) +
        checkEuropeContinent(toggle: europeContinent) +
        checkAfricaContinent(toggle: africaContinent) +
        checkAsiaContinent(toggle: asiaContinent) +
        checkOceaniaContinent(toggle: oceaniaContinent) - 9
        
        if countRows > DefaultSetting.countRows.rawValue {
            countRows = DefaultSetting.countRows.rawValue
        }
        
        if countRows < settingDefault.countRows {
            let countQuestions = countRows + 9
            
            settingDefault.countRows = countRows
            pickerViewNumberQuestion.reloadAllComponents()
            pickerViewNumberQuestion.selectRow(countRows, inComponent: 0, animated: false)
            
            if countQuestions < settingDefault.countQuestions {
                let averageQuestionTime = 5 * countQuestions
                let currentRow = averageQuestionTime - (4 * countQuestions)
                
                setupDataFromPickerView(countQuestion: countQuestions,
                                        averageTime: averageQuestionTime,
                                        currentRow: currentRow)
                
            }
        } else {
            settingDefault.countRows = countRows
            pickerViewNumberQuestion.reloadAllComponents()
        }
        
        delegate.rewriteSetting(setting: settingDefault)
    }
    
    private func checkAllCountries(toggle: Bool) -> Int {
        toggle ? FlagsOfCountries.shared.countries.count : 0
    }
    
    private func checkAmericaContinent(toggle: Bool) -> Int {
        toggle ? FlagsOfCountries.shared.countriesOfAmericanContinent.count : 0
    }
    
    private func checkEuropeContinent(toggle: Bool) -> Int {
        toggle ? FlagsOfCountries.shared.countriesOfEuropeanContinent.count : 0
    }
    
    private func checkAfricaContinent(toggle: Bool) -> Int {
        toggle ? FlagsOfCountries.shared.countriesOfAfricanContinent.count : 0
    }
    
    private func checkAsiaContinent(toggle: Bool) -> Int {
        toggle ? FlagsOfCountries.shared.countriesOfAsianContinent.count : 0
    }
    
    private func checkOceaniaContinent(toggle: Bool) -> Int {
        toggle ? FlagsOfCountries.shared.countriesOfOceanContinent.count : 0
    }
    // MARK: - Setting of segmented control
    @objc private func segmentedControlAction() {
        let lightBlue = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let countQuestion = settingDefault.countQuestions
            let currentTime = settingDefault.timeElapsed.questionSelect.questionTime.allQuestionsTime
            let currentRow = currentTime - (4 * countQuestion)
            
            segmentAction(pickerView: pickerViewOneQuestion, isEnabled: true, backgroundColor: lightBlue)
            segmentAction(pickerView: pickerViewAllQuestions, isEnabled: false, backgroundColor: lightGray)
            
            setupDataFromSegmentedControl(
                currentRow: currentRow,
                pickerView: pickerViewAllQuestions,
                oneQuestion: true,
                timeElapsedQuestion: "Время одного вопроса:",
                timeElapsedNumber: "\(settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime)")
        } else {
            let currentTime = settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime
            let currentRow = currentTime - 6
            
            segmentAction(pickerView: pickerViewOneQuestion, isEnabled: false, backgroundColor: lightGray)
            segmentAction(pickerView: pickerViewAllQuestions, isEnabled: true, backgroundColor: lightBlue)
            
            setupDataFromSegmentedControl(
                currentRow: currentRow,
                pickerView: pickerViewOneQuestion,
                oneQuestion: false,
                timeElapsedQuestion: "Время всех вопросов:",
                timeElapsedNumber: "\(settingDefault.timeElapsed.questionSelect.questionTime.allQuestionsTime)")
        }
    }
    
    private func segmentAction(pickerView: UIPickerView,
                               isEnabled: Bool,
                               backgroundColor: UIColor) {
        pickerView.isUserInteractionEnabled = isEnabled
        pickerView.backgroundColor = backgroundColor
        pickerView.reloadAllComponents()
    }
    
    private func setupDataFromSegmentedControl(currentRow: Int,
                                               pickerView: UIPickerView,
                                               oneQuestion: Bool,
                                               timeElapsedQuestion: String,
                                               timeElapsedNumber: String) {
        pickerView.selectRow(currentRow, inComponent: 0, animated: false)
        
        settingDefault.timeElapsed.questionSelect.oneQuestion = oneQuestion
        
        labelTimeElapsedQuestion.text = timeElapsedQuestion
        labelTimeElapsedNumber.text = timeElapsedNumber
        
        delegate.rewriteSetting(setting: settingDefault)
    }
    // MARK: - Enabled or disabled picker view and color
    private func isEnabled(tag: Int) -> Bool {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if tag == 2 {
                return true
            } else {
                return false
            }
        default:
            if tag == 2 {
                return false
            } else {
                return true
            }
        }
    }
    
    private func isEnabledColor(tag: Int) -> UIColor {
        let lightBlue = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if tag == 2 {
                return lightBlue
            } else {
                return lightGray
            }
        default:
            if tag == 2 {
                return lightGray
            } else {
                return lightBlue
            }
        }
    }
    
    private func isEnabledTextColor(tag: Int) -> UIColor {
        let blue = UIColor(red: 54/255, green: 55/255, blue: 252/255, alpha: 1)
        let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if tag == 2 {
                return blue
            } else {
                return gray
            }
        default:
            if tag == 2 {
                return gray
            } else {
                return blue
            }
        }
    }
    
    private func isEnabledText() -> String {
        let text: String
        if segmentedControl.selectedSegmentIndex == 0 {
            text = "Время одного вопроса:"
        } else {
            text = "Время всех вопросов:"
        }
        return text
    }
    // MARK: - Reset setting default
    private func resetSetting() {
        settingDefault = Setting.getSettingDefault()
        
        let currentRowCountQuestion = settingDefault.countQuestions - 10
        let averageQuestionTime = 5 * settingDefault.countQuestions
        let currentRowTimeElapsedOneQuestion = settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime - 6
        let currentRowTimeElapsedAllQuestions = averageQuestionTime - (4 * settingDefault.countQuestions)
        
        labelNumber.text = "\(settingDefault.countQuestions)"
        labelTimeElapsedNumber.text = "\(settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime)"
        
        toggleOn(toggles: toggleAllCountries, toggleTimeElapsed)
        toggleOff(toggles: toggleAmericaContinent, toggleEuropeContinent,
                  toggleAfricaContinent, toggleAsiaContinent, toggleOceaniaContinent)
        
        segmentedControl.selectedSegmentIndex = 0
        
        pickerViewNumberQuestion.reloadAllComponents()
        pickerViewNumberQuestion.selectRow(currentRowCountQuestion, inComponent: 0, animated: false)
        pickerViewOneQuestion.reloadAllComponents()
        pickerViewOneQuestion.selectRow(currentRowTimeElapsedOneQuestion, inComponent: 0, animated: false)
        pickerViewAllQuestions.reloadAllComponents()
        pickerViewAllQuestions.selectRow(currentRowTimeElapsedAllQuestions, inComponent: 0, animated: false)
        
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        buttonIsEnabled(
            isEnabled: false,
            titleColor: gray,
            backgroundColor: lightGray,
            shadowColor: gray.cgColor)
        
        delegate.rewriteSetting(setting: settingDefault)
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
                                           height: shadowOffsetHeight ?? 0)
        button.isEnabled = isEnabled ?? true
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
                                          height: shadowOffsetHeight ?? 0)
        label.numberOfLines = numberOfLines ?? 0
        label.textAlignment = textAlignment ?? .natural
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
        switch pickerView.tag {
        case 1:
            return settingDefault.countRows
        case 2:
            return 10
        default:
            return (6 * settingDefault.countQuestions) - (4 * settingDefault.countQuestions) + 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        var title = ""
        var attributed = NSAttributedString()
        
        switch pickerView.tag {
        case 1:
            title = "\(row + 10)"
            attributed = attributedString(title: title)
        case 2:
            title = "\(row + 6)"
            attributed = attributedStringTimeElapsed(title: title, tag: 2)
        default:
            let allQuestionTime = 4 * settingDefault.countQuestions
            title = "\(row + allQuestionTime)"
            attributed = attributedStringTimeElapsed(title: title, tag: 3)
        }
        
        label.textAlignment = .center
        label.attributedText = attributed
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            
            let countQuestion = row + 10
            let averageQuestionTime = 5 * countQuestion
            let currentRow = averageQuestionTime - (4 * countQuestion)
            
            setupDataFromPickerView(countQuestion: countQuestion,
                                    averageTime: averageQuestionTime,
                                    currentRow: currentRow)
            
            let lightBlue = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1)
            let blue = UIColor(red: 54/255, green: 55/255, blue: 215/255, alpha: 1)
            let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
            let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
            conditions() ?
            buttonIsEnabled(
                isEnabled: true,
                titleColor: blue,
                backgroundColor: lightBlue,
                shadowColor: blue.cgColor) :
            buttonIsEnabled(
                isEnabled: false,
                titleColor: gray,
                backgroundColor: lightGray,
                shadowColor: gray.cgColor)
            
            delegate.rewriteSetting(setting: settingDefault)
            
        case 2:
            
            let oneQuestionTime = row + 6
            labelTimeElapsedNumber.text = "\(oneQuestionTime)"
            settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime = oneQuestionTime
            delegate.rewriteSetting(setting: settingDefault)
            
        default:
            
            let allQuestionTime = row + (4 * settingDefault.countQuestions)
            labelTimeElapsedNumber.text = "\(allQuestionTime)"
            settingDefault.timeElapsed.questionSelect.questionTime.allQuestionsTime = allQuestionTime
            delegate.rewriteSetting(setting: settingDefault)
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch pickerView.tag {
        case 1:
            return pickerView.frame.width
        case 2:
            return 150
        default:
            return 150
        }
    }
    
    private func setPickerView(backgroundColor: UIColor,
                               cornerRadius: CGFloat,
                               tag: Int,
                               isEnabled: Bool) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = backgroundColor
        pickerView.layer.cornerRadius = cornerRadius
        pickerView.tag = tag
        pickerView.isUserInteractionEnabled = isEnabled
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }
    
    private func attributedString(title: String) -> NSAttributedString {
        NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "mr_fontick", size: 26) ?? "",
            .foregroundColor:
                UIColor(
                    red: 54/255,
                    green: 55/255,
                    blue: 252/255,
                    alpha: 1)
        ])
    }
    
    private func attributedStringTimeElapsed(title: String, tag: Int) -> NSAttributedString {
        let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        let currentColor: UIColor = settingDefault.timeElapsed.timeElapsed ? isEnabledTextColor(tag: tag) : gray
        return NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "mr_fontick", size: 26) ?? "",
            .foregroundColor: currentColor
        ])
    }
    
    private func checkPickerViewEnabled(time: Int) -> String {
        let text = "\(settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime)"
        guard pickerViewAllQuestions.isUserInteractionEnabled else { return text }
        return "\(time)"
    }
    
    private func setupDataFromPickerView(countQuestion: Int, averageTime: Int, currentRow: Int) {
        labelNumber.text = "\(countQuestion)"
        labelTimeElapsedNumber.text = checkPickerViewEnabled(time: averageTime)
        
        settingDefault.countQuestions = countQuestion
        settingDefault.timeElapsed.questionSelect.questionTime.allQuestionsTime = averageTime
        
        pickerViewAllQuestions.reloadAllComponents()
        pickerViewAllQuestions.selectRow(currentRow, inComponent: 0, animated: false)
    }
}
// MARK: - Setup toggle
extension SettingViewController {
    private func setToggle(toggleColor: UIColor,
                           onColor: UIColor,
                           isOn: Bool,
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
                                           height: shadowOffsetHeight ?? 0)
        toggle.isOn = isOn
        toggle.addTarget(self, action: #selector(toggleAction), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func setStackViewPickerViews(autoresizingConstraints: Bool,
                                         pickerViewFirst: UIPickerView,
                                         pickerViewSecond: UIPickerView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [pickerViewFirst, pickerViewSecond])
        stackView.translatesAutoresizingMaskIntoConstraints = autoresizingConstraints
        stackView.distribution = .equalSpacing
        return stackView
    }
}
// MARK: - Setup segmented control
extension SettingViewController {
    private func setSegmentedControl(background: UIColor,
                                     segmentColor: UIColor,
                                     elements: [Any],
                                     titleSelectedColor: UIColor,
                                     titleNormalColor: UIColor,
                                     setIndex: Int,
                                     isEnabled: Bool) -> UISegmentedControl {
        let segment = UISegmentedControl(items: elements)
        let font = UIFont(name: "mr_fontick", size: 26)
        segment.backgroundColor = background
        segment.selectedSegmentTintColor = segmentColor
        segment.setTitleTextAttributes([
            NSAttributedString.Key
                .font: font ?? "",
                .foregroundColor: titleSelectedColor
        ], for: .selected)
        segment.setTitleTextAttributes([
            NSAttributedString.Key
                .font: font ?? "",
                .foregroundColor: titleNormalColor
        ], for: .normal)
        segment.selectedSegmentIndex = setIndex
        segment.isUserInteractionEnabled = isEnabled
        segment.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }
}
// MARK: - Alert controller
extension SettingViewController {
    private func showAlert(setting: Setting) {
        let title = "Сбросить настройки"
        
        let alert = AlertController(
            title: title,
            message: "Вы действительно хотите скинуть все настройки до заводских?",
            preferredStyle: .alert)
        
        alert.action(setting: setting) {
            self.resetSetting()
        }
        
        present(alert, animated: true)
    }
}
