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
        let view = setView(color: UIColor.panelViewLightBlueLight)
        return view
    }()
    
    private lazy var buttonBackMenu: UIButton = {
        let button = setButton(
            title: "Главное меню",
            style: "mr_fontick",
            size: 15,
            colorTitle: UIColor.blueLight,
            colorBackgroud: UIColor.cyanLight,
            radiusCorner: 14,
            shadowColor: UIColor.shadowBlueLight.cgColor,
            radiusShadow: 2.5,
            shadowOffsetWidth: 2.5,
            shadowOffsetHeight: 2.5)
        button.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonDefaultSetting: UIButton = {
        let lightBlue = UIColor.cyanLight
        let blue = UIColor.blueLight
        let darkBlue = UIColor.shadowBlueLight
        let lightGray = UIColor.skyGrayLight
        let gray = UIColor.grayLight
        let darkGray = UIColor.shadowGrayLight
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
        let view = setView(color: UIColor.contentLight)
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
            color: UIColor.blueLight,
            numberOfLines: 1,
            textAlignment: .center)
        return label
    }()
    
    private lazy var labelNumber: UILabel = {
        let label = setLabel(
            title: "\(settingDefault.countQuestions)",
            size: 26,
            style: "mr_fontick",
            color: UIColor.blueLight,
            textAlignment: .left)
        return label
    }()
    
    private lazy var stackViewNumberQuestion: UIStackView = {
        let stackView = setStackViewLabels(labelFirst: labelNumberQuestions,
                                           labelSecond: labelNumber, spacing: 10)
        return stackView
    }()
    
    private lazy var pickerViewNumberQuestion: UIPickerView = {
        let pickerView = setPickerView(
            backgroundColor: UIColor.skyCyanLight,
            tag: 1,
            isEnabled: true)
        return pickerView
    }()
    /*
    private lazy var viewAllCountries: UIView = {
        let view = setView(color: UIColor.skyCyanLight, radiusCorner: 13,
                           addButton: buttonAllCountries)
        return view
    }()
    
    private lazy var buttonAllCountries: UIButton = {
        let button = setButtonCheckmark(
            image: checkmark(isOn: settingDefault.allCountries), tag: 1)
        return button
    }()
    */
    private lazy var labelAllCountries: UILabel = {
        let label = setLabel(
            title: "Все страны мира",
            size: 26,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    
    private lazy var labelCountAllCountries: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countries.count)",
            size: 20,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    /*
    private lazy var stackViewLabelsAllCountries: UIStackView = {
        let stackView = setStackViewLabels(
            labelFirst: labelAllCountries,
            labelSecond: labelCountAllCountries,
            axis: .vertical,
            distribution: .fillEqually,
            alignment: .center)
        return stackView
    }()
    */
    private lazy var buttonAllCountries: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: settingDefault.allCountries).0,
            borderColor: select(isOn: settingDefault.allCountries).1,
            tag: 1,
            addLabelFirst: labelAllCountries,
            addLabelSecond: labelCountAllCountries)
        return button
    }()
    /*
    private lazy var stackViewAllCountries: UIStackView = {
        let stackView = setStackViewCheckmark(view: viewAllCountries,
                                              stackView: stackViewLabelsAllCountries)
        return stackView
    }()
    
    private lazy var viewAmericaContinent: UIView = {
        let view = setView(color: UIColor.skyCyanLight, radiusCorner: 13,
                           addButton: buttonAmericaContinent)
        return view
    }()
    
    private lazy var buttonAmericaContinent: UIButton = {
        let button = setButtonCheckmark(
            image: checkmark(isOn: settingDefault.americaContinent), tag: 2)
        return button
    }()
    */
    private lazy var labelAmericaContinent: UILabel = {
        let label = setLabel(
            title: "Континент Америки",
            size: 26,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    
    private lazy var labelCountAmericaContinent: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAmericanContinent.count)",
            size: 20,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    /*
    private lazy var stackViewLabelsAmericaContinent: UIStackView = {
        let stackView = setStackViewLabels(
            labelFirst: labelAmericaContinent,
            labelSecond: labelCountAmericaContinent,
            axis: .vertical,
            distribution: .fillEqually,
            alignment: .center)
        return stackView
    }()
    */
    private lazy var buttonAmericaContinent: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: settingDefault.americaContinent).0,
            borderColor: select(isOn: settingDefault.americaContinent).1,
            tag: 2,
            addLabelFirst: labelAmericaContinent,
            addLabelSecond: labelCountAmericaContinent)
        return button
    }()
    /*
    private lazy var stackViewAmericaContinent: UIStackView = {
        let stackView = setStackViewCheckmark(view: viewAmericaContinent,
                                              stackView: stackViewLabelsAmericaContinent)
        return stackView
    }()
    
    private lazy var viewEuropeContinent: UIView = {
        let view = setView(color: UIColor.skyCyanLight, radiusCorner: 13,
                           addButton: buttonEuropeContinent)
        return view
    }()
    
    private lazy var buttonEuropeContinent: UIButton = {
        let button = setButtonCheckmark(
            image: checkmark(isOn: settingDefault.europeContinent), tag: 3)
        return button
    }()
    */
    private lazy var labelEuropeContinent: UILabel = {
        let label = setLabel(
            title: "Континент Европы",
            size: 26,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    
    private lazy var labelCountEuropeContinent: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfEuropeanContinent.count)",
            size: 20,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    /*
    private lazy var stackViewLabelsEuropeContinent: UIStackView = {
        let stackView = setStackViewLabels(
            labelFirst: labelEuropeContinent,
            labelSecond: labelCountEuropeContinent,
            axis: .vertical,
            distribution: .fillEqually,
            alignment: .center)
        return stackView
    }()
    */
    private lazy var buttonEuropeContinent: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: settingDefault.europeContinent).0,
            borderColor: select(isOn: settingDefault.europeContinent).1,
            tag: 3,
            addLabelFirst: labelEuropeContinent,
            addLabelSecond: labelCountEuropeContinent)
        return button
    }()
    /*
    private lazy var stackViewEuropeContinent: UIStackView = {
        let stackView = setStackViewCheckmark(view: viewEuropeContinent,
                                              stackView: stackViewLabelsEuropeContinent)
        return stackView
    }()
    
    private lazy var viewAfricaContinent: UIView = {
        let view = setView(color: UIColor.skyCyanLight, radiusCorner: 13,
                           addButton: buttonAfricaContinent)
        return view
    }()
    
    private lazy var buttonAfricaContinent: UIButton = {
        let button = setButtonCheckmark(
            image: checkmark(isOn: settingDefault.africaContinent), tag: 4)
        return button
    }()
    */
    private lazy var labelAfricaContinent: UILabel = {
        let label = setLabel(
            title: "Континент Африки",
            size: 26,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    
    private lazy var labelCountAfricaContinent: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAfricanContinent.count)",
            size: 20,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    /*
    private lazy var stackViewLabelsAfricaContinent: UIStackView = {
        let stackView = setStackViewLabels(
            labelFirst: labelAfricaContinent,
            labelSecond: labelCountAfricaContinent,
            axis: .vertical,
            distribution: .fillEqually,
            alignment: .center)
        return stackView
    }()
    */
    private lazy var buttonAfricaContinent: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: settingDefault.africaContinent).0,
            borderColor: select(isOn: settingDefault.africaContinent).1,
            tag: 4,
            addLabelFirst: labelAfricaContinent,
            addLabelSecond: labelCountAfricaContinent)
        return button
    }()
    /*
    private lazy var stackViewAfricaContinent: UIStackView = {
        let stackView = setStackViewCheckmark(view: viewAfricaContinent,
                                              stackView: stackViewLabelsAfricaContinent)
        return stackView
    }()
    
    private lazy var viewAsiaContinent: UIView = {
        let view = setView(color: UIColor.skyCyanLight, radiusCorner: 13,
                           addButton: buttonAsiaContinent)
        return view
    }()
    
    private lazy var buttonAsiaContinent: UIButton = {
        let button = setButtonCheckmark(
            image: checkmark(isOn: settingDefault.asiaContinent), tag: 5)
        return button
    }()
    */
    private lazy var labelAsiaContinent: UILabel = {
        let label = setLabel(
            title: "Континент Азии",
            size: 26,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    
    private lazy var labelCountAsiaContinent: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAsianContinent.count)",
            size: 20,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    /*
    private lazy var stackViewLabelsAsiaContinent: UIStackView = {
        let stackView = setStackViewLabels(
            labelFirst: labelAsiaContinent,
            labelSecond: labelCountAsiaContinent,
            axis: .vertical,
            distribution: .fillEqually,
            alignment: .center)
        return stackView
    }()
    */
    private lazy var buttonAsiaContinent: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: settingDefault.asiaContinent).0,
            borderColor: select(isOn: settingDefault.asiaContinent).1,
            tag: 5,
            addLabelFirst: labelAsiaContinent,
            addLabelSecond: labelCountAsiaContinent)
        return button
    }()
    /*
    private lazy var stackViewAsiaContinent: UIStackView = {
        let stackView = setStackViewCheckmark(view: viewAsiaContinent,
                                              stackView: stackViewLabelsAsiaContinent)
        return stackView
    }()
    
    private lazy var viewOceaniaContinent: UIView = {
        let view = setView(color: UIColor.skyCyanLight, radiusCorner: 13,
                           addButton: buttonOceaniaContinent)
        return view
    }()
    
    private lazy var buttonOceaniaContinent: UIButton = {
        let button = setButtonCheckmark(
            image: checkmark(isOn: settingDefault.oceaniaContinent), tag: 6)
        return button
    }()
    */
    private lazy var labelOceaniaContinent: UILabel = {
        let label = setLabel(
            title: "Континент Океании",
            size: 26,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    
    private lazy var labelCountOceaniaContinent: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfOceanContinent.count)",
            size: 20,
            style: "mr_fontick",
            color: UIColor.blueLight)
        return label
    }()
    /*
    private lazy var stackViewLabelsOceaniaContinent: UIStackView = {
        let stackView = setStackViewLabels(
            labelFirst: labelOceaniaContinent,
            labelSecond: labelCountOceaniaContinent,
            axis: .vertical,
            distribution: .fillEqually,
            alignment: .center)
        return stackView
    }()
    */
    private lazy var buttonOceaniaContinent: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: settingDefault.oceaniaContinent).0,
            borderColor: select(isOn: settingDefault.oceaniaContinent).1,
            tag: 6,
            addLabelFirst: labelOceaniaContinent,
            addLabelSecond: labelCountOceaniaContinent)
        return button
    }()
    /*
    private lazy var stackViewOceaniaContinent: UIStackView = {
        let stackView = setStackViewCheckmark(view: viewOceaniaContinent,
                                              stackView: stackViewLabelsOceaniaContinent)
        return stackView
    }()
    */
    private lazy var viewTimeElapsed: UIView = {
        let view = setView(
            color: UIColor.skyCyanLight,
            radiusCorner: 13,
            addButton: buttonTimeElapsed)
        return view
    }()
    
    private lazy var buttonTimeElapsed: UIButton = {
        let button = setButtonCheckmark(
            image: checkmark(isOn: settingDefault.timeElapsed.timeElapsed),
            tag: 7)
        return button
    }()
    
    private lazy var labelTimeElapsed: UILabel = {
        let label = setLabel(
            title: "Обратный отсчет",
            size: 26,
            style: "mr_fontick",
            color: UIColor.blueLight,
            textAlignment: .center)
        return label
    }()
    
    private lazy var stackViewTimeElapsed: UIStackView = {
        let stackView = setStackViewCheckmark(
            view: viewTimeElapsed,
            label: labelTimeElapsed)
        return stackView
    }()
    
    private lazy var labelTimeElapsedQuestion: UILabel = {
        let blue = UIColor.blueLight
        let gray = UIColor.grayLight
        let label = setLabel(
            title: isEnabledText(),
            size: 26,
            style: "mr_fontick",
            color: settingDefault.timeElapsed.timeElapsed ? blue : gray,
            numberOfLines: 1)
        return label
    }()
    
    private lazy var labelTimeElapsedNumber: UILabel = {
        let blue = UIColor.blueLight
        let gray = UIColor.grayLight
        let label = setLabel(
            title: setLabelNumberQuestions(),
            size: 26,
            style: "mr_fontick",
            color: settingDefault.timeElapsed.timeElapsed ? blue : gray,
            textAlignment: .left)
        return label
    }()
    
    private lazy var stackViewLabelTimeElapsed: UIStackView = {
        let stackView = setStackViewLabels(
            labelFirst: labelTimeElapsedQuestion,
            labelSecond: labelTimeElapsedNumber,
            spacing: 10)
        return stackView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let lightBlue = UIColor.skyCyanLight
        let blue = UIColor.blueLight
        let lightGray = UIColor.skyGrayLight
        let gray = UIColor.grayLight
        let segment = setSegmentedControl(
            background: settingDefault.timeElapsed.timeElapsed ? lightBlue : lightGray,
            segmentColor: settingDefault.timeElapsed.timeElapsed ? blue : gray,
            elements: ["Один вопрос", "Все вопросы"],
            titleSelectedColor: settingDefault.timeElapsed.timeElapsed ? lightBlue : lightGray,
            titleNormalColor: settingDefault.timeElapsed.timeElapsed ? blue : gray,
            setIndex: settingDefault.timeElapsed.questionSelect.oneQuestion ? 0 : 1,
            isEnabled: settingDefault.timeElapsed.timeElapsed ? true : false,
            borderColor: settingDefault.timeElapsed.timeElapsed ? lightBlue : lightGray)
        return segment
    }()
    
    private lazy var pickerViewOneQuestion: UIPickerView = {
        let gray = UIColor.skyGrayLight
        let pickerView = setPickerView(
            backgroundColor: settingDefault.timeElapsed.timeElapsed ? isEnabledColor(tag: 2) : gray,
            tag: 2,
            isEnabled: settingDefault.timeElapsed.timeElapsed ? isEnabled(tag: 2) : false)
        return pickerView
    }()
    
    private lazy var pickerViewAllQuestions: UIPickerView = {
        let gray = UIColor.skyGrayLight
        let pickerView = setPickerView(
            backgroundColor: settingDefault.timeElapsed.timeElapsed ? isEnabledColor(tag: 3) : gray,
            tag: 3,
            isEnabled: settingDefault.timeElapsed.timeElapsed ? isEnabled(tag: 3) : false)
        return pickerView
    }()
    
    private lazy var stackViewPickerViews: UIStackView = {
        let stackView = setStackViewPickerViews(
            pickerViewFirst: pickerViewOneQuestion,
            pickerViewSecond: pickerViewAllQuestions)
        return stackView
    }()
    
    var settingDefault: Setting!
    var delegate: SettingViewControllerDelegate!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviewsOnView()
        setupSubviewsOnContentView()
        setupSubviewsOnScrollView()
        setupConstraints()
    }
    // MARK: - Private methods
    private func setupDesign() {
        view.backgroundColor = UIColor.backgroundBlueLight
        setupPickerViewNumberQuestions()
        setupPickerViewOneQuestion()
    }
    
    private func setupPickerViewNumberQuestions() {
        let countQuestions = settingDefault.countQuestions
        let rowCountQuestions = countQuestions - 10
        pickerViewNumberQuestion.selectRow(rowCountQuestions, inComponent: 0, animated: false)
        setupPickerViewAllQuestions(countQuestions: countQuestions)
    }
    
    private func setupPickerViewOneQuestion() {
        let rowOneQuestion = settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime - 6
        pickerViewOneQuestion.selectRow(rowOneQuestion, inComponent: 0, animated: false)
    }
    
    private func setupPickerViewAllQuestions(countQuestions: Int) {
        let timeAllQuestions = settingDefault.timeElapsed.questionSelect.questionTime.allQuestionsTime
        let rowAllQuestions = timeAllQuestions - (4 * countQuestions)
        pickerViewAllQuestions.selectRow(rowAllQuestions, inComponent: 0, animated: false)
    }
    
    private func setupSubviewsOnView() {
        setupSubviews(subviews: viewPanel, buttonBackMenu, buttonDefaultSetting,
                      contentView)
    }
    
    private func setupSubviewsOnContentView() {
        setupSubviewsOnContentView(subviews: scrollView)
    }
    
    private func setupSubviewsOnScrollView() {
        setupSubviewsOnScrollView(subviews: stackViewNumberQuestion,
                                  pickerViewNumberQuestion,
                                  buttonAllCountries,
                                  buttonAmericaContinent,
                                  buttonEuropeContinent,
                                  buttonAfricaContinent,
                                  buttonAsiaContinent,
                                  buttonOceaniaContinent,
                                  stackViewTimeElapsed,
                                  stackViewLabelTimeElapsed,
                                  segmentedControl,
                                  stackViewPickerViews)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
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
    // MARK: - Activating buttons
    @objc private func backToMenu() {
        delegate.sendDataOfSetting(setting: settingDefault)
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
    // MARK: - Setting of checkmarks
    @objc private func buttonCheckmark(sender: UIButton) {
        switch sender {
        case buttonAllCountries:
            checkmarkOnAllCountries()
            settingOnAllCountries()
        case buttonAmericaContinent:
            settingDefault.americaContinent.toggle()
            checkmarkContinents(button: sender, isOn: settingDefault.americaContinent)
        case buttonEuropeContinent:
            settingDefault.europeContinent.toggle()
            checkmarkContinents(button: sender, isOn: settingDefault.europeContinent)
        case buttonAfricaContinent:
            settingDefault.africaContinent.toggle()
            checkmarkContinents(button: sender, isOn: settingDefault.africaContinent)
        case buttonAsiaContinent:
            settingDefault.asiaContinent.toggle()
            checkmarkContinents(button: sender, isOn: settingDefault.asiaContinent)
        case buttonOceaniaContinent:
            settingDefault.oceaniaContinent.toggle()
            checkmarkContinents(button: sender, isOn: settingDefault.oceaniaContinent)
        default:
            checkmarkTimeElapsed(button: sender)
        }
        
        setupCountCountries(continents: settingDefault.allCountries, settingDefault.americaContinent,
                            settingDefault.europeContinent, settingDefault.africaContinent,
                            settingDefault.asiaContinent, settingDefault.oceaniaContinent)
        buttonIsEnabled()
    }
    
    private func checkmarkOnAllCountries() {
        buttonOnOff(buttons: buttonAllCountries, color: UIColor.cyanLight,
                    borderColor: UIColor.blueLight)
        buttonOnOff(buttons: buttonAmericaContinent, buttonEuropeContinent,
                    buttonAfricaContinent, buttonAsiaContinent,
                    buttonOceaniaContinent, color: UIColor.skyCyanLight,
                    borderColor: UIColor.skyCyanLight)
        /*
        checkmarkOnOff(buttons: buttonAllCountries, image: "checkmark.circle.fill")
        checkmarkOnOff(buttons: buttonAmericaContinent, buttonEuropeContinent,
                       buttonAfricaContinent, buttonAsiaContinent,
                       buttonOceaniaContinent, image: "circle")
         */
    }
    
    private func settingOnAllCountries() {
        checkmarkSettingOnOff(buttons: buttonAllCountries, bool: true)
        checkmarkSettingOnOff(buttons: buttonAmericaContinent, buttonEuropeContinent,
                              buttonAfricaContinent, buttonAsiaContinent,
                              buttonOceaniaContinent, bool: false)
    }
    
    private func buttonOnOff(buttons: UIButton..., color: UIColor, borderColor: UIColor) {
        buttons.forEach { button in
            button.backgroundColor = color
            button.layer.borderColor = borderColor.cgColor
        }
    }
    
    private func checkmarkOnOff(buttons: UIButton..., image: String) {
        buttons.forEach { button in
            let configuration = UIImage.SymbolConfiguration(pointSize: 25)
            let image = UIImage(systemName: image, withConfiguration: configuration)
            button.configuration?.image = image
        }
    }
    
    private func checkmarkSettingOnOff(buttons: UIButton..., bool: Bool) {
        buttons.forEach { button in
            switch button.tag {
            case 1: settingDefault.allCountries = bool
            case 2: settingDefault.americaContinent = bool
            case 3: settingDefault.europeContinent = bool
            case 4: settingDefault.africaContinent = bool
            case 5: settingDefault.asiaContinent = bool
            default: settingDefault.oceaniaContinent = bool
            }
        }
    }
    
    private func checkmarkContinents(button: UIButton, isOn: Bool) {
        if settingDefault.americaContinent, settingDefault.europeContinent,
           settingDefault.africaContinent, settingDefault.asiaContinent,
           settingDefault.oceaniaContinent {
            checkmarkOnAllCountries()
            settingOnAllCountries()
        } else if !settingDefault.allCountries, !settingDefault.americaContinent,
                  !settingDefault.europeContinent, !settingDefault.africaContinent,
                  !settingDefault.asiaContinent, !settingDefault.oceaniaContinent {
            checkmarkOnAllCountries()
            settingOnAllCountries()
        } else {
            /*
            checkmarkOnOff(buttons: buttonAllCountries, image: "circle")
            checkmarkOnOff(buttons: button, image: isOn ? "checkmark.circle.fill" : "circle")
             */
            buttonOnOff(buttons: buttonAllCountries, color: UIColor.skyCyanLight,
                        borderColor: UIColor.skyCyanLight)
            buttonOnOff(buttons: button, color: select(isOn: isOn).0,
                        borderColor: select(isOn: isOn).1)
            checkmarkSettingOnOff(buttons: buttonAllCountries, bool: false)
        }
    }
    
    private func checkmarkTimeElapsed(button: UIButton) {
        settingDefault.timeElapsed.timeElapsed.toggle()
        let isOn = settingDefault.timeElapsed.timeElapsed
        checkmarkOnOff(buttons: button, image: checkmark(isOn: isOn))
        checkmarkColors(isOn: isOn)
    }
    
    private func checkmarkColors(isOn: Bool) {
        let blue = UIColor.blueLight
        let gray = UIColor.grayLight
        checkmarkLabels(blue: blue, gray: gray, isOn: isOn)
        checkmarkSegmentedControl(blue: blue, gray: gray, isOn: isOn)
        checkmarkPickerViews(isOn: isOn)
    }
    
    private func checkmarkLabels(blue: UIColor, gray: UIColor, isOn: Bool) {
        labelTimeElapsedQuestion.textColor = isOn ? blue : gray
        labelTimeElapsedNumber.textColor = isOn ? blue : gray
    }
    
    private func checkmarkSegmentedControl(blue: UIColor, gray: UIColor, isOn: Bool) {
        let lightBlue = UIColor.skyCyanLight
        let lightGray = UIColor.skyGrayLight
        segmentedControl.isUserInteractionEnabled = isOn ? true : false
        segmentedControl.backgroundColor = isOn ? lightBlue : lightGray
        segmentedControl.selectedSegmentTintColor = isOn ? blue : gray
        segmentedControl.layer.borderColor = isOn ? lightBlue.cgColor : lightGray.cgColor
        segmentSelectColors(blue: blue, gray: gray, lightBlue: lightBlue,
                            lightGray: lightGray, isOn: isOn)
    }
    
    private func segmentSelectColors(blue: UIColor, gray: UIColor, lightBlue: UIColor,
                                     lightGray: UIColor, isOn: Bool) {
        let font = UIFont(name: "mr_fontick", size: 26)
        let titleSelectedColor: UIColor = isOn ? lightBlue : lightGray
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key
                .font: font ?? "",
                .foregroundColor: titleSelectedColor
        ], for: .selected)
        
        let titleNormalColor: UIColor = isOn ? blue : gray
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key
                .font: font ?? "",
                .foregroundColor: titleNormalColor
        ], for: .normal)
    }
    // MARK: - исправить дублирование кода
    private func checkmarkPickerViews(isOn: Bool) {
        let lightGray = UIColor.skyGrayLight
        pickerViewOneQuestion.isUserInteractionEnabled = isOn ? isEnabled(tag: 2) : false
        pickerViewOneQuestion.backgroundColor = isOn ? isEnabledColor(tag: 2) : lightGray
        pickerViewOneQuestion.reloadAllComponents()
        pickerViewAllQuestions.isUserInteractionEnabled = isOn ? isEnabled(tag: 3) : false
        pickerViewAllQuestions.backgroundColor = isOn ? isEnabledColor(tag: 3) : lightGray
        pickerViewAllQuestions.reloadAllComponents()
    }
    
    private func checkmark(isOn: Bool) -> String {
        isOn ? "checkmark.circle.fill" : "circle"
    }
    
    private func select(isOn: Bool) -> (UIColor, UIColor) {
        isOn ? (UIColor.cyanLight, UIColor.blueLight) : (UIColor.skyCyanLight, UIColor.skyCyanLight)
    }
    
    private func setupCountCountries(continents: Bool...) {
        var count = 0
        var number = 0
        continents.forEach { continent in
            number += 1
            if continent {
                count += checkCountQuestions(continent: number)
            }
        }
        count = checkCountRows(count: count - 9)
        setupRowsPickerView(countRows: count)
    }
    
    private func checkCountQuestions(continent: Int) -> Int {
        var count: Int
        switch continent {
        case 1: count = FlagsOfCountries.shared.countries.count
        case 2: count = FlagsOfCountries.shared.countriesOfAmericanContinent.count
        case 3: count = FlagsOfCountries.shared.countriesOfEuropeanContinent.count
        case 4: count = FlagsOfCountries.shared.countriesOfAfricanContinent.count
        case 5: count = FlagsOfCountries.shared.countriesOfAsianContinent.count
        default: count = FlagsOfCountries.shared.countriesOfOceanContinent.count
        }
        return count
    }
    
    private func checkCountRows(count: Int) -> Int {
        count > DefaultSetting.countRows.rawValue ? DefaultSetting.countRows.rawValue : count
    }
    
    private func setupRowsPickerView(countRows: Int) {
        if countRows < settingDefault.countRows {
            let countQuestions = countRows + 9
            
            settingDefault.countRows = countRows
            pickerViewNumberQuestion.reloadAllComponents()
            pickerViewNumberQuestion.selectRow(countRows, inComponent: 0, animated: false)
            checkCountQuestions(countQuestions: countQuestions)
        } else {
            settingDefault.countRows = countRows
            pickerViewNumberQuestion.reloadAllComponents()
        }
    }
    
    private func checkCountQuestions(countQuestions: Int) {
        if countQuestions < settingDefault.countQuestions {
            let averageQuestionTime = 5 * countQuestions
            let currentRow = averageQuestionTime - (4 * countQuestions)
            
            setupDataFromPickerView(countQuestion: countQuestions,
                                    averageTime: averageQuestionTime,
                                    currentRow: currentRow)
        }
    }
    // MARK: - Setting of segmented control
    @objc private func segmentedControlAction() {
        let lightBlue = UIColor.skyCyanLight
        let lightGray = UIColor.skyGrayLight
        
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
    }
    // MARK: - Enabled or disabled picker view and color and label
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
        let lightBlue = UIColor.skyCyanLight
        let lightGray = UIColor.skyGrayLight
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
        let blue = UIColor.blueLight
        let gray = UIColor.grayLight
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
        
        let countQuestions = settingDefault.countQuestions - 10
        let averageTime = 5 * settingDefault.countQuestions
        let timeOneQuestion = settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime - 6
        let timeAllQuestions = averageTime - (4 * settingDefault.countQuestions)
        
        setupLabels()
        checkmarkOnAllCountries()
        segmentedControl.selectedSegmentIndex = 0
        setupPickerViews(pickerView: pickerViewNumberQuestion, row: countQuestions)
        setupPickerViews(pickerView: pickerViewOneQuestion, row: timeOneQuestion)
        setupPickerViews(pickerView: pickerViewAllQuestions, row: timeAllQuestions)
        buttonIsEnabled()
    }
    
    private func setupLabels() {
        labelNumber.text = "\(settingDefault.countQuestions)"
        labelTimeElapsedNumber.text = "\(settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime)"
    }
    
    private func setupPickerViews(pickerView: UIPickerView, row: Int) {
        pickerView.reloadAllComponents()
        pickerView.selectRow(row, inComponent: 0, animated: false)
    }
    
    private func buttonIsEnabled() {
        let lightBlue = UIColor.cyanLight
        let blue = UIColor.blueLight
        let darkBlue = UIColor.shadowBlueLight
        let lightGray = UIColor.skyGrayLight
        let gray = UIColor.grayLight
        let darkGray = UIColor.shadowGrayLight
        
        conditions() ?
        buttonIsEnabled(
            isEnabled: true,
            titleColor: blue,
            backgroundColor: lightBlue,
            shadowColor: darkBlue.cgColor) :
        buttonIsEnabled(
            isEnabled: false,
            titleColor: gray,
            backgroundColor: lightGray,
            shadowColor: darkGray.cgColor)
    }
}
// MARK: - Setup view
extension SettingViewController {
    private func setView(color: UIColor? = nil, radiusCorner: CGFloat? = nil,
                         addButton: UIButton? = nil) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let color = color {
            view.backgroundColor = color
            view.layer.cornerRadius = radiusCorner ?? 0
            if let button = addButton {
                view.addSubview(button)
            }
        }
        return view
    }
}
// MARK: - Setup button
extension SettingViewController {
    private func setButton(title: String, style: String? = nil, size: CGFloat,
                           colorTitle: UIColor? = nil, colorBackgroud: UIColor? = nil,
                           radiusCorner: CGFloat? = nil, borderWidth: CGFloat? = nil,
                           borderColor: CGColor? = nil, shadowColor: CGColor? = nil,
                           radiusShadow: CGFloat? = nil, shadowOffsetWidth: CGFloat? = nil,
                           shadowOffsetHeight: CGFloat? = nil,
                           isEnabled: Bool? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(colorTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: style ?? "", size: size)
        button.backgroundColor = colorBackgroud
        button.layer.cornerRadius = radiusCorner ?? 0
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
    
    private func setButtonCheckmark(image: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: image, withConfiguration: configuration)
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = UIColor.blueLight
        button.configuration?.image = image
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonCheckmark), for: .touchUpInside)
        return button
    }
    
    private func setButtonContinents(color: UIColor, borderColor: UIColor, tag: Int,
                                     addLabelFirst: UILabel,
                                     addLabelSecond: UILabel) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = color
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 13
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonCheckmark), for: .touchUpInside)
        setupSubviews(subviews: addLabelFirst, addLabelSecond, on: button)
        return button
    }
}
// MARK: - Setup label
extension SettingViewController {
    private func setLabel(title: String, size: CGFloat, style: String, color: UIColor,
                          colorOfShadow: CGColor? = nil, radiusOfShadow: CGFloat? = nil,
                          shadowOffsetWidth: CGFloat? = nil, shadowOffsetHeight: CGFloat? = nil,
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
            let averageTime = 5 * countQuestion
            let currentRow = averageTime - (4 * countQuestion)
            
            setupDataFromPickerView(countQuestion: countQuestion,
                                    averageTime: averageTime,
                                    currentRow: currentRow)
            buttonIsEnabled()
            
        case 2:
            
            let oneQuestionTime = row + 6
            labelTimeElapsedNumber.text = "\(oneQuestionTime)"
            settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime = oneQuestionTime
            
        default:
            
            let allQuestionTime = row + (4 * settingDefault.countQuestions)
            labelTimeElapsedNumber.text = "\(allQuestionTime)"
            settingDefault.timeElapsed.questionSelect.questionTime.allQuestionsTime = allQuestionTime
            
        }
    }
    
    private func setPickerView(backgroundColor: UIColor,
                               tag: Int,
                               isEnabled: Bool) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = backgroundColor
        pickerView.layer.cornerRadius = 13
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
                UIColor.blueLight
        ])
    }
    
    private func attributedStringTimeElapsed(title: String, tag: Int) -> NSAttributedString {
        let gray = UIColor.grayLight
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
        
        setupPickerViews(pickerView: pickerViewAllQuestions, row: currentRow)
    }
}
// MARK: - Setup stack view
extension SettingViewController {
    private func setStackViewLabels(labelFirst: UILabel, labelSecond: UILabel,
                                    spacing: CGFloat? = nil,
                                    axis: NSLayoutConstraint.Axis? = nil,
                                    distribution: UIStackView.Distribution? = nil,
                                    alignment: UIStackView.Alignment? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [labelFirst, labelSecond])
        stackView.spacing = spacing ?? 0
        stackView.axis = axis ?? .horizontal
        stackView.distribution = distribution ?? .fill
        stackView.alignment = alignment ?? .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackViewCheckmark(view: UIView, label: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [view, label])
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackViewPickerViews(pickerViewFirst: UIPickerView,
                                         pickerViewSecond: UIPickerView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [pickerViewFirst, pickerViewSecond])
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup segmented control
extension SettingViewController {
    private func setSegmentedControl(background: UIColor, segmentColor: UIColor,
                                     elements: [Any], titleSelectedColor: UIColor,
                                     titleNormalColor: UIColor, setIndex: Int,
                                     isEnabled: Bool, borderColor: UIColor) -> UISegmentedControl {
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
        segment.layer.borderWidth = 5
        segment.layer.borderColor = borderColor.cgColor
        segment.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }
}
// MARK: - Setup constraints
extension SettingViewController {
    private func setupConstraints() {
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
            stackViewNumberQuestion.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 8),
            stackViewNumberQuestion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        
        setupStartConstraints(subviewFirst: pickerViewNumberQuestion,
                              to: stackViewNumberQuestion,
                              leadingConstant: 20, constant: 12)
        setupHeightSubview(subview: pickerViewNumberQuestion, height: 110)
        
