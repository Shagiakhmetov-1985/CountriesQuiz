//
//  GameType.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 03.08.2023.
//

import UIKit

class GameType {
    static let shared = GameType()
    
    let gameType: [TypeOfGame] = [.quizOfFlag, .questionnaire, .quizOfMap,
                                .scrabble, .quizOfCapitals]
    
    let names = ["Викторина флагов", "Опрос", "Викторина карт", "Эрудит",
                 "Викторина столиц"]
    
    let images = ["filemenu.and.selection", "checklist", "globe.desk",
                  "a.square", "building.2"]
    
    let descriptions = [
        """
        Выбор ответа на заданный вопрос о флаге страны. Вам предоставляются четыре ответа на выбор. Один из четырех ответов - правильный.
        
        ➤ Одна попытка для выбора ответа, чтобы перейти к следующему вопросу.
        ➤ Вопрос о флаге страны и выбор ответа наименования страны или же вопрос о наименовании страны и выбор ответа флага страны.
        ➤ Зеленый цвет - правильный ответ и красный цвет - неправильный ответ.
        ➤ Выбор обратного отсчета для одного вопроса, который восстанавливается при следующем вопросе.
        ➤ Выбор обратного отсчета для всех вопросов, который не восстанавливается при следующем вопросе.
        """,
        "Опрос о флагах стран и выбор ответов во всем опросе. Вам предоставляются четыре ответа на выбор. Вы можете выбрать один ответ и один из четырех ответов - правильный. Когда вы выберете все ответы в опросе, то игра завершается.",
        "Выбор ответа на заданный вопрос о географической карте страны. Вам предоставляются четыре ответа на выбор. Один из четырех ответов - правильный. У вас есть одна попытка для выбора ответа и чтобы перейти к следующему вопросу.",
        "Составление слова из недостающих букв. Вам представлены буквы случайным образом. Для перехода к следующему вопросу, вы должны полностью составить слово из букв.",
        "Выбор ответа на заданный вопрос о столице страны. Вам предоставляются четыре ответа на выбор. Один из четырех ответов - правильный. У вас есть одна попытка для выбора ответа и чтобы перейти к следующему вопросу."]
    
    let backgrounds: [UIColor] = [.cyanDark, .greenHarlequin, .redYellowBrown,
                                  .indigo, .redTangerineTango]
    
    let buttonsPlay: [UIColor] = [.skyBlueLight, .greenYellowBrilliant,
                                  .redBeige, .fuchsiaCrayolaDeep, .redCardinal]
    
    let buttonsFavourite: [UIColor] = [.blueMiddlePersian, .greenEmerald, .brown,
                                       .amethyst, .bismarkFuriozo]
    
    let buttonsSwap: [UIColor] = [.blueBlackSea, .greenDartmouth, .brownDeep,
                                  .blueSlate, .brownRed]
    
    private init() {}
}

enum TypeOfGame {
    case quizOfFlag
    case questionnaire
    case quizOfMap
    case scrabble
    case quizOfCapitals
}
