//
//  DetailsViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 08.04.2024.
//

import UIKit

protocol DetailsViewModelProtocol {
    var radius: CGFloat { get }
    var numberQuestion: String { get }
    var progress: Float { get }
    var stackView: UIStackView { get }
    
    var mode: Setting { get }
    var game: Games { get }
    var result: Results { get }
    
    init(mode: Setting, game: Games, result: Results)
    
    func setSubviews(_ stackViewFirst: UIStackView,_ stackViewSecond: UIStackView)
    func setupSubviews(subviews: UIView..., on otherSubview: UIView)
    func setupBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    
    func isFlag() -> Bool
    func width(_ image: String) -> CGFloat
    func widthStackViewFlag(_ view: UIView) -> CGFloat
    func widthLabel(_ view: UIView) -> CGFloat
    func height() -> CGFloat
    func widthImage(_ image: String,_ view: UIView) -> CGFloat
    func heightImage() -> CGFloat
    func widthOrCenter(_ view: UIView) -> (CGFloat, CGFloat, CGFloat)
    
    func setTitle(title: Countries) -> String
    func subview(_ image: UIImageView,_ label: UILabel) -> UIView
    
    func setBackgroundColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor
    func setTitleColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor
    func setButtonColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor
    func setColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor
    func setCheckmark(question: Countries, answer: Countries, tag: Int, select: Int) -> String
}

class DetailsViewModel: DetailsViewModelProtocol {
    let radius: CGFloat = 6
    var numberQuestion: String {
        "\(result.currentQuestion) / \(mode.countQuestions)"
    }
    var progress: Float {
        Float(result.currentQuestion) / Float(mode.countQuestions)
    }
    var stackView: UIStackView {
        switch game.gameType {
        case .quizOfFlag, .questionnaire: stackViewLabel
        default: stackViewFlag
        }
    }
    
    let mode: Setting
    let game: Games
    let result: Results
    
    private var stackViewFlag: UIStackView!
    private var stackViewLabel: UIStackView!
    
    required init(mode: Setting, game: Games, result: Results) {
        self.mode = mode
        self.game = game
        self.result = result
    }
    // MARK: - Set subviews
    func setSubviews(_ stackViewFirst: UIStackView, _ stackViewSecond: UIStackView) {
        stackViewFlag = stackViewFirst
        stackViewLabel = stackViewSecond
    }
    
    func setupSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    func setupBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
    }
    
    func subview(_ image: UIImageView, _ label: UILabel) -> UIView {
        game.gameType == .quizOfFlag ? image : label
    }
    // MARK: - Constants
    func isFlag() -> Bool {
        mode.flag ? true : false
    }
    
    func width(_ image: String) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    func widthStackViewFlag(_ view: UIView) -> CGFloat {
        view.bounds.width - 40
    }
    
    func widthLabel(_ view: UIView) -> CGFloat {
        view.bounds.width - 20
    }
    
    func height() -> CGFloat {
        game.gameType == .questionnaire ? 235 : 215
    }
    
    func widthImage(_ image: String, _ view: UIView) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": heightImage()
        default: game.gameType == .questionnaire ? widthOrCenter(view).1 : widthOrCenter(view).0
        }
    }
    
    func heightImage() -> CGFloat {
        let buttonHeight = height() / 2 - 4
        return buttonHeight - 10
    }
    
    func widthOrCenter(_ view: UIView) -> (CGFloat, CGFloat, CGFloat) {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 10
        let flagWidthQuestionnaire = buttonWidth - 45
        let centerFlag = flagWidthQuestionnaire / 2 + 5
        let constant = buttonWidth / 2 - centerFlag
        return (flagWidth, flagWidthQuestionnaire, constant)
    }
    // MARK: - Set title
    func setTitle(title: Countries) -> String {
        switch game.gameType {
        case .quizOfFlag, .questionnaire: title.name
        default: title.capitals
        }
    }
    // MARK: - Set colors
    func setBackgroundColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return .greenYellowBrilliant
        case !(question == answer) && tag == select:
            return game.gameType == .quizOfFlag ? .redTangerineTango : .bismarkFuriozo
        default:
            return isFlag() ? .white.withAlphaComponent(0.9) : checkColor()
        }
    }
    
    func setTitleColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer || tag == select:
            return .white
        default:
            return .grayLight
        }
    }
    
    func setButtonColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer || tag == select:
            return .white
        default:
            return .clear
        }
    }
    
    func setColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return .greenHarlequin
        case !(question == answer) && tag == select:
            return .redTangerineTango
        default:
            return .white
        }
    }
    // MARK: - Set checkmarks
    func setCheckmark(question: Countries, answer: Countries, tag: Int, select: Int) -> String {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return "checkmark.circle.fill"
        case !(question == answer) && tag == select:
            return "xmark.circle.fill"
        default:
            return "circle"
        }
    }
    // MARK: - Set colors, countinue
    private func checkColor() -> UIColor {
        game.gameType == .quizOfFlag ? .skyGrayLight : .white.withAlphaComponent(0.9)
    }
}