        setupStartConstraints(
            subviewFirst: buttonAllCountries, to: pickerViewNumberQuestion,
            leadingConstant: 20, constant: 15)
//        setupConstraintsCentersOnView(viewFirst: stackViewLabelsAllCountries,
//                                      on: buttonAllCountries)
        setupHeightSubview(subview: buttonAllCountries, height: 60)
        
        setupStartConstraints(
            subviewFirst: buttonAmericaContinent, to: buttonAllCountries,
            leadingConstant: 20, constant: 15)
//        setupConstraintsCentersOnView(viewFirst: stackViewLabelsAmericaContinent,
//                                      on: buttonAmericaContinent)
        setupHeightSubview(subview: buttonAmericaContinent, height: 60)
        
        setupStartConstraints(
            subviewFirst: buttonEuropeContinent, to: buttonAmericaContinent,
            leadingConstant: 20, constant: 15)
//        setupConstraintsCentersOnView(viewFirst: stackViewLabelsEuropeContinent,
//                                      on: buttonEuropeContinent)
        setupHeightSubview(subview: buttonEuropeContinent, height: 60)
        
        setupStartConstraints(
            subviewFirst: buttonAfricaContinent, to: buttonEuropeContinent,
            leadingConstant: 20, constant: 15)
//        setupConstraintsCentersOnView(viewFirst: stackViewLabelsAfricaContinent,
//                                      on: buttonAfricaContinent)
        setupHeightSubview(subview: buttonAfricaContinent, height: 60)
        
