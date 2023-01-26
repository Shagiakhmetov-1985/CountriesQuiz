//
//  CountriesManager.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 01.12.2022.
//

import Foundation

struct Countries: Equatable {
    let flag: String
    let name: String
}

extension Countries {
    static func getCountries() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.images
        let names = FlagsOfCountries.shared.countries
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getAmericanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfAmericanContinent
        let names = FlagsOfCountries.shared.countriesOfAmericanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getEuropeanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfEuropeanContinent
        let names = FlagsOfCountries.shared.countriesOfEuropeanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getAfricanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfAfricanContinent
        let names = FlagsOfCountries.shared.countriesOfAfricanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getAsianContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfAsianContinent
        let names = FlagsOfCountries.shared.countriesOfAsianContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getOceanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfOceanContinent
        let names = FlagsOfCountries.shared.countriesOfOceanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index]
            )
            countries.append(information)
        }
        
        return countries
    }
    
    static func getRandomCountries() -> [Countries] {
        var countries: [Countries] = []
        let setting = StorageManager.shared.fetchSetting()
        
        countries = allCountries(toggle: setting.allCountries) +
        americanContinent(toggle: setting.americaContinent) +
        europeContinent(toggle: setting.europeContinent) +
        africaContinent(toggle: setting.africaContinent) +
        asiaContinent(toggle: setting.asiaContinent) +
        oceanContinent(toggle: setting.oceaniaContinent)
        
        countries.shuffle()
        
        return countries
    }
    
    static func allCountries(toggle: Bool) -> [Countries] {
        toggle ? Countries.getCountries() : []
    }
    
    static func americanContinent(toggle: Bool) -> [Countries] {
        toggle ? Countries.getAmericanContinent() : []
    }
    
    static func europeContinent(toggle: Bool) -> [Countries] {
        toggle ? Countries.getEuropeanContinent() : []
    }
    
    static func africaContinent(toggle: Bool) -> [Countries] {
        toggle ? Countries.getAfricanContinent() : []
    }
    
    static func asiaContinent(toggle: Bool) -> [Countries] {
        toggle ? Countries.getAsianContinent() : []
    }
    
    static func oceanContinent(toggle: Bool) -> [Countries] {
        toggle ? Countries.getOceanContinent() : []
    }
    
    static func getRandomQuestions(countries: [Countries]) -> [Countries] {
        var getCountries: [Countries] = []
        let setting = StorageManager.shared.fetchSetting()
        
        for index in 0..<setting.countQuestions {
            getCountries.append(countries[index])
        }
        
        return getCountries
    }
    
    static func getChoosingAnswers(questions: [Countries], randomCountries: [Countries]) -> [Countries] {
        var choosingAnswers: [Countries] = []
        
        for index in 0..<questions.count {
            var fourAnswers: [Countries] = []
            var answers = randomCountries
            fourAnswers.append(answers[index])
            answers.remove(at: index)
            
            let threeAnswers = wrongAnswers(answers: answers)
            fourAnswers += threeAnswers
            fourAnswers.shuffle()
            choosingAnswers += fourAnswers
        }
        
        return choosingAnswers
    }
    
    static func wrongAnswers(answers: [Countries]) -> [Countries] {
        var threeAnswers: [Countries] = []
        var wrongAnswers = answers
        var counter = 0
        
        while(counter < 3) {
            let index = Int.random(in: 0..<wrongAnswers.count)
            let wrongAnswer = wrongAnswers[index]
            threeAnswers.append(wrongAnswer)
            wrongAnswers.remove(at: index)
            counter += 1
        }
        
        return threeAnswers
    }
    
    static func getAnswers(answers: [Countries]) -> (buttonFirst: [Countries],
                                                     buttonSecond: [Countries],
                                                     buttonThird: [Countries],
                                                     buttonFourth: [Countries]) {
        let setting = StorageManager.shared.fetchSetting()
        var first: [Countries] = []
        var second: [Countries] = []
        var third: [Countries] = []
        var fourth: [Countries] = []
        var counter = 0
        
        while(counter < setting.countQuestions * 4) {
            first.append(answers[counter])
            second.append(answers[counter + 1])
            third.append(answers[counter + 2])
            fourth.append(answers[counter + 3])
            counter += 4
        }
        
        return (first, second, third, fourth)
    }
    
    static func getQuestions() -> (questions: [Countries],
                                   buttonFirst: [Countries],
                                   buttonSecond: [Countries],
                                   buttonThird: [Countries],
                                   buttonFourth: [Countries]) {
        let randomCountries = getRandomCountries()
        
        let questions = getRandomQuestions(countries: randomCountries)
        
        let choosingAnswers = getChoosingAnswers(questions: questions, randomCountries: randomCountries)
        
        let answers = getAnswers(answers: choosingAnswers)
        
        return (questions, answers.buttonFirst, answers.buttonSecond, answers.buttonThird, answers.buttonFourth)
    }
}
