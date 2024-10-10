//
//  ContinentsViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 10.10.2024.
//

import UIKit

protocol ContinentsViewModelProtocol {
    var title: String { get }
    var description: String { get }
    var allCountries: Bool { get }
    var americaContinent: Bool { get }
    var europeContinent: Bool { get }
    var africaContinent: Bool { get }
    var asiaContinent: Bool { get }
    var oceaniaContinent: Bool { get }
    var mode: Setting { get }
    
    init(mode: Setting)
    
    func setBarButton(button: UIButton, navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func setLabel(text: String, font: String, size: CGFloat) -> UILabel
    func text(tag: Int) -> String
    func attributedText(text: String, tag: Int) -> NSMutableAttributedString
    func isSelect(isOn: Bool) -> UIColor
    func setButtonsContinent(button: UIButton)
    
    func setContinents(sender: UIButton)
    func setSquare(subview: UIView, sizes: CGFloat)
}

class ContinentsViewModel: ContinentsViewModelProtocol {
    var title = "Континенты"
    var description = "Установите континенты и в вопросах будут выпадать те государства, которые входят в той или иной континент."
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
    
    var mode: Setting
    
    private var countContinents = 0
    
    private var buttonAllCountries: UIButton!
    private var buttonAmerica: UIButton!
    private var buttonEurope: UIButton!
    private var buttonAfrica: UIButton!
    private var buttonAsia: UIButton!
    private var buttonOcean: UIButton!
    
    required init(mode: Setting) {
        self.mode = mode
    }
    
    func setBarButton(button: UIButton, navigationItem: UINavigationItem) {
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
    }
    
    func setSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    func setLabel(text: String, font: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: font, size: size)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func text(tag: Int) -> String {
        """
        \(continent(tag: tag))
        \(count(tag: tag))
        """
    }
    
    func attributedText(text: String, tag: Int) -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: text)
        let font = NSAttributedString.Key.font
        let key = UIFont(name: "mr_fontick", size: 20)
        let range = setRange(subString: count(tag: tag), fromString: text)
        attributed.addAttributes([font: key ?? ""], range: range)
        return attributed
    }
    
    func isSelect(isOn: Bool) -> UIColor {
        isOn ? .blueMiddlePersian : .white
    }
    
    func setButtonsContinent(button: UIButton) {
        switch button.tag {
        case 0: buttonAllCountries = button
        case 1: buttonAmerica = button
        case 2: buttonEurope = button
        case 3: buttonAfrica = button
        case 4: buttonAsia = button
        default: buttonOcean = button
        }
    }
    
    func setContinents(sender: UIButton) {
        guard sender.tag > 0 else { return setAllCountries(sender) }
        setCountContinents(sender.backgroundColor == .white ? -1 : 1)
        guard countContinents > 4 else { return  }
        setAllCountries(sender)
    }
    
    func setSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
}
// MARK: - Constants
extension ContinentsViewModel {
    private func setRange(subString: String, fromString: String) -> NSRange {
        let linkRange = fromString.range(of: subString)!
        let start = fromString.distance(from: fromString.startIndex, to: linkRange.lowerBound)
        let end = fromString.distance(from: fromString.startIndex, to: linkRange.upperBound)
        let range = NSMakeRange(start, end - start)
        return range
    }
    
    private func continent(tag: Int) -> String {
        switch tag {
        case 0: "Все страны мира"
        case 1: "Континент Америки"
        case 2: "Континент Европы"
        case 3: "Континент Африки"
        case 4: "Континент Азии"
        default: "Континент Океании"
        }
    }
    
    private func count(tag: Int) -> String {
        "Количество стран: \(countCountries(tag: tag))"
    }
    
    private func countCountries(tag: Int) -> Int {
        switch tag {
        case 0: FlagsOfCountries.shared.countries.count
        case 1: FlagsOfCountries.shared.countriesOfAmericanContinent.count
        case 2: FlagsOfCountries.shared.countriesOfEuropeanContinent.count
        case 3: FlagsOfCountries.shared.countriesOfAfricanContinent.count
        case 4: FlagsOfCountries.shared.countriesOfAsianContinent.count
        default: FlagsOfCountries.shared.countriesOfOceanContinent.count
        }
    }
}
// MARK: - Set data
extension ContinentsViewModel {
    private func setCountContinents(_ count: Int) {
        if count == 0 {
            countContinents = 0
        } else {
            countContinents += count
        }
    }
    
    private func setAllCountries(_ sender: UIButton) {
        guard sender.backgroundColor == .blueMiddlePersian else { return }
        setCountContinents(0)
        buttonAllCountries(sender, isOn: true)
        setColorButtons(buttons: buttonAmerica, buttonEurope, buttonAfrica, buttonAsia, buttonOcean)
    }
    
    private func buttonAllCountries(_ sender: UIButton, isOn: Bool) {
        let backgroundColor: UIColor = isOn ? .white : .blueMiddlePersian
        let textColor: UIColor = isOn ? .blueMiddlePersian : .white
        setColor(buttons: sender, backgroundColor: backgroundColor, textColor: textColor)
    }
    
    private func condition(_ sender: UIButton) {
        countContinents == 0 ? setCountContinents(0) : 
    }
    
    private func setColor(buttons: UIButton..., backgroundColor: UIColor,
                          textColor: UIColor) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.backgroundColor = backgroundColor
                button.setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    private func setColorButtons(buttons: UIButton...) {
        buttons.forEach { button in
            setColor(buttons: button, backgroundColor: .blueMiddlePersian, textColor: .white)
        }
    }
}