        setupStartConstraints(
            subviewFirst: buttonAsiaContinent, to: buttonAfricaContinent,
            leadingConstant: 20, constant: 15)
//        setupConstraintsCentersOnView(viewFirst: stackViewLabelsAsiaContinent,
//                                      on: buttonAsiaContinent)
        setupHeightSubview(subview: buttonAsiaContinent, height: 60)
        
        setupStartConstraints(
            subviewFirst: buttonOceaniaContinent, to: buttonAsiaContinent,
            leadingConstant: 20, constant: 15)
//        setupConstraintsCentersOnView(viewFirst: stackViewLabelsOceaniaContinent,
//                                      on: buttonOceaniaContinent)
        setupHeightSubview(subview: buttonOceaniaContinent, height: 60)
        
        setupStartConstraints(subviewFirst: stackViewTimeElapsed,
                              to: buttonOceaniaContinent,
                              leadingConstant: 20, constant: 15)
        setupSizesSubview(subview: viewTimeElapsed, sizes: 60)
        setupConstraintsCentersOnView(viewFirst: buttonTimeElapsed, on: viewTimeElapsed)
        setupSizesSubview(subview: buttonTimeElapsed, sizes: 50)
        
        setupStartConstraints(subviewFirst: stackViewLabelTimeElapsed,
                              to: stackViewTimeElapsed,
                              leadingConstant: view.frame.width / 8,
                              constant: 15)
        
