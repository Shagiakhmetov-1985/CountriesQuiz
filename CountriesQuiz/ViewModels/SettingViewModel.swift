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
                   _ labelTimeQuestion: UILabel,_ labelTimeNumber: UILabel)
    func setSegmentedControl(_ segmentControl: UISegmentedControl)
    func setPickerViews(_ pickerViewOne: UIPickerView,_ pickerViewAll: UIPickerView)
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    
    func contentSize(_ view: UIView?) -> CGSize
    func isTime() -> Bool
    func isOneQuestion() -> Bool
    func topAnchorCheck(_ view: UIView) -> CGFloat
    
    func setOneQuestionTime(_ time: Int)
    func setAllQuestionsTime(_ time: Int)
    func setCountQuestions(_ countQuestions: Int)
    func setCountRows(_ countRows: Int)
    func setOneQuestion(_ isOn: Bool)
    func setMode(_ mode: Setting)
    func setTimeToggle(_ isOn: Bool)
    
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
    
    private var segmentedControl: UISegmentedControl!
    
    private var pickerViewOneQuestion: UIPickerView!
    private var pickerViewAllQuestions: UIPickerView!
    
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
                   _ labelTimeQuestion: UILabel, _ labelTimeNumber: UILabel) {
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
    }
    
    func setSegmentedControl(_ segmentControl: UISegmentedControl) {
        segmentedControl = segmentControl
    }
    
    func setPickerViews(_ pickerViewOne: UIPickerView, _ pickerViewAll: UIPickerView) {
        pickerViewOneQuestion = pickerViewOne
        pickerViewAllQuestions = pickerViewAll
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
        default:
            checkmarkTimeElapsed(button: sender)
        }
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
    
    private func checkmark(isOn: Bool) -> String {
        isOn ? "checkmark.circle.fill" : "circle"
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
}
