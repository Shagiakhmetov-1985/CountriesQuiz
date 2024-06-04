//
//  SettingViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 19.05.2024.
//

import UIKit

protocol SettingViewModelProtocol {
    var countQuestions: Int { get }
    var countRows: Int { get }
    var countCountries: Int { get }
    var countCountriesOfAmerica: Int { get }
    var countCountriesOfEurope: Int { get }
    var countCountriesOfAfrica: Int { get }
    var countCountriesOfAsia: Int { get }
    var countCountriesOfOceania: Int { get }
    var allCountries: Bool { get }
    var americaContinent: Bool { get }
    var europeContinent: Bool { get }
    var africaContinent: Bool { get }
    var asiaContinent: Bool { get }
    var oceaniaContinent: Bool { get }
    var oneQuestionTime: Int { get }
    var allQuestionsTime: Int { get }
    
    var mode: Setting { get }
    
    init(mode: Setting)
    
    func setButtons(_ allCountries: UIButton,_ americaContinent: UIButton,_ europeContinent: UIButton,
                    _ africaContinent: UIButton,_ asiaContinent: UIButton,_ oceaniaContinent: UIButton)
    func setLabels(_ allCountries: UILabel,_ countAllCountries: UILabel,
                   _ americaContinent: UILabel,_ countAmericaContinent: UILabel,
                   _ europeContinent: UILabel,_ countEuropeContinent: UILabel,
                   _ africaContinent: UILabel,_ countAfricaContinent: UILabel,
                   _ asiaContinent: UILabel,_ countAsiaContinent: UILabel,
                   _ oceaniaContinent: UILabel,_ countOceaniaContinent: UILabel,
                   _ labelTimeQuestion: UILabel,_ labelTimeNumber: UILabel,_ labelNum: UILabel)
    func setSegmentedControl(_ segmentControl: UISegmentedControl)
    func setPickerViews(_ pickerViewOne: UIPickerView,_ pickerViewAll: UIPickerView,_ pickerViewNumber: UIPickerView)
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    
    func contentSize(_ view: UIView?) -> CGSize
    func isTime() -> Bool
    func isOneQuestion() -> Bool
    func topAnchorCheck(_ view: UIView) -> CGFloat
    func select(isOn: Bool) -> UIColor
    func checkmark(isOn: Bool) -> String
    func isMoreFiftyQuestions() -> Bool
    
    func setOneQuestionTime(_ time: Int)
    func setAllQuestionsTime(_ time: Int)
    func setCountQuestions(_ countQuestions: Int)
    func setCountRows(_ countRows: Int)
    func setOneQuestion(_ isOn: Bool)
    func setMode(_ mode: Setting)
    func setTimeToggle(_ isOn: Bool)
    func setCountCountries(continents: Bool...)
    
    func buttonCheckmark(sender: UIButton)
}

class SettingViewModel: SettingViewModelProtocol {
    var countQuestions: Int {
        mode.countQuestions
    }
    var countRows: Int {
        mode.countRows
    }
    var countCountries: Int {
        FlagsOfCountries.shared.countries.count
    }
    var countCountriesOfAmerica: Int {
        FlagsOfCountries.shared.countriesOfAmericanContinent.count
    }
    var countCountriesOfEurope: Int {
        FlagsOfCountries.shared.countriesOfEuropeanContinent.count
    }
    var countCountriesOfAfrica: Int {
        FlagsOfCountries.shared.countriesOfAfricanContinent.count
    }
    var countCountriesOfAsia: Int {
        FlagsOfCountries.shared.countriesOfAsianContinent.count
    }
    var countCountriesOfOceania: Int {
        FlagsOfCountries.shared.countriesOfOceanContinent.count
    }
    var allCountries: Bool {
        mode.allCountries
    }
    var americaContinent: Bool {
        mode.americaContinent
    }
    var europeContinent: Bool {
        mode.europeContinent
    }
    var africaContinent: Bool {
        mode.africaContinent
    }
    var asiaContinent: Bool {
        mode.asiaContinent
    }
    var oceaniaContinent: Bool {
        mode.oceaniaContinent
    }
    var oneQuestionTime: Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    var allQuestionsTime: Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    
    var mode: Setting
    
