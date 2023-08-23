//
//  SettingViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.12.2022.
//

import UIKit

class SettingViewController: UIViewController {
    // MARK: - Subviews
    private lazy var buttonBack: UIButton = {
        let button = setupButton(
            image: "multiply",
            color: .blueBlackSea,
            action: #selector(backToMenu))
        return button
    }()
    
    private lazy var buttonDefault: UIButton = {
        let button = setupButton(
            image: "arrow.counterclockwise",
            color: conditions() ? .blueBlackSea : .grayStone,
            action: #selector(defaultSetting))
        return button
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        let stackView = setStackView(
            buttonFirst: buttonBack,
            buttonSecond: buttonDefault)
        return stackView
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
            title: "Количество вопросов",
            size: 26,
            textAlignment: .center,
            numberOfLines: 1)
        return label
    }()
    
    private lazy var labelNumber: UILabel = {
        let label = setLabel(
            title: "\(mode.countQuestions)",
            size: 26)
        return label
    }()
    
    private lazy var stackViewNumberQuestion: UIStackView = {
        let stackView = setStackViewLabels(
            labelFirst: labelNumberQuestions,
            labelSecond: labelNumber,
            spacing: 10)
        return stackView
    }()
    
    private lazy var pickerViewNumberQuestion: UIPickerView = {
        let pickerView = setPickerView(
            backgroundColor: .skyCyanLight,
            tag: 1,
            isEnabled: true)
        return pickerView
    }()
    
    private lazy var labelAllCountries: UILabel = {
        let label = setLabel(
            title: "Все страны мира",
            size: 26)
        return label
    }()
    
    private lazy var labelCountAllCountries: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countries.count)",
            size: 20)
        return label
    }()
    
    private lazy var buttonAllCountries: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: mode.allCountries).0,
            borderColor: select(isOn: mode.allCountries).1,
            tag: 1,
            addLabelFirst: labelAllCountries,
            addLabelSecond: labelCountAllCountries)
        return button
    }()
    
    private lazy var labelAmericaContinent: UILabel = {
        let label = setLabel(
            title: "Континент Америки",
            size: 26)
        return label
    }()
    
    private lazy var labelCountAmericaContinent: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAmericanContinent.count)",
            size: 20)
        return label
    }()
    
    private lazy var buttonAmericaContinent: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: mode.americaContinent).0,
            borderColor: select(isOn: mode.americaContinent).1,
            tag: 2,
            addLabelFirst: labelAmericaContinent,
            addLabelSecond: labelCountAmericaContinent)
        return button
    }()
    
    private lazy var labelEuropeContinent: UILabel = {
        let label = setLabel(
            title: "Континент Европы",
            size: 26)
        return label
    }()
    
    private lazy var labelCountEuropeContinent: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfEuropeanContinent.count)",
            size: 20)
        return label
    }()
    
    private lazy var buttonEuropeContinent: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: mode.europeContinent).0,
            borderColor: select(isOn: mode.europeContinent).1,
            tag: 3,
            addLabelFirst: labelEuropeContinent,
            addLabelSecond: labelCountEuropeContinent)
        return button
    }()
    
    private lazy var labelAfricaContinent: UILabel = {
        let label = setLabel(
            title: "Континент Африки",
            size: 26)
        return label
    }()
    
    private lazy var labelCountAfricaContinent: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAfricanContinent.count)",
            size: 20)
        return label
    }()
    
    private lazy var buttonAfricaContinent: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: mode.africaContinent).0,
            borderColor: select(isOn: mode.africaContinent).1,
            tag: 4,
            addLabelFirst: labelAfricaContinent,
            addLabelSecond: labelCountAfricaContinent)
        return button
    }()
    
    private lazy var labelAsiaContinent: UILabel = {
        let label = setLabel(
            title: "Континент Азии",
            size: 26)
        return label
    }()
    
    private lazy var labelCountAsiaContinent: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAsianContinent.count)",
            size: 20)
        return label
    }()
    
    private lazy var buttonAsiaContinent: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: mode.asiaContinent).0,
            borderColor: select(isOn: mode.asiaContinent).1,
            tag: 5,
            addLabelFirst: labelAsiaContinent,
            addLabelSecond: labelCountAsiaContinent)
        return button
    }()
    
    private lazy var labelOceaniaContinent: UILabel = {
        let label = setLabel(
            title: "Континент Океании",
            size: 26)
        return label
    }()
    
    private lazy var labelCountOceaniaContinent: UILabel = {
        let label = setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfOceanContinent.count)",
            size: 20)
        return label
    }()
    
    private lazy var buttonOceaniaContinent: UIButton = {
        let button = setButtonContinents(
            color: select(isOn: mode.oceaniaContinent).0,
            borderColor: select(isOn: mode.oceaniaContinent).1,
            tag: 6,
            addLabelFirst: labelOceaniaContinent,
            addLabelSecond: labelCountOceaniaContinent)
        return button
    }()
    
    private lazy var viewTimeElapsed: UIView = {
        let view = setView(
            color: UIColor.skyCyanLight,
            radiusCorner: 13,
            addButton: buttonTimeElapsed)
        return view
    }()
    
    private lazy var buttonTimeElapsed: UIButton = {
        let button = setButtonCheckmark(
            image: checkmark(isOn: mode.timeElapsed.timeElapsed),
            tag: 7)
        return button
    }()
    
    private lazy var labelTimeElapsed: UILabel = {
        let label = setLabel(
            title: "Обратный отсчет",
            size: 26,
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
        let label = setLabel(
            title: isEnabledText(),
            size: 26,
            color: timeElapsed() ? .blueBlackSea : .grayLight,
            numberOfLines: 1)
        return label
    }()
    
    private lazy var labelTimeElapsedNumber: UILabel = {
        let label = setLabel(
            title: setLabelNumberQuestions(),
            size: 26,
            color: timeElapsed() ? .blueBlackSea : .grayLight)
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
        let segment = setSegmentedControl(
            background: timeElapsed() ? .skyCyanLight : .skyGrayLight,
            segmentColor: timeElapsed() ? .blueBlackSea : .grayLight,
            elements: ["Один вопрос", "Все вопросы"],
            titleSelectedColor: timeElapsed() ? .skyCyanLight : .skyGrayLight,
            titleNormalColor: timeElapsed() ? .blueBlackSea : .grayLight,
            setIndex: mode.timeElapsed.questionSelect.oneQuestion ? 0 : 1,
            isEnabled: timeElapsed() ? true : false,
            borderColor: timeElapsed() ? .skyCyanLight : .skyGrayLight)
        return segment
    }()
    
    private lazy var pickerViewOneQuestion: UIPickerView = {
        let gray = UIColor.skyGrayLight
        let pickerView = setPickerView(
            backgroundColor: mode.timeElapsed.timeElapsed ? isEnabledColor(tag: 2) : gray,
            tag: 2,
            isEnabled: mode.timeElapsed.timeElapsed ? isEnabled(tag: 2) : false)
        return pickerView
    }()
    
    private lazy var pickerViewAllQuestions: UIPickerView = {
        let gray = UIColor.skyGrayLight
        let pickerView = setPickerView(
            backgroundColor: mode.timeElapsed.timeElapsed ? isEnabledColor(tag: 3) : gray,
            tag: 3,
            isEnabled: mode.timeElapsed.timeElapsed ? isEnabled(tag: 3) : false)
        return pickerView
    }()
    
    private lazy var stackViewPickerViews: UIStackView = {
        let stackView = setStackViewPickerViews(
            pickerViewFirst: pickerViewOneQuestion,
            pickerViewSecond: pickerViewAllQuestions)
        return stackView
    }()
    
    var mode: Setting!
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
        view.backgroundColor = .white
        setupPickerViewNumberQuestions()
        setupPickerViewOneQuestion()
    }
    
    private func setupPickerViewNumberQuestions() {
        let countQuestions = mode.countQuestions
        let rowCountQuestions = countQuestions - 10
        pickerViewNumberQuestion.selectRow(rowCountQuestions, inComponent: 0, animated: false)
        setupPickerViewAllQuestions(countQuestions: countQuestions)
    }
    
    private func setupPickerViewOneQuestion() {
        let rowOneQuestion = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime - 6
        pickerViewOneQuestion.selectRow(rowOneQuestion, inComponent: 0, animated: false)
    }
    
    private func setupPickerViewAllQuestions(countQuestions: Int) {
        let timeAllQuestions = mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
        let rowAllQuestions = timeAllQuestions - (4 * countQuestions)
        pickerViewAllQuestions.selectRow(rowAllQuestions, inComponent: 0, animated: false)
    }
    
    private func setupSubviewsOnView() {
        setupSubviews(subviews: stackViewButtons, contentView, on: view)
    }
    
    private func setupSubviewsOnContentView() {
        setupSubviews(subviews: scrollView, on: contentView)
    }
    
    private func setupSubviewsOnScrollView() {
        setupSubviews(subviews: stackViewNumberQuestion, pickerViewNumberQuestion,
                      buttonAllCountries, buttonAmericaContinent,
                      buttonEuropeContinent, buttonAfricaContinent,
                      buttonAsiaContinent, buttonOceaniaContinent,
                      stackViewTimeElapsed, stackViewLabelTimeElapsed,
                      segmentedControl, stackViewPickerViews, on: scrollView)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    // MARK: - Activating buttons
    @objc private func backToMenu() {
        delegate.sendDataOfSetting(setting: mode)
        StorageManager.shared.saveSetting(setting: mode)
        dismiss(animated: true)
    }
    
    @objc private func defaultSetting() {
        showAlert(setting: mode)
    }
    
    private func buttonIsEnabled(isEnabled: Bool, color: UIColor) {
        buttonDefault.isEnabled = isEnabled
        buttonDefault.tintColor = color
        buttonDefault.layer.borderColor = color.cgColor
    }
    
    private func conditions() -> Bool {
        !mode.allCountries && mode.countQuestions > 50
    }
    // MARK: - Setting label of number questions
    private func setLabelNumberQuestions() -> String {
        let text: String
        if pickerViewOneQuestion.isUserInteractionEnabled {
            text = "\(mode.timeElapsed.questionSelect.questionTime.oneQuestionTime)"
        } else {
            text = "\(mode.timeElapsed.questionSelect.questionTime.allQuestionsTime)"
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
            mode.americaContinent.toggle()
            checkmarkContinents(button: sender, isOn: mode.americaContinent)
        case buttonEuropeContinent:
            mode.europeContinent.toggle()
            checkmarkContinents(button: sender, isOn: mode.europeContinent)
        case buttonAfricaContinent:
            mode.africaContinent.toggle()
            checkmarkContinents(button: sender, isOn: mode.africaContinent)
        case buttonAsiaContinent:
            mode.asiaContinent.toggle()
            checkmarkContinents(button: sender, isOn: mode.asiaContinent)
        case buttonOceaniaContinent:
            mode.oceaniaContinent.toggle()
            checkmarkContinents(button: sender, isOn: mode.oceaniaContinent)
        default:
            checkmarkTimeElapsed(button: sender)
        }
        
        setupCountCountries(continents: mode.allCountries, mode.americaContinent,
                            mode.europeContinent, mode.africaContinent,
                            mode.asiaContinent, mode.oceaniaContinent)
        buttonIsEnabled()
    }
    
    private func checkmarkOnAllCountries() {
        buttonOnOff(buttons: buttonAllCountries, color: UIColor.cyanLight,
                    borderColor: UIColor.blueLight)
        buttonOnOff(buttons: buttonAmericaContinent, buttonEuropeContinent,
                    buttonAfricaContinent, buttonAsiaContinent,
                    buttonOceaniaContinent, color: UIColor.skyCyanLight,
                    borderColor: UIColor.skyCyanLight)
    }
    
    private func settingOnAllCountries() {
        checkmarkSettingOnOff(buttons: buttonAllCountries, bool: true)
        checkmarkSettingOnOff(buttons: buttonAmericaContinent, buttonEuropeContinent,
                              buttonAfricaContinent, buttonAsiaContinent,
                              buttonOceaniaContinent, bool: false)
    }
    
    private func buttonOnOff(buttons: UIButton..., color: UIColor, borderColor: UIColor) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.backgroundColor = color
                button.layer.borderColor = borderColor.cgColor
            }
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
            case 1: mode.allCountries = bool
            case 2: mode.americaContinent = bool
            case 3: mode.europeContinent = bool
            case 4: mode.africaContinent = bool
            case 5: mode.asiaContinent = bool
            default: mode.oceaniaContinent = bool
            }
        }
    }
    
    private func checkmarkContinents(button: UIButton, isOn: Bool) {
        if mode.americaContinent, mode.europeContinent,
           mode.africaContinent, mode.asiaContinent,
           mode.oceaniaContinent {
            checkmarkOnAllCountries()
            settingOnAllCountries()
        } else if !mode.allCountries, !mode.americaContinent,
                  !mode.europeContinent, !mode.africaContinent,
                  !mode.asiaContinent, !mode.oceaniaContinent {
            checkmarkOnAllCountries()
            settingOnAllCountries()
        } else {
            buttonOnOff(buttons: buttonAllCountries, color: UIColor.skyCyanLight,
                        borderColor: UIColor.skyCyanLight)
            buttonOnOff(buttons: button, color: select(isOn: isOn).0,
                        borderColor: select(isOn: isOn).1)
            checkmarkSettingOnOff(buttons: buttonAllCountries, bool: false)
        }
    }
    
    private func checkmarkTimeElapsed(button: UIButton) {
        mode.timeElapsed.timeElapsed.toggle()
        let isOn = mode.timeElapsed.timeElapsed
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
        UIView.animate(withDuration: 0.3) {
            self.labelTimeElapsedQuestion.textColor = isOn ? blue : gray
            self.labelTimeElapsedNumber.textColor = isOn ? blue : gray
        }
    }
    
    private func checkmarkSegmentedControl(blue: UIColor, gray: UIColor, isOn: Bool) {
        let lightBlue = UIColor.skyCyanLight
        let lightGray = UIColor.skyGrayLight
        UIView.animate(withDuration: 0.3) {
            self.segmentedControl.isUserInteractionEnabled = isOn ? true : false
            self.segmentedControl.backgroundColor = isOn ? lightBlue : lightGray
            self.segmentedControl.selectedSegmentTintColor = isOn ? blue : gray
            self.segmentedControl.layer.borderColor = isOn ? lightBlue.cgColor : lightGray.cgColor
        }
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
    // MARK: - Setting checkmarks and buttons for select continents and picker views
    private func checkmarkPickerViews(isOn: Bool) {
        pickerViewOnOff(pickerView: pickerViewOneQuestion, isOn: isOn, tag: 2)
        pickerViewOnOff(pickerView: pickerViewAllQuestions, isOn: isOn, tag: 3)
    }
    
    private func pickerViewOnOff(pickerView: UIPickerView, isOn: Bool, tag: Int) {
        let lightGray = UIColor.skyGrayLight
        UIView.animate(withDuration: 0.3) { [self] in
            pickerView.isUserInteractionEnabled = isOn ? isEnabled(tag: tag) : false
            pickerView.backgroundColor = isOn ? isEnabledColor(tag: tag) : lightGray
        }
        pickerView.reloadAllComponents()
    }
    
    private func checkmark(isOn: Bool) -> String {
        isOn ? "checkmark.circle.fill" : "circle"
    }
    
    private func select(isOn: Bool) -> (UIColor, UIColor) {
        isOn ? (.cyanLight, .blueBlackSea) : (.skyCyanLight, .skyCyanLight)
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
        if countRows < mode.countRows {
            let countQuestions = countRows + 9
            
            mode.countRows = countRows
            pickerViewNumberQuestion.reloadAllComponents()
            pickerViewNumberQuestion.selectRow(countRows, inComponent: 0, animated: false)
            checkCountQuestions(countQuestions: countQuestions)
        } else {
            mode.countRows = countRows
            pickerViewNumberQuestion.reloadAllComponents()
        }
    }
    
    private func checkCountQuestions(countQuestions: Int) {
        if countQuestions < mode.countQuestions {
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
            let countQuestion = mode.countQuestions
            let currentTime = mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
            let currentRow = currentTime - (4 * countQuestion)
            
            segmentAction(pickerView: pickerViewOneQuestion, isEnabled: true, backgroundColor: lightBlue)
            segmentAction(pickerView: pickerViewAllQuestions, isEnabled: false, backgroundColor: lightGray)
            
            setupDataFromSegmentedControl(
                currentRow: currentRow,
                pickerView: pickerViewAllQuestions,
                oneQuestion: true,
                timeElapsedQuestion: "Время одного вопроса:",
                timeElapsedNumber: "\(mode.timeElapsed.questionSelect.questionTime.oneQuestionTime)")
        } else {
            let currentTime = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
            let currentRow = currentTime - 6
            
            segmentAction(pickerView: pickerViewOneQuestion, isEnabled: false, backgroundColor: lightGray)
            segmentAction(pickerView: pickerViewAllQuestions, isEnabled: true, backgroundColor: lightBlue)
            
            setupDataFromSegmentedControl(
                currentRow: currentRow,
                pickerView: pickerViewOneQuestion,
                oneQuestion: false,
                timeElapsedQuestion: "Время всех вопросов:",
                timeElapsedNumber: "\(mode.timeElapsed.questionSelect.questionTime.allQuestionsTime)")
        }
    }
    
    private func segmentAction(pickerView: UIPickerView,
                               isEnabled: Bool,
                               backgroundColor: UIColor) {
        pickerView.isUserInteractionEnabled = isEnabled
        UIView.animate(withDuration: 0.3) {
            pickerView.backgroundColor = backgroundColor
        }
        pickerView.reloadAllComponents()
    }
    
    private func setupDataFromSegmentedControl(currentRow: Int,
                                               pickerView: UIPickerView,
                                               oneQuestion: Bool,
                                               timeElapsedQuestion: String,
                                               timeElapsedNumber: String) {
        pickerView.selectRow(currentRow, inComponent: 0, animated: false)
        
        mode.timeElapsed.questionSelect.oneQuestion = oneQuestion
        
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
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if tag == 2 {
                return .blueBlackSea
            } else {
                return .grayLight
            }
        default:
            if tag == 2 {
                return .grayLight
            } else {
                return .blueBlackSea
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
    
    private func timeElapsed() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    // MARK: - Reset setting default
    private func resetSetting() {
        mode = Setting.getSettingDefault()
        
        setupLabels()
        checkmarkOnAllCountries()
        segmentedControl.selectedSegmentIndex = 0
        
        setupPickerViews()
        buttonIsEnabled()
    }
    
    private func setupLabels() {
        labelNumber.text = "\(mode.countQuestions)"
        labelTimeElapsedNumber.text = "\(mode.timeElapsed.questionSelect.questionTime.oneQuestionTime)"
    }
    
    private func setupPickerViews() {
        let countQuestions = mode.countQuestions - 10
        let averageTime = 5 * mode.countQuestions
        let timeOneQuestion = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime - 6
        let timeAllQuestions = averageTime - (4 * mode.countQuestions)
        
        setupPickerViews(pickerView: pickerViewNumberQuestion, row: countQuestions)
        setupPickerViews(pickerView: pickerViewOneQuestion, row: timeOneQuestion)
        setupPickerViews(pickerView: pickerViewAllQuestions, row: timeAllQuestions)
    }
    
    private func setupPickerViews(pickerView: UIPickerView, row: Int) {
        pickerView.reloadAllComponents()
        pickerView.selectRow(row, inComponent: 0, animated: false)
    }
    
    private func buttonIsEnabled() {
        conditions() ? buttonIsEnabled( isEnabled: true, color: .blueBlackSea) :
        buttonIsEnabled(isEnabled: false, color: .grayStone)
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
    private func setupButton(image: String, color: UIColor, action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = color
        button.layer.cornerRadius = 12
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
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
        button.configuration?.baseForegroundColor = .blueBlackSea
        button.configuration?.image = image
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonCheckmark), for: .touchUpInside)
        return button
    }
    
    private func setButtonContinents(color: UIColor, borderColor: UIColor, tag: Int,
                                     addLabelFirst: UILabel,
                                     addLabelSecond: UILabel) -> UIButton {
        let button = UIButton(type: .custom)
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
    private func setLabel(title: String, size: CGFloat, color: UIColor? = nil,
                          textAlignment: NSTextAlignment? = nil,
                          numberOfLines: Int? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color ?? .blueBlackSea
        label.textAlignment = textAlignment ?? .natural
        label.numberOfLines = numberOfLines ?? 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
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
            return mode.countRows
        case 2:
            return 10
        default:
            return (6 * mode.countQuestions) - (4 * mode.countQuestions) + 1
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
            view?.backgroundColor = .redTangerineTango
        case 2:
            title = "\(row + 6)"
            attributed = attributedStringTimeElapsed(title: title, tag: 2)
        default:
            let allQuestionTime = 4 * mode.countQuestions
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
            mode.timeElapsed.questionSelect.questionTime.oneQuestionTime = oneQuestionTime
            
        default:
            
            let allQuestionTime = row + (4 * mode.countQuestions)
            labelTimeElapsedNumber.text = "\(allQuestionTime)"
            mode.timeElapsed.questionSelect.questionTime.allQuestionsTime = allQuestionTime
            
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
            .foregroundColor: UIColor.blueBlackSea
        ])
    }
    
    private func attributedStringTimeElapsed(title: String, tag: Int) -> NSAttributedString {
        let color: UIColor = timeElapsed() ? isEnabledTextColor(tag: tag) : .grayLight
        return NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "mr_fontick", size: 26) ?? "",
            .foregroundColor: color
        ])
    }
    
    private func checkPickerViewEnabled(time: Int) -> String {
        let text = "\(mode.timeElapsed.questionSelect.questionTime.oneQuestionTime)"
        guard pickerViewAllQuestions.isUserInteractionEnabled else { return text }
        return "\(time)"
    }
    
    private func setupDataFromPickerView(countQuestion: Int, averageTime: Int, currentRow: Int) {
        labelNumber.text = "\(countQuestion)"
        labelTimeElapsedNumber.text = checkPickerViewEnabled(time: averageTime)
        
        mode.countQuestions = countQuestion
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime = averageTime
        
        setupPickerViews(pickerView: pickerViewAllQuestions, row: currentRow)
    }
}
// MARK: - Setup stack view
extension SettingViewController {
    private func setStackView(buttonFirst: UIButton, buttonSecond: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [buttonFirst, buttonSecond])
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
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
            stackViewButtons.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorCheck()),
            stackViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        setupSquare(subview: buttonBack, sizes: 40)
        setupSquare(subview: buttonDefault, sizes: 40)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: stackViewButtons.bottomAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackViewNumberQuestion.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            stackViewNumberQuestion.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 8),
            stackViewNumberQuestion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        setupConstraints(subviewFirst: pickerViewNumberQuestion,
                         to: stackViewNumberQuestion,
                         leadingConstant: 20, constant: 12)
        setupHeightSubview(subview: pickerViewNumberQuestion, height: 110)
        
        setupConstraints(
            subviewFirst: buttonAllCountries, to: pickerViewNumberQuestion,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnbutton(
            labelFirst: labelAllCountries, and: labelCountAllCountries,
            button: buttonAllCountries)
        setupHeightSubview(subview: buttonAllCountries, height: 60)
        
        setupConstraints(
            subviewFirst: buttonAmericaContinent, to: buttonAllCountries,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnbutton(
            labelFirst: labelAmericaContinent, and: labelCountAmericaContinent,
            button: buttonAmericaContinent)
        setupHeightSubview(subview: buttonAmericaContinent, height: 60)
        
        setupConstraints(
            subviewFirst: buttonEuropeContinent, to: buttonAmericaContinent,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnbutton(
            labelFirst: labelEuropeContinent, and: labelCountEuropeContinent,
            button: buttonEuropeContinent)
        setupHeightSubview(subview: buttonEuropeContinent, height: 60)
        
        setupConstraints(
            subviewFirst: buttonAfricaContinent, to: buttonEuropeContinent,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnbutton(
            labelFirst: labelAfricaContinent, and: labelCountAfricaContinent,
            button: buttonAfricaContinent)
        setupHeightSubview(subview: buttonAfricaContinent, height: 60)
        
        setupConstraints(
            subviewFirst: buttonAsiaContinent, to: buttonAfricaContinent,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnbutton(
            labelFirst: labelAsiaContinent, and: labelCountAsiaContinent,
            button: buttonAsiaContinent)
        setupHeightSubview(subview: buttonAsiaContinent, height: 60)
        
        setupConstraints(
            subviewFirst: buttonOceaniaContinent, to: buttonAsiaContinent,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnbutton(
            labelFirst: labelOceaniaContinent, and: labelCountOceaniaContinent,
            button: buttonOceaniaContinent)
        setupHeightSubview(subview: buttonOceaniaContinent, height: 60)
        
        setupConstraints(subviewFirst: stackViewTimeElapsed,
                         to: buttonOceaniaContinent,
                         leadingConstant: 20, constant: 15)
        setupSquare(subview: viewTimeElapsed, sizes: 60)
        setupConstraintsCentersOnView(viewFirst: buttonTimeElapsed, on: viewTimeElapsed)
        setupSquare(subview: buttonTimeElapsed, sizes: 50)
        
        setupConstraints(subviewFirst: stackViewLabelTimeElapsed,
                         to: stackViewTimeElapsed,
                         leadingConstant: view.frame.width / 8,
                         constant: 15)
        
        setupConstraints(subviewFirst: segmentedControl,
                         to: stackViewLabelTimeElapsed,
                         leadingConstant: 20, constant: 15)
        setupHeightSubview(subview: segmentedControl, height: 40)
        
        setupConstraints(subviewFirst: stackViewPickerViews,
                         to: segmentedControl,
                         leadingConstant: 20, constant: 15)
        setupHeightSubview(subview: stackViewPickerViews, height: 110)
    }
    
    private func setupConstraints(subviewFirst: UIView, to subviewSecond: UIView,
                                  leadingConstant: CGFloat, constant: CGFloat) {
        NSLayoutConstraint.activate([
            subviewFirst.topAnchor.constraint(equalTo: subviewSecond.bottomAnchor, constant: constant),
            subviewFirst.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            subviewFirst.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
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
    
    private func setupConstraintsOnbutton(labelFirst: UILabel, and labelSecond: UILabel,
                                          button: UIButton) {
        NSLayoutConstraint.activate([
            labelFirst.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            labelFirst.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: -12.5),
            labelSecond.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            labelSecond.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 12.5)
        ])
    }
    
    private func fixConstraintsForViewPanelBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 110 : 70
    }
    
    private func fixSizeForContentViewBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 180 : 320
    }
    
    private func topAnchorCheck() -> CGFloat {
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
