//
//  SettingViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 19.05.2024.
//

import UIKit

protocol SettingViewModelProtocol {
    var title: String { get }
    var cell: AnyClass { get }
    var heightOfRow: CGFloat { get }
    var numberOfSections: Int { get }
    
    var mode: Setting { get }
    
    init(mode: Setting)
    
    func setBarButtons(_ buttonBack: UIButton, _ buttonDefault: UIButton, and navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func setLabel(text: String, size: CGFloat, color: UIColor) -> UILabel
    func numberOfRows(_ section: Int) -> Int
    func customCell(cell: SettingCell, indexPath: IndexPath)
    
    func setMode(_ mode: Setting)
    func showAlert(_ mode: Setting,_ button: UIButton, and tableView: UITableView) -> UIAlertController
    func setSquare(subviews: UIView..., sizes: CGFloat)
    
    func countQuestionsViewController() -> CountQuestionsViewModelProtocol
    func continentsViewController() -> ContinentsViewModelProtocol
    func timeViewController() -> TimeViewModelProtocol
}

class SettingViewModel: SettingViewModelProtocol {
    var title = "Настройки"
    var cell: AnyClass = SettingCell.self
    var heightOfRow: CGFloat = 55
    var numberOfSections = 2
    
    var mode: Setting
    
    private var countQuestions: Int {
        mode.countQuestions
    }
    private var allCountries: Bool {
        mode.allCountries
    }
    private var americaContinent: Bool {
        mode.americaContinent
    }
    private var europaContinent: Bool {
        mode.europaContinent
    }
    private var africaContinent: Bool {
        mode.africaContinent
    }
    private var asiaContinent: Bool {
        mode.asiaContinent
    }
    private var oceaniaContinent: Bool {
        mode.oceaniaContinent
    }
    private var continents: String {
        comma(continents: allCountries, americaContinent, europaContinent,
              africaContinent, asiaContinent, oceaniaContinent)
    }
    private var isTime: Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    private var isOneQuestion: Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    private var timeOneQuestion: Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    private var timeAllQuestions: Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    private var setTime: Int {
        isOneQuestion ? timeOneQuestion : timeAllQuestions
    }
    private var time: String {
        isTime ? "\(setTime) сек." : "Нет."
    }
    private var isMoreFiftyQuestions: Bool {
        !allCountries && countQuestions > 50
    }
    
    required init(mode: Setting) {
        self.mode = mode
    }
    // MARK: - Subviews
    func setBarButtons(_ buttonBack: UIButton, _ buttonDefault: UIButton,
                       and navigationItem: UINavigationItem) {
        let buttonLeft = UIBarButtonItem(customView: buttonBack)
        let buttonRight = UIBarButtonItem(customView: buttonDefault)
        navigationItem.leftBarButtonItem = buttonLeft
        navigationItem.rightBarButtonItem = buttonRight
    }
    
    func setSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    func customCell(cell: SettingCell, indexPath: IndexPath) {
        cell.view.backgroundColor = color(indexPath.section)[indexPath.row]
        cell.image.image = image(name: images(indexPath.section)[indexPath.row])
        cell.title.text = title(indexPath.section)[indexPath.row]
        cell.setTitle(size: size(row: indexPath.row, section: indexPath.section))
        cell.additional.text = additional(indexPath.section)[indexPath.row]
    }
    
    func setLabel(text: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func numberOfRows(_ section: Int) -> Int {
        switch section {
        case 0: 3
        default: 2
        }
    }
    
    func setMode(_ setting: Setting) {
        mode = setting
    }
    
    func showAlert(_ mode: Setting, _ button: UIButton, and
                   tableView: UITableView) -> UIAlertController {
        let title = "Сбросить настройки"
        let message = "Вы действительно хотите сбросить настройки до заводских?"
        
        let alert = AlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        alert.action(mode: mode) {
            self.resetSetting(button: button)
            tableView.reloadData()
        }
        
        return alert
    }
    
    func setSquare(subviews: UIView..., sizes: CGFloat) {
        subviews.forEach { subview in
            NSLayoutConstraint.activate([
                subview.heightAnchor.constraint(equalToConstant: sizes),
                subview.widthAnchor.constraint(equalToConstant: sizes)
            ])
        }
    }
    // MARK: - Transition to next view controller
    func countQuestionsViewController() -> CountQuestionsViewModelProtocol {
        CountQuestionsViewModel(mode: mode)
    }
    
    func continentsViewController() -> ContinentsViewModelProtocol {
        ContinentsViewModel(mode: mode)
    }
    
    func timeViewController() -> TimeViewModelProtocol {
        TimeViewModel(mode: mode)
    }
}
// MARK: - Constants
extension SettingViewModel {
    private func color(_ section: Int) -> [UIColor] {
        switch section {
        case 0: [.gummigut, .greenEmerald, .redTangerineTango]
        default: [.indigo, .grayStone]
        }
    }
    
    private func image(name: String) -> UIImage? {
        let size = UIImage.SymbolConfiguration(pointSize: 27)
        return UIImage(systemName: name, withConfiguration: size)
    }
    
    private func images(_ section: Int) -> [String] {
        switch section {
        case 0: ["questionmark.bubble", "globe.europe.africa", "timer"]
        default: ["globe", "slider.horizontal.3"]
        }
    }
    
    private func title(_ section: Int) -> [String] {
        switch section {
        case 0: ["Количество вопросов", "Континенты", "Время для вопросов"]
        default: ["Язык", "Оформление"]
        }
    }
    
    private func additional(_ section: Int) -> [String] {
        switch section {
        case 0: ["\(countQuestions)", "\(continents)", "\(time)"]
        default: ["Русский", ""]
        }
    }
    
    private func comma(continents: Bool...) -> String {
        var text = ""
        var counter = 0
        continents.forEach { continent in
            if continent {
                text += text == "" ? title(counter) : ", \(title(counter))"
            }
            counter += 1
        }
        return text
    }
    
    private func title(_ counter: Int) -> String {
        switch counter {
        case 0: "Все страны"
        case 1: "Америка"
        case 2: "Европа"
        case 3: "Африка"
        case 4: "Азия"
        default: "Океания"
        }
    }
    
    private func size(row: Int, section: Int) -> CGFloat {
        switch (row, section) {
        case (1, 0): 18
        default: 21
        }
    }
    
    private func resetSetting(button: UIButton) {
        setMode(Setting.getSettingDefault())
    }
}
