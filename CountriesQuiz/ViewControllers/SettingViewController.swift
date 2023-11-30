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
        setupButton(
            image: "multiply",
            color: .white,
            action: #selector(backToMenu))
    }()
    
    private lazy var buttonDefault: UIButton = {
        setupButton(
            image: "arrow.counterclockwise",
            color: conditions() ? .white : .grayStone,
            isEnabled: conditions() ? true : false,
            action: #selector(defaultSetting))
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        setStackView(buttonFirst: buttonBack, buttonSecond: buttonDefault)
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = setView(color: .blueMiddlePersian)
        view.frame.size = contentSize
        return view
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + checkSizeScreenIphone())
    }
    
    private lazy var labelNumberQuestions: UILabel = {
        setLabel(
            title: "Количество вопросов",
            size: 26,
            color: .white,
            textAlignment: .center,
            numberOfLines: 1)
    }()
    
    private lazy var labelNumber: UILabel = {
        setLabel(title: "\(mode.countQuestions)", size: 26, color: .white)
    }()
    
    private lazy var stackViewNumberQuestion: UIStackView = {
        setStackViewLabels(
            labelFirst: labelNumberQuestions,
            labelSecond: labelNumber,
            spacing: 10)
    }()
    
    private lazy var pickerViewNumberQuestion: UIPickerView = {
        setPickerView(backgroundColor: .white, tag: 1)
    }()
    
    private lazy var labelAllCountries: UILabel = {
        setLabel(
            title: "Все страны мира",
            size: 26,
            color: select(isOn: mode.allCountries))
    }()
    
    private lazy var labelCountAllCountries: UILabel = {
        setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countries.count)",
            size: 20,
            color: select(isOn: mode.allCountries))
    }()
    
    private lazy var buttonAllCountries: UIButton = {
        setButtonContinents(
            color: select(isOn: !mode.allCountries),
            tag: 1,
            addLabelFirst: labelAllCountries,
            addLabelSecond: labelCountAllCountries)
    }()
    
    private lazy var labelAmericaContinent: UILabel = {
        setLabel(
            title: "Континент Америки",
            size: 26,
            color: select(isOn: mode.americaContinent))
    }()
    
    private lazy var labelCountAmericaContinent: UILabel = {
        setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAmericanContinent.count)",
            size: 20,
            color: select(isOn: mode.americaContinent))
    }()
    
    private lazy var buttonAmericaContinent: UIButton = {
        setButtonContinents(
            color: select(isOn: !mode.americaContinent),
            tag: 2,
            addLabelFirst: labelAmericaContinent,
            addLabelSecond: labelCountAmericaContinent)
    }()
    
    private lazy var labelEuropeContinent: UILabel = {
        setLabel(
            title: "Континент Европы",
            size: 26,
            color: select(isOn: mode.europeContinent))
    }()
    
    private lazy var labelCountEuropeContinent: UILabel = {
        setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfEuropeanContinent.count)",
            size: 20,
            color: select(isOn: mode.europeContinent))
    }()
    
    private lazy var buttonEuropeContinent: UIButton = {
        setButtonContinents(
            color: select(isOn: !mode.europeContinent),
            tag: 3,
            addLabelFirst: labelEuropeContinent,
            addLabelSecond: labelCountEuropeContinent)
    }()
    
    private lazy var labelAfricaContinent: UILabel = {
        setLabel(
            title: "Континент Африки",
            size: 26,
            color: select(isOn: mode.africaContinent))
    }()
    
    private lazy var labelCountAfricaContinent: UILabel = {
        setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAfricanContinent.count)",
            size: 20,
            color: select(isOn: mode.africaContinent))
    }()
    
    private lazy var buttonAfricaContinent: UIButton = {
        setButtonContinents(
            color: select(isOn: !mode.africaContinent),
            tag: 4,
            addLabelFirst: labelAfricaContinent,
            addLabelSecond: labelCountAfricaContinent)
    }()
    
    private lazy var labelAsiaContinent: UILabel = {
        setLabel(
            title: "Континент Азии",
            size: 26,
            color: select(isOn: mode.asiaContinent))
    }()
    
    private lazy var labelCountAsiaContinent: UILabel = {
        setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAsianContinent.count)",
            size: 20,
            color: select(isOn: mode.asiaContinent))
    }()
    
    private lazy var buttonAsiaContinent: UIButton = {
        setButtonContinents(
            color: select(isOn: !mode.asiaContinent),
            tag: 5,
            addLabelFirst: labelAsiaContinent,
            addLabelSecond: labelCountAsiaContinent)
    }()
    
    private lazy var labelOceaniaContinent: UILabel = {
        setLabel(
            title: "Континент Океании",
            size: 26,
            color: select(isOn: mode.oceaniaContinent))
    }()
    
    private lazy var labelCountOceaniaContinent: UILabel = {
        setLabel(
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfOceanContinent.count)",
            size: 20,
            color: select(isOn: mode.oceaniaContinent))
    }()
    
    private lazy var buttonOceaniaContinent: UIButton = {
        setButtonContinents(
            color: select(isOn: !mode.oceaniaContinent),
            tag: 6,
            addLabelFirst: labelOceaniaContinent,
            addLabelSecond: labelCountOceaniaContinent)
    }()
    
    private lazy var viewTimeElapsed: UIView = {
        setView(color: .white, radiusCorner: 13, addButton: buttonTimeElapsed)
    }()
    
    private lazy var buttonTimeElapsed: UIButton = {
        setButtonCheckmark(image: checkmark(isOn: isTime()), tag: 7)
    }()
    
    private lazy var labelTimeElapsed: UILabel = {
        setLabel(title: "Обратный отсчет", size: 26, textAlignment: .center)
    }()
    
    private lazy var stackViewTimeElapsed: UIStackView = {
        setStackViewCheckmark(view: viewTimeElapsed, label: labelTimeElapsed)
    }()
    
    private lazy var labelTimeElapsedQuestion: UILabel = {
        setLabel(
            title: isEnabledText(),
            size: 26,
            color: isTime() ? .white : .skyGrayLight,
            numberOfLines: 1)
    }()
    
    private lazy var labelTimeElapsedNumber: UILabel = {
        setLabel(
            title: setLabelNumberQuestions(),
            size: 26,
            color: isTime() ? .white : .skyGrayLight)
    }()
    
    private lazy var stackViewLabelTimeElapsed: UIStackView = {
        setStackViewLabels(
            labelFirst: labelTimeElapsedQuestion,
            labelSecond: labelTimeElapsedNumber,
            spacing: 10)
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Один вопрос", "Все вопросы"])
        let font = UIFont(name: "mr_fontick", size: 26)
        let titleColorSelected: UIColor = isTime() ? .white : .skyGrayLight
        let titleColorNormal: UIColor = isTime() ? .blueMiddlePersian : .grayLight
        let borderColor: UIColor = isTime() ? .white : .skyGrayLight
        segment.backgroundColor = isTime() ? .white : .skyGrayLight
        segment.selectedSegmentTintColor = isTime() ? .blueMiddlePersian : .grayLight
        segment.setTitleTextAttributes([
            NSAttributedString.Key
                .font: font ?? "",
                .foregroundColor: titleColorSelected
        ], for: .selected)
        segment.setTitleTextAttributes([
            NSAttributedString.Key
                .font: font ?? "",
                .foregroundColor: titleColorNormal
        ], for: .normal)
        segment.selectedSegmentIndex = isOneQuestion() ? 0 : 1
        segment.isUserInteractionEnabled = isTime() ? true : false
        segment.layer.borderWidth = 5
        segment.layer.borderColor = borderColor.cgColor
        segment.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private lazy var pickerViewOneQuestion: UIPickerView = {
        setPickerView(
            backgroundColor: isTime() ? isEnabledColor(tag: 2) : .skyGrayLight,
            tag: 2,
            isEnabled: isTime() ? isEnabled(tag: 2) : false)
    }()
    
    private lazy var pickerViewAllQuestions: UIPickerView = {
        setPickerView(
            backgroundColor: isTime() ? isEnabledColor(tag: 3) : .skyGrayLight,
            tag: 3,
            isEnabled: isTime() ? isEnabled(tag: 3) : false)
    }()
    
    private lazy var stackViewPickerViews: UIStackView = {
        setStackViewPickerViews(
            pickerViewFirst: pickerViewOneQuestion,
            pickerViewSecond: pickerViewAllQuestions)
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
        view.backgroundColor = .blueMiddlePersian
        setupPickerViewNumberQuestions()
        setupPickerViewOneQuestion()
    }
    
    private func setupPickerViewNumberQuestions() {
        let row = mode.countQuestions - 10
        pickerViewNumberQuestion.selectRow(row, inComponent: 0, animated: false)
        setupPickerViewAllQuestions(countQuestions: mode.countQuestions)
    }
    
    private func setupPickerViewOneQuestion() {
        let row = oneQuestionTime() - 6
        pickerViewOneQuestion.selectRow(row, inComponent: 0, animated: false)
    }
    
    private func setupPickerViewAllQuestions(countQuestions: Int) {
        let row = allQuestionsTime() - 4 * countQuestions
        pickerViewAllQuestions.selectRow(row, inComponent: 0, animated: false)
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
    // MARK: - Constants
    private func oneQuestionTime(time: Int) {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime = time
    }
    
    private func allQuestionsTime(time: Int) {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime = time
    }
    
    private func oneQuestionTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    
    private func allQuestionsTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    // MARK: - Setting label of number questions
    private func setLabelNumberQuestions() -> String {
        let isEnabled = pickerViewOneQuestion.isUserInteractionEnabled
        let oneQuestion = oneQuestionTime()
        let allQuestion = allQuestionsTime()
        return isEnabled ? "\(oneQuestion)" : "\(allQuestion)"
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
        buttonOnOff(buttons: buttonAllCountries, color: .white)
        buttonOnOff(buttons: buttonAmericaContinent, buttonEuropeContinent,
                    buttonAfricaContinent, buttonAsiaContinent,
                    buttonOceaniaContinent, color: .blueMiddlePersian)
        
        labelOnOff(labels: labelAllCountries, labelCountAllCountries,
                   color: .blueMiddlePersian)
        labelOnOff(labels: labelAmericaContinent, labelCountAmericaContinent,
                   labelEuropeContinent, labelCountEuropeContinent,
                   labelAfricaContinent, labelCountAfricaContinent,
                   labelAsiaContinent, labelCountAsiaContinent,
                   labelOceaniaContinent, labelCountOceaniaContinent,
                   color: .white)
    }
    
    private func settingOnAllCountries() {
        checkmarkSettingOnOff(buttons: buttonAllCountries, bool: true)
        checkmarkSettingOnOff(buttons: buttonAmericaContinent, buttonEuropeContinent,
                              buttonAfricaContinent, buttonAsiaContinent,
                              buttonOceaniaContinent, bool: false)
    }
    
    private func buttonOnOff(buttons: UIButton..., color: UIColor) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.backgroundColor = color
            }
        }
    }
    
    private func labelOnOff(labels: UILabel..., color: UIColor) {
        labels.forEach { label in
            UIView.animate(withDuration: 0.3) {
                label.textColor = color
            }
        }
    }
    
    private func labelOnOff(button: UIButton, color: UIColor) {
        switch button.tag {
        case 2:
            labelOnOff(labels: labelAmericaContinent,
                       labelCountAmericaContinent, color: color)
        case 3:
            labelOnOff(labels: labelEuropeContinent,
                       labelCountEuropeContinent, color: color)
        case 4:
            labelOnOff(labels: labelAfricaContinent,
                       labelCountAfricaContinent, color: color)
        case 5:
            labelOnOff(labels: labelAsiaContinent,
                       labelCountAsiaContinent, color: color)
        default:
            labelOnOff(labels: labelOceaniaContinent,
                       labelCountOceaniaContinent, color: color)
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
            buttonOnOff(buttons: buttonAllCountries, color: .blueMiddlePersian)
            buttonOnOff(buttons: button, color: select(isOn: !isOn))
            
            labelOnOff(labels: labelAllCountries, labelCountAllCountries,
                       color: .white)
            labelOnOff(button: button, color: select(isOn: isOn))
            checkmarkSettingOnOff(buttons: buttonAllCountries, bool: false)
        }
    }
    
    private func checkmarkTimeElapsed(button: UIButton) {
        mode.timeElapsed.timeElapsed.toggle()
        let isOn = isTime()
        checkmarkOnOff(buttons: button, image: checkmark(isOn: isOn))
        checkmarkColors(isOn: isOn)
    }
    
    private func checkmarkColors(isOn: Bool) {
        checkmarkLabels(white: .white, gray: .skyGrayLight, isOn: isOn)
        checkmarkSegmentedControl(blue: .blueMiddlePersian, gray: .grayLight, isOn: isOn)
        checkmarkPickerViews(isOn: isOn)
    }
    
    private func checkmarkLabels(white: UIColor, gray: UIColor, isOn: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.labelTimeElapsedQuestion.textColor = isOn ? white : gray
            self.labelTimeElapsedNumber.textColor = isOn ? white : gray
        }
    }
    
    private func checkmarkSegmentedControl(blue: UIColor, gray: UIColor, isOn: Bool) {
        let white = UIColor.white
        let lightGray = UIColor.skyGrayLight
        UIView.animate(withDuration: 0.3) { [self] in
            segmentedControl.isUserInteractionEnabled = isOn ? true : false
            segmentedControl.backgroundColor = isOn ? white : lightGray
            segmentedControl.selectedSegmentTintColor = isOn ? blue : gray
            segmentedControl.layer.borderColor = isOn ? white.cgColor : lightGray.cgColor
        }
        segmentSelectColors(blue: blue, gray: gray, white: white,
                            lightGray: lightGray, isOn: isOn)
    }
    
    private func segmentSelectColors(blue: UIColor, gray: UIColor, white: UIColor,
                                     lightGray: UIColor, isOn: Bool) {
        let font = UIFont(name: "mr_fontick", size: 26)
        let titleSelectedColor: UIColor = isOn ? white : lightGray
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
        UIView.animate(withDuration: 0.3) { [self] in
            pickerView.isUserInteractionEnabled = isOn ? isEnabled(tag: tag) : false
            pickerView.backgroundColor = isOn ? isEnabledColor(tag: tag) : .skyGrayLight
        }
        pickerView.reloadAllComponents()
    }
    
    private func checkmark(isOn: Bool) -> String {
        isOn ? "checkmark.circle.fill" : "circle"
    }
    
    private func select(isOn: Bool) -> UIColor {
        isOn ? .blueMiddlePersian : .white
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
        if segmentedControl.selectedSegmentIndex == 0 {
            let countQuestion = mode.countQuestions
            let currentTime = allQuestionsTime()
            let currentRow = currentTime - (4 * countQuestion)
            
            segmentAction(pickerView: pickerViewOneQuestion, isEnabled: true, backgroundColor: .white)
            segmentAction(pickerView: pickerViewAllQuestions, isEnabled: false, backgroundColor: .skyGrayLight)
            
            setupDataFromSegmentedControl(
                currentRow: currentRow,
                pickerView: pickerViewAllQuestions,
                oneQuestion: true,
                timeElapsedQuestion: "Время одного вопроса:",
                timeElapsedNumber: "\(oneQuestionTime())")
        } else {
            let currentTime = oneQuestionTime()
            let currentRow = currentTime - 6
            
            segmentAction(pickerView: pickerViewOneQuestion, isEnabled: false, backgroundColor: .skyGrayLight)
            segmentAction(pickerView: pickerViewAllQuestions, isEnabled: true, backgroundColor: .white)
            
            setupDataFromSegmentedControl(
                currentRow: currentRow,
                pickerView: pickerViewOneQuestion,
                oneQuestion: false,
                timeElapsedQuestion: "Время всех вопросов:",
                timeElapsedNumber: "\(allQuestionsTime())")
        }
    }
    
    private func segmentAction(pickerView: UIPickerView, isEnabled: Bool,
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
            return tag == 2 ? true : false
        default:
            return tag == 2 ? false : true
        }
    }
    
    private func isEnabledColor(tag: Int) -> UIColor {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return tag == 2 ? .white : .skyGrayLight
        default:
            return tag == 2 ? .skyGrayLight : .white
        }
    }
    
    private func isEnabledTextColor(tag: Int) -> UIColor {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return tag == 2 ? .blueMiddlePersian : .grayLight
        default:
            return tag == 2 ? .grayLight : .blueMiddlePersian
        }
    }
    
    private func isEnabledText() -> String {
        let segmentIndex = segmentedControl.selectedSegmentIndex == 0
        return segmentIndex ? "Время одного вопроса:" : "Время всех вопросов:"
    }
    
    private func isTime() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    private func isOneQuestion() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
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
        labelTimeElapsedNumber.text = "\(oneQuestionTime())"
    }
    
    private func setupPickerViews() {
        let countQuestions = mode.countQuestions - 10
        let averageTime = 5 * mode.countQuestions
        let timeOneQuestion = oneQuestionTime() - 6
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
        conditions() ? buttonIsEnabled(isEnabled: true, color: .white) :
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
                view.layer.shadowColor = color.cgColor
                view.layer.shadowOpacity = 0.4
                view.layer.shadowOffset = CGSize(width: 0, height: 6)
            }
        }
        return view
    }
}
// MARK: - Setup button
extension SettingViewController {
    private func setupButton(image: String, color: UIColor, isEnabled: Bool? = nil,
                             action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = color
        button.layer.cornerRadius = 12
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1.5
        button.isEnabled = isEnabled ?? true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButtonCheckmark(image: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: image, withConfiguration: configuration)
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = .blueMiddlePersian
        button.configuration?.image = image
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonCheckmark), for: .touchUpInside)
        return button
    }
    
    private func setButtonContinents(color: UIColor, tag: Int,
                                     addLabelFirst: UILabel,
                                     addLabelSecond: UILabel) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = color
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 13
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
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
        label.textColor = color ?? .white
        label.textAlignment = textAlignment ?? .natural
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
        switch pickerView.tag {
        case 1:
            return mode.countRows
        case 2:
            return 10
        default:
            return (6 * mode.countQuestions) - (4 * mode.countQuestions) + 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent 
                    component: Int, reusing view: UIView?) -> UIView {
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
            let allQuestionTime = 4 * mode.countQuestions
            title = "\(row + allQuestionTime)"
            attributed = attributedStringTimeElapsed(title: title, tag: 3)
        }
        
        label.textAlignment = .center
        label.attributedText = attributed
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, 
                    inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            
            let countQuestion = row + 10
            let averageTime = 5 * countQuestion
            let rowAverageTime = averageTime - (4 * countQuestion)
            
            mode.countQuestions = countQuestion
            setupDataFromPickerView(countQuestion: countQuestion,
                                    averageTime: averageTime,
                                    currentRow: rowAverageTime)
            buttonIsEnabled()
            
        case 2:
            
            let time = row + 6
            labelTimeElapsedNumber.text = "\(time)"
            oneQuestionTime(time: time)
            
        default:
            
            let time = row + (4 * mode.countQuestions)
            labelTimeElapsedNumber.text = "\(time)"
            allQuestionsTime(time: time)
            
        }
    }
    
    private func setPickerView(backgroundColor: UIColor, tag: Int,
                               isEnabled: Bool? = nil) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = backgroundColor
        pickerView.layer.cornerRadius = 13
        pickerView.tag = tag
        pickerView.isUserInteractionEnabled = isEnabled ?? true
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }
    
    private func attributedString(title: String) -> NSAttributedString {
        NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "mr_fontick", size: 26) ?? "",
            .foregroundColor: UIColor.blueMiddlePersian
        ])
    }
    
    private func attributedStringTimeElapsed(title: String, tag: Int) -> NSAttributedString {
        let color: UIColor = isTime() ? isEnabledTextColor(tag: tag) : .grayLight
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
        allQuestionsTime(time: averageTime)
        
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
        setupConstraintsOnButton(
            labelFirst: labelAllCountries, and: labelCountAllCountries,
            button: buttonAllCountries)
        setupHeightSubview(subview: buttonAllCountries, height: 60)
        
        setupConstraints(
            subviewFirst: buttonAmericaContinent, to: buttonAllCountries,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnButton(
            labelFirst: labelAmericaContinent, and: labelCountAmericaContinent,
            button: buttonAmericaContinent)
        setupHeightSubview(subview: buttonAmericaContinent, height: 60)
        
        setupConstraints(
            subviewFirst: buttonEuropeContinent, to: buttonAmericaContinent,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnButton(
            labelFirst: labelEuropeContinent, and: labelCountEuropeContinent,
            button: buttonEuropeContinent)
        setupHeightSubview(subview: buttonEuropeContinent, height: 60)
        
        setupConstraints(
            subviewFirst: buttonAfricaContinent, to: buttonEuropeContinent,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnButton(
            labelFirst: labelAfricaContinent, and: labelCountAfricaContinent,
            button: buttonAfricaContinent)
        setupHeightSubview(subview: buttonAfricaContinent, height: 60)
        
        setupConstraints(
            subviewFirst: buttonAsiaContinent, to: buttonAfricaContinent,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnButton(
            labelFirst: labelAsiaContinent, and: labelCountAsiaContinent,
            button: buttonAsiaContinent)
        setupHeightSubview(subview: buttonAsiaContinent, height: 60)
        
        setupConstraints(
            subviewFirst: buttonOceaniaContinent, to: buttonAsiaContinent,
            leadingConstant: 20, constant: 15)
        setupConstraintsOnButton(
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
    
    private func setupConstraintsOnButton(labelFirst: UILabel, and labelSecond: UILabel,
                                          button: UIButton) {
        NSLayoutConstraint.activate([
            labelFirst.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            labelFirst.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: -12.5),
            labelSecond.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            labelSecond.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 12.5)
        ])
    }
    
    private func checkSizeScreenIphone() -> CGFloat {
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
