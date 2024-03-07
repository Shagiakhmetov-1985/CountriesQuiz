//
//  GameTypeViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 07.03.2024.
//

import UIKit

class GameTypeViewModel {
    let mode: Setting
    let game: Games
    let tag: Int
    
    init(mode: Setting, game: Games, tag: Int) {
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
    /*
    func swap(_ tag: Int, _ mode: Setting) {
        switch tag {
        case 0, 1, 4: GameTypeFirst(mode: mode)
        default: GameTypeSecond()
        }
    }
    
    private func GameTypeFirst(mode: Setting) {
        mode.flag ? imageSwap(image: "building") : imageSwap(image: "flag")
        mode.flag.toggle()
        StorageManager.shared.saveSetting(setting: mode)
    }
    
    private func imageSwap(image: String) {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        buttonSwap.setImage(image, for: .normal)
    }
    
    private func GameTypeSecond() {
        switch mode.scrabbleType {
        case 0: imageSwap(image: "globe.europe.africa", scrabbleType: mode.scrabbleType + 1)
        case 1: imageSwap(image: "building.2", scrabbleType: mode.scrabbleType + 1)
        default: imageSwap(image: "flag", scrabbleType: 0)
        }
    }
    
    private func imageSwap(image: String, scrabbleType: Int) {
        imageSwap(image: image)
        mode.scrabbleType = scrabbleType
        StorageManager.shared.saveSetting(setting: mode)
    }
     */
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
