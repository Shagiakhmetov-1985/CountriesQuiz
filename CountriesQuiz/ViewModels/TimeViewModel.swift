//
//  TimeViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 16.10.2024.
//

import UIKit

protocol TimeViewModelProtocol {
    var title: String { get }
    var description: String { get }
    var items: [String] { get }
    var isTime: Bool { get }
    var colorSelected: UIColor { get }
    var colorNormal: UIColor { get }
    var segmentIndex: Int { get }
    var numberOfComponents: Int { get }
    var heightOfRows: CGFloat { get }
    
    var mode: Setting { get }
    
    init(mode: Setting)
    
    func setBarButton(button: UIButton, navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., to subviewOther: UIView)
    func setLabel(text: String, font: String, size: CGFloat) -> UILabel
    func setPickerView(_ pickerView: UIPickerView)
    func numberOfRows(_ pickerView: UIPickerView) -> Int
    func setTitles(pickerView: UIPickerView,_ row: Int, and segment: UISegmentedControl) -> UIView
    func isEnabled(_ tag: Int) -> Bool
    func setRow(_ tag: Int) -> Int
    
    func segmentSelect(segment: UISegmentedControl)
    func setTimeFromRow(pickerView: UIPickerView, and row: Int)
    func setSquare(subview: UIView, sizes: CGFloat)
}

class TimeViewModel: TimeViewModelProtocol {
    var title = "Время для вопросов"
    var description = "Установите таймер для одного вопроса или же таймер для всех вопросов. При истечении времени для одного вопроса, станет недоступным сам вопрос, а для всех вопросов - завершается игра. Также таймер вы можете отключить."
    var items = ["Один вопрос", "Все вопросы"]
    var isTime: Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    var colorSelected: UIColor {
        isTime ? .white : .skyGrayLight
    }
    var colorNormal: UIColor {
        isTime ? .blueMiddlePersian : .grayLight
    }
    var segmentIndex: Int {
        isOneQuestion ? 0 : 1
    }
    var numberOfComponents = 1
    var heightOfRows: CGFloat = 35
    
    var mode: Setting
    
    private var isOneQuestion: Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    private var timeOneQuestion: Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    private var timeAllQuestions: Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    private var pickerViewOne: UIPickerView!
    private var pickerViewTwo: UIPickerView!
    
    required init(mode: Setting) {
        self.mode = mode
    }
    
    func setBarButton(button: UIButton, navigationItem: UINavigationItem) {
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
    }
    
    func setSubviews(subviews: UIView..., to subviewOther: UIView) {
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
    
    func setPickerView(_ pickerView: UIPickerView) {
        if pickerView.tag == 1 {
            pickerViewOne = pickerView
        } else {
            pickerViewTwo = pickerView
        }
    }
    
    func numberOfRows(_ pickerView: UIPickerView) -> Int {
        pickerView.tag == 1 ? 10 : 6 * mode.countQuestions - 4 * mode.countQuestions + 1
    }
    
    func setTitles(pickerView: UIPickerView, _ row: Int, and segment: UISegmentedControl) -> UIView {
        var attributed = NSAttributedString()
        let label = UILabel()
        
        switch pickerView.tag {
        case 1:
            let title = "\(row + 6)"
            attributed = setAttributed(title: title, tag: pickerView.tag, segment: segment)
        default:
            let title = "\(row + 4 * mode.countQuestions)"
            attributed = setAttributed(title: title, tag: pickerView.tag, segment: segment)
        }
        
        label.textAlignment = .center
        label.attributedText = attributed
        return label
    }
    
    func isEnabled(_ tag: Int) -> Bool {
        switch tag {
        case 1: isOneQuestion ? true : false
        default: isOneQuestion ? false : true
        }
    }
    
    func setRow(_ tag: Int) -> Int {
        tag == 1 ? timeOneQuestion - 6 : timeAllQuestions - 4 * mode.countQuestions
    }
    
    func segmentSelect(segment: UISegmentedControl) {
        setPickerViewOnOff(segment.selectedSegmentIndex == 0 ? pickerViewOne : pickerViewTwo)
    }
    
    func setTimeFromRow(pickerView: UIPickerView, and row: Int) {
        let time = pickerView.tag == 1 ? row + 6 : row + 4 * mode.countQuestions
        pickerView.tag == 1 ? setTimeOneQuestion(time) : setTimeAllQuestions(time)
    }
    
    func setSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
}

extension TimeViewModel {
    private func setPickerViewOnOff(_ pickerView: UIPickerView) {
        if pickerView.tag == 0 {
            changePickerView(pickerViewOne, isOn: true)
            changePickerView(pickerViewTwo, isOn: false)
        } else {
            changePickerView(pickerViewOne, isOn: false)
            changePickerView(pickerViewTwo, isOn: true)
        }
    }
    
    private func changePickerView(_ pickerView: UIPickerView, isOn: Bool) {
        let color: UIColor = isOn ? .white : .skyGrayLight
        pickerView.isUserInteractionEnabled = isOn
        UIView.animate(withDuration: 0.3) {
            pickerView.backgroundColor = color
        }
    }
    
    private func setAttributed(title: String, tag: Int, segment:
                               UISegmentedControl) -> NSAttributedString {
        let font = UIFont(name: "mr_fontick", size: 32)
        let color = color(tag: tag, segment: segment)
        return NSAttributedString(string: title, attributes: [
            .font: font ?? "",
            .foregroundColor: color
        ])
    }
    
    private func color(tag: Int, segment: UISegmentedControl) -> UIColor {
        switch segment.selectedSegmentIndex {
        case 0:
            return tag == 1 ? .blueMiddlePersian : .grayLight
        default:
            return tag == 1 ? .grayLight : .blueMiddlePersian
        }
    }
    
    private func setTimeOneQuestion(_ time: Int) {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime = time
    }
    
    private func setTimeAllQuestions(_ time: Int) {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime = time
    }
}
