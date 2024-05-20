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
    func setTime(_ isOn: Bool)
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
    
    required init(mode: Setting) {
        self.mode = mode
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
    
    func setTime(_ isOn: Bool) {
        mode.timeElapsed.timeElapsed = isOn
    }
    // MARK: - Constants, countinue
    private func checkSizeScreenIphone(_ view: UIView) -> CGFloat {
        view.frame.height > 736 ? 180 : 320
    }
}