    private var defaultCountRows: Int {
        DefaultSetting.countRows.rawValue
    }
    
    private var buttonAllCountries: UIButton!
    private var buttonAmericaContinent: UIButton!
    private var buttonEuropeContinent: UIButton!
    private var buttonAfricaContinent: UIButton!
    private var buttonAsiaContinent: UIButton!
    private var buttonOceaniaContinent: UIButton!
    
    private var labelAllCountries: UILabel!
    private var labelCountAllCountries: UILabel!
    private var labelAmericaContinent: UILabel!
    private var labelCountAmericaContinent: UILabel!
    private var labelEuropeContinent: UILabel!
    private var labelCountEuropeContinent: UILabel!
    private var labelAfricaContinent: UILabel!
    private var labelCountAfricaContinent: UILabel!
    private var labelAsiaContinent: UILabel!
    private var labelCountAsiaContinent: UILabel!
    private var labelOceaniaContinent: UILabel!
    private var labelCountOceaniaContinent: UILabel!
    private var labelTimeElapsedQuestion: UILabel!
    private var labelTimeElapsedNumber: UILabel!
    private var labelNumber: UILabel!
    
    private var segmentedControl: UISegmentedControl!
    
    private var pickerViewOneQuestion: UIPickerView!
    private var pickerViewAllQuestions: UIPickerView!
    private var pickerViewNumberQuestion: UIPickerView!
    
    required init(mode: Setting) {
        self.mode = mode
    }
    // MARK: - Set subviews
    func setButtons(_ allCountries: UIButton, _ americaContinent: UIButton, 
                    _ europeContinent: UIButton, _ africaContinent: UIButton,
                    _ asiaContinent: UIButton, _ oceaniaContinent: UIButton) {
        buttonAllCountries = allCountries
        buttonAmericaContinent = americaContinent
        buttonEuropeContinent = europeContinent
        buttonAfricaContinent = africaContinent
        buttonAsiaContinent = asiaContinent
        buttonOceaniaContinent = oceaniaContinent
    }
    
    func setLabels(_ allCountries: UILabel, _ countAllCountries: UILabel, 
                   _ americaContinent: UILabel, _ countAmericaContinent: UILabel,
                   _ europeContinent: UILabel, _ countEuropeContinent: UILabel,
                   _ africaContinent: UILabel, _ countAfricaContinent: UILabel,
                   _ asiaContinent: UILabel, _ countAsiaContinent: UILabel,
                   _ oceaniaContinent: UILabel, _ countOceaniaContinent: UILabel,
                   _ labelTimeQuestion: UILabel, _ labelTimeNumber: UILabel,
                   _ labelNum: UILabel) {
        labelAllCountries = allCountries
        labelCountAllCountries = countAllCountries
        labelAmericaContinent = americaContinent
        labelCountAmericaContinent = countAmericaContinent
        labelEuropeContinent = europeContinent
        labelCountEuropeContinent = countEuropeContinent
        labelAfricaContinent = africaContinent
        labelCountAfricaContinent = countAfricaContinent
        labelAsiaContinent = asiaContinent
        labelCountAsiaContinent = countAsiaContinent
        labelOceaniaContinent = oceaniaContinent
        labelCountOceaniaContinent = countOceaniaContinent
        labelTimeElapsedQuestion = labelTimeQuestion
        labelTimeElapsedNumber = labelTimeNumber
        labelNumber = labelNum
    }
    
    func setSegmentedControl(_ segmentControl: UISegmentedControl) {
        segmentedControl = segmentControl
    }
    
    func setPickerViews(_ pickerViewOne: UIPickerView, _ pickerViewAll: UIPickerView, _ pickerViewNumber: UIPickerView) {
        pickerViewOneQuestion = pickerViewOne
        pickerViewAllQuestions = pickerViewAll
        pickerViewNumberQuestion = pickerViewNumber
    }
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    // MARK: - Constants
    func contentSize(_ view: UIView?) -> CGSize {
        guard let view = view else { return CGSize(width: 0, height: 0) }
        return CGSize(width: view.frame.width, height: view.frame.height + checkSizeScreenIphone(view))
    }
    
