//
//  Setting.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 12.12.2022.
//

import Foundation

struct Setting: Codable {
    let numberQuestions: Int
    let allCountries: Bool
    let americaContinent: Bool
    let europeContinent: Bool
    let africaContinent: Bool
    let asiaContinent: Bool
    let oceaniaContinent: Bool
    let timeElapsed: TimeElapsed
}

struct TimeElapsed: Codable {
    let timeElapsed: Bool
    let questionSelect: QuestionSelect
}

struct QuestionSelect: Codable {
    let oneQuestion: Bool
    let allQuestion: Bool
    let questionTime: QuestionTime
}

struct QuestionTime: Codable {
    let oneQuestionTime: Int
    let allQuestionTime: Int
}

extension Setting {
    static func getSettingDefault() -> Setting {
        let setting = Setting(
            numberQuestions: 20,
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
                    allQuestion: false,
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
