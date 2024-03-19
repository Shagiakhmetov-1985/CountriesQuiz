//
//  GameTypeViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 07.03.2024.
//

import UIKit

protocol GameTypeViewModelProtocol {
    var setTag: Int { get }
    var countQuestions: Int { get }
    var allCountries: Bool { get }
    var americaContinent: Bool { get }
    var europeContinent: Bool { get }
    var africaContinent: Bool { get }
    var asiaContinent: Bool { get }
    var oceaniaContinent: Bool { get }
    var background: UIColor { get }
    var colorPlay: UIColor { get }
    var colorFavourite: UIColor { get }
    var colorSwap: UIColor { get }
    var colorDone: UIColor { get }
    init(mode: Setting, game: Games, tag: Int)
    func numberOfComponents() -> Int
    func numberOfQuestions() -> Int
    func countdownOneQuestion() -> Int
    func countdownAllQuestions() -> Int
    func titles(_ pickerView: UIPickerView, _ row: Int, and segmented: UISegmentedControl) -> UIView
    func swap(_ tag: Int, _ button: UIButton)
    func isCountdown() -> Bool
    func isOneQuestion() -> Bool
    func image(_ tag: Int) -> String
    func isEnabled(_ tag: Int) -> Bool
}

class GameTypeViewModel: GameTypeViewModelProtocol {
    var setTag: Int {
        tag
    }
    
    var countQuestions: Int {
        mode.countQuestions
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
    
    var background: UIColor {
        game.background
    }
    
    var colorPlay: UIColor {
        game.play
    }
    
    var colorFavourite: UIColor {
        game.favourite
    }
    
    var colorSwap: UIColor {
        game.swap
    }
    
    var colorDone: UIColor {
        game.done
    }
    
    private var mode: Setting
    private let game: Games
    private let tag: Int
    
    required init(mode: Setting, game: Games, tag: Int) {
        self.mode = mode
        self.game = game
        self.tag = tag
    }
    // MARK: - PickerView
    func numberOfComponents() -> Int {
        1
    }
    
    func numberOfQuestions() -> Int {
        mode.countRows
    }
    
    func countdownOneQuestion() -> Int {
        10
    }
    
    func countdownAllQuestions() -> Int {
        6 * mode.countQuestions - 4 * mode.countQuestions + 1
    }
    
    func titles(_ pickerView: UIPickerView, _ row: Int, and segmented: UISegmentedControl) -> UIView {
        let label = UILabel()
        let tag = pickerView.tag
        var title = String()
        var attributed = NSAttributedString()
        
        switch tag {
        case 1:
            title = "\(row + 10)"
            attributed = attributted(title: title, tag: tag, segmented: segmented)
        case 2:
            title = "\(row + 6)"
            attributed = attributted(title: title, tag: tag, segmented: segmented)
        default:
            title = "\(row + 4 * mode.countQuestions)"
            attributed = attributted(title: title, tag: tag, segmented: segmented)
        }
        
        label.textAlignment = .center
        label.attributedText = attributed
        return label
    }
    // MARK: - Image for button of setting
    func image(_ tag: Int) -> String {
        switch tag {
        case 0, 1, 4: return mode.flag ? "flag" : "building"
        case 2: return "globe.europe.africa"
        default: return scrabbleType()
        }
    }
    // MARK: - Enable or disable button of setting
    func isEnabled(_ tag: Int) -> Bool {
        tag == 2 ? false : true
    }
    // MARK: - Press swap button of setting
    func swap(_ tag: Int, _ button: UIButton) {
        switch tag {
        case 0, 1, 4: GameTypeFirst(button: button)
        default: GameTypeSecond(button: button)
        }
    }
    // MARK: - Setup design
    func isCountdown() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    func isOneQuestion() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion
    }
    // MARK: - Private methods
    private func GameTypeFirst(button: UIButton) {
        mode.flag ? imageSwap("building", button) : imageSwap("flag", button)
        mode.flag.toggle()
        StorageManager.shared.saveSetting(setting: mode)
    }
    private func imageSwap(_ image: String, _ button: UIButton) {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        button.setImage(image, for: .normal)
    }
    
    private func GameTypeSecond(button: UIButton) {
        switch mode.scrabbleType {
        case 0: imageSwap("globe.europe.africa", mode.scrabbleType + 1, button)
        case 1: imageSwap("building.2", mode.scrabbleType + 1, button)
        default: imageSwap("flag", 0, button)
        }
    }
    
    private func imageSwap(_ image: String, _ scrabbleType: Int, _ button: UIButton) {
        imageSwap(image, button)
        mode.scrabbleType = scrabbleType
        StorageManager.shared.saveSetting(setting: mode)
    }
    // MARK: - Attributted for picker view
    private func attributted(title: String, tag: Int, segmented: UISegmentedControl) -> NSAttributedString {
        let color = tag == 1 ? game.favourite : color(tag: tag, segmented: segmented)
        return NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "mr_fontick", size: 26) ?? "",
            .foregroundColor: color
        ])
    }
    
    private func color(tag: Int, segmented: UISegmentedControl) -> UIColor {
        switch segmented.selectedSegmentIndex {
        case 0:
            return tag == 2 ? game.favourite : .grayLight
        default:
            return tag == 2 ? .grayLight : game.favourite
        }
    }
    // MARK: - Image
    private func scrabbleType() -> String {
        switch mode.scrabbleType {
        case 0: return "flag"
        case 1: return "globe.europe.africa"
        default: return "building.2"
        }
    }
}