        setupStartConstraints(subviewFirst: segmentedControl,
                              to: stackViewLabelTimeElapsed,
                              leadingConstant: 20, constant: 15)
        setupHeightSubview(subview: segmentedControl, height: 40)
        
        setupStartConstraints(subviewFirst: stackViewPickerViews,
                              to: segmentedControl,
                              leadingConstant: 20, constant: 15)
        setupHeightSubview(subview: stackViewPickerViews, height: 110)
    }
    
    private func setupStartConstraints(subviewFirst: UIView, to subviewSecond: UIView,
                                       leadingConstant: CGFloat, constant: CGFloat) {
        NSLayoutConstraint.activate([
            subviewFirst.topAnchor.constraint(equalTo: subviewSecond.bottomAnchor, constant: constant),
            subviewFirst.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            subviewFirst.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupSizesSubview(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.heightAnchor.constraint(equalToConstant: sizes),
            subview.widthAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func setupHeightSubview(subview: UIView, height: CGFloat) {
        NSLayoutConstraint.activate([
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func setupConstraintsCentersOnView(viewFirst: UIView, on viewSecond: UIView) {
        NSLayoutConstraint.activate([
            viewFirst.centerXAnchor.constraint(equalTo: viewSecond.centerXAnchor),
            viewFirst.centerYAnchor.constraint(equalTo: viewSecond.centerYAnchor)
        ])
    }
    
    private func fixConstraintsForViewPanelBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 110 : 70
    }
    
    private func fixSizeForContentViewBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 180 : 320
    }
    
    private func fixConstraintsForButtonBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 60 : 30
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
