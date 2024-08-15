//
//  Incorrects.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 29.01.2023.
//

import Foundation

struct Incorrects: Equatable {
    let currentQuestion: Int
    let tag: Int
    
    let question: Countries
    let buttonFirst: Countries
    let buttonSecond: Countries
    let buttonThird: Countries
    let buttonFourth: Countries
    
    let isFlag: Bool
    let timeUp: Bool
}
