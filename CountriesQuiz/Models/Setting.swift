//
//  Setting.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 12.12.2022.
//

import Foundation

struct Setting: Codable {
    var countQuestions: Int
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
    var allQuestionTime: Int
}

extension Setting {
    static func getSettingDefault() -> Setting {
        let setting = Setting(
            countQuestions: 20,
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
                        oneQuestionTime: 10,
                        allQuestionTime: 100
                    )
                )
            )
        )
        return setting
    }
}