    func isTime() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    func isOneQuestion() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    
    func topAnchorCheck(_ view: UIView) -> CGFloat {
        view.frame.height > 736 ? 60 : 30
    }
    
    func select(isOn: Bool) -> UIColor {
        isOn ? .blueMiddlePersian : .white
    }
    
    func checkmark(isOn: Bool) -> String {
        isOn ? "checkmark.circle.fill" : "circle"
    }
    
    func isMoreFiftyQuestions() -> Bool {
        !allCountries && countQuestions > 50
    }
    // MARK: - Set new constants
    func setOneQuestionTime(_ time: Int) {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime = time
    }
    
    func setAllQuestionsTime(_ time: Int) {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime = time
    }
    
    func setCountQuestions(_ countQuestions: Int) {
        mode.countQuestions = countQuestions
    }
    
    func setCountRows(_ countRows: Int) {
        mode.countRows = countRows
    }
    
    func setOneQuestion(_ isOn: Bool) {
        mode.timeElapsed.questionSelect.oneQuestion = isOn
    }
    
    func setMode(_ setting: Setting) {
        mode = setting
    }
    
    func setTimeToggle(_ isOn: Bool) {
        let toggle = isOn ? false : true
        mode.timeElapsed.timeElapsed = toggle
    }
    // MARK: - Press buttons of continents
    func buttonCheckmark(sender: UIButton) {
        switch sender {
        case buttonAllCountries:
            buttonOnAllCountries()
            labelsOnAllCountries()
            settingOnAllCountries()
        case buttonAmericaContinent:
            setCheckmarkToggle(buttons: sender, isOn: americaContinent)
            
        default:
            checkmarkTimeElapsed(button: sender)
        }
    }
    // MARK: - Set count countries from checkmarks
    func setCountCountries(continents: Bool...) {
        var count = 0
        var counter = 0
        continents.forEach { continent in
            counter += 1
            if continent {
                count += checkCountCountries(continent: counter)
            }
        }
        count = checkCountRows(count: count - 9)
        
    }
    // MARK: - Constants, countinue
    private func checkSizeScreenIphone(_ view: UIView) -> CGFloat {
        view.frame.height > 736 ? 180 : 320
    }
    // MARK: - Change color buttons and labels of continents
    private func buttonOnAllCountries() {
        buttonOnOff(buttons: buttonAllCountries, color: .white)
        buttonOnOff(buttons: buttonAmericaContinent, buttonEuropeContinent,
                    buttonAfricaContinent, buttonAsiaContinent,
                    buttonOceaniaContinent, color: .blueMiddlePersian)
    }
    
