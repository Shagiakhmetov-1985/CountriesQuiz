//
//  Favourites.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 17.08.2024.
//

import Foundation

struct Favourites: Codable {
    let flag: String
    let name: String
    let buttonFirst: String
    let buttonSecond: String
    let buttonThird: String
    let buttonFourth: String
    let currectQuestion: Int
    let tag: Int
    let isFlag: Bool
    let isTimeUp: Bool
}
