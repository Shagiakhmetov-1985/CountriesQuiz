//
//  Setting.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 12.12.2022.
//

import Foundation

struct Setting: Codable {
    var countQuestions: Int
    var countRows: Int
    var allCountries: Bool
    var americaContinent: Bool
    var europeContinent: Bool
    var africaContinent: Bool
    var asiaContinent: Bool
    var oceaniaContinent: Bool
    var timeElapsed: TimeElapsed
}

struct TimeElapsed: Codable {
    var timeElapsed: Bool
    var questionSelect: QuestionSelect
}

struct QuestionSelect: Codable {
    var oneQuestion: Bool
    var questionTime: QuestionTime
}

struct QuestionTime: Codable {
    var oneQuestionTime: Int
    var allQuestionsTime: Int
}

extension Setting {
    static func getSettingDefault() -> Setting {
        let setting = Setting(
            countQuestions: DefaultSetting.countQuestions.rawValue,
            countRows: DefaultSetting.countRows.rawValue,
            allCountries: true,
            americaContinent: false,
            europeContinent: false,
            africaContinent: false,
            asiaContinent: false,
            oceaniaContinent: false,
            timeElapsed: TimeElapsed(
                timeElapsed: true,
                questionSelect: QuestionSelect(
                    oneQuestion: true,
                    questionTime: QuestionTime(
                        oneQuestionTime: DefaultSetting.oneQuestionTime.rawValue,
                        allQuestionsTime: DefaultSetting.allQuestionsTime.rawValue
                    )
                )
            )
        )
        return setting
    }
}

extension Setting: Equatable {
    static func == (lhs: Setting, rhs: Setting) -> Bool {
        return lhs.allCountries == rhs.allCountries
    }
}

enum DefaultSetting: Int {
    case countQuestions = 20
    case countRows = 91
    case oneQuestionTime = 10
    case allQuestionsTime = 100
}