    private func labelsOnAllCountries() {
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
        checkmarkSettingOnOff(buttons: buttonAllCountries, isOn: true)
        checkmarkSettingOnOff(buttons: buttonAmericaContinent, buttonEuropeContinent,
                              buttonAfricaContinent, buttonAsiaContinent,
                              buttonOceaniaContinent, isOn: false)
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
        case 2: labelOnOff(labels: labelAmericaContinent, labelCountAmericaContinent, color: color)
        case 3: labelOnOff(labels: labelEuropeContinent, labelCountEuropeContinent, color: color)
        case 4: labelOnOff(labels: labelAfricaContinent, labelCountAfricaContinent, color: color)
        case 5: labelOnOff(labels: labelAsiaContinent, labelCountAsiaContinent, color: color)
        default: labelOnOff(labels: labelOceaniaContinent, labelCountOceaniaContinent, color: color)
        }
    }
    
    private func checkmarkSettingOnOff(buttons: UIButton..., isOn: Bool) {
        buttons.forEach { button in
            switch button.tag {
            case 1: mode.allCountries = isOn
            case 2: mode.americaContinent = isOn
            case 3: mode.europeContinent = isOn
            case 4: mode.africaContinent = isOn
            case 5: mode.asiaContinent = isOn
            default: mode.oceaniaContinent = isOn
            }
        }
    }
    
    private func setCheckmarkToggle(buttons: UIButton..., isOn: Bool) {
        let toggle = isOn ? false : true
        buttons.forEach { button in
            switch button.tag {
            case 1: mode.allCountries = toggle
            case 2: mode.americaContinent = toggle
            case 3: mode.europeContinent = toggle
            case 4: mode.africaContinent = toggle
            case 5: mode.asiaContinent = toggle
            default: mode.oceaniaContinent = toggle
            }
        }
    }
    
    private func checkmarkContinents(button: UIButton, isOn: Bool) {
        if americaContinent, europeContinent, africaContinent, asiaContinent, oceaniaContinent {
            buttonOnAllCountries()
            labelsOnAllCountries()
            settingOnAllCountries()
        } else if !americaContinent, !europeContinent, !africaContinent, !asiaContinent, !oceaniaContinent {
            buttonOnAllCountries()
            labelsOnAllCountries()
            settingOnAllCountries()
        } else {
            buttonOnOff(buttons: buttonAllCountries, color: .blueMiddlePersian)
            buttonOnOff(buttons: button, color: select(isOn: !isOn))
            
            labelOnOff(labels: labelAllCountries, labelCountAllCountries, color: .white)
            labelOnOff(button: button, color: select(isOn: isOn))
            checkmarkSettingOnOff(buttons: buttonAllCountries, isOn: false)
        }
    }
    // MARK: - Toggle time elapsed, change color for labels, segmented control and picker views
    private func checkmarkTimeElapsed(button: UIButton) {
        setTimeToggle(isTime())
        let isOn = isTime()
        checkmarkOnOff(buttons: button, image: checkmark(isOn: isOn))
        checkmarkColors(isOn: isOn)
    }
    
    private func checkmarkOnOff(buttons: UIButton..., image: String) {
        buttons.forEach { button in
            let configuration = UIImage.SymbolConfiguration(pointSize: 25)
            let image = UIImage(systemName: image, withConfiguration: configuration)
            button.configuration?.image = image
        }
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
    // MARK: - Set count countries from checkmarks, countinue
    private func checkCountCountries(continent: Int) -> Int {
        switch continent {
        case 1: countCountries
        case 2: countCountriesOfAmerica
        case 3: countCountriesOfEurope
        case 4: countCountriesOfAfrica
        case 5: countCountriesOfAsia
        default: countCountriesOfOceania
        }
    }
    
    private func checkCountRows(count: Int) -> Int {
        count > defaultCountRows ? defaultCountRows : count
    }
    // MARK: - Set row picker view from update count rows
    private func setRowPickerView(newCountRows: Int) {
        if newCountRows < countRows {
            let countQuestions = newCountRows + 9
            
            setCountRows(newCountRows)
            pickerViewNumberQuestion.reloadAllComponents()
            pickerViewNumberQuestion.selectRow(newCountRows, inComponent: 0, animated: false)
            checkCountQuestions(newCountQuestions: countQuestions)
        } else {
            setCountRows(newCountRows)
            pickerViewNumberQuestion.reloadAllComponents()
        }
    }
    
    private func checkCountQuestions(newCountQuestions: Int) {
        if newCountQuestions < countQuestions {
            let averageQuestionTime = 5 * newCountQuestions
            let currentRow = averageQuestionTime - (4 * newCountQuestions)
            
            setupDataFromPickerView(countQuestion: newCountQuestions,
                                    averageTime: averageQuestionTime,
                                    currentRow: currentRow)
        }
    }
    
    private func setupDataFromPickerView(countQuestion: Int, averageTime: Int, currentRow: Int) {
        labelNumber.text = "\(countQuestion)"
        labelTimeElapsedNumber.text = checkPickerViewEnabled(time: averageTime)
        
        setCountQuestions(countQuestion)
        setAllQuestionsTime(averageTime)
        
        updateRowPickerView(pickerView: pickerViewAllQuestions, row: currentRow)
    }
    
    private func checkPickerViewEnabled(time: Int) -> String {
        let text = "\(oneQuestionTime)"
        guard pickerViewAllQuestions.isUserInteractionEnabled else { return text }
        return "\(time)"
    }
    
    private func updateRowPickerView(pickerView: UIPickerView, row: Int) {
        pickerView.reloadAllComponents()
        pickerView.selectRow(row, inComponent: 0, animated: false)
    }
}
