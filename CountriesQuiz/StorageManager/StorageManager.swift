//
//  StorageManager.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 12.12.2022.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let settingKey = "setting"
    private let favouritesKey = "favourites"
    
    private init() {}
    
    func saveSetting(setting: Setting) {
        guard let data = try? JSONEncoder().encode(setting) else { return }
        userDefaults.set(data, forKey: settingKey)
    }
    
    func fetchSetting() -> Setting {
        guard let data = userDefaults.object(forKey: settingKey) as? Data else { return Setting.getSettingDefault() }
        guard let setting = try? JSONDecoder().decode(Setting.self, from: data) else { return Setting.getSettingDefault() }
        return setting
    }
    
    func addFavourite(favourite: Favourites) {
        var favourites = fetchFavourites()
        favourites.append(favourite)
        guard let data = try? JSONEncoder().encode(favourites) else { return }
        userDefaults.set(data, forKey: favouritesKey)
    }
    
    func deleteFavourite(favourite: Int) {
        var favourites = fetchFavourites()
        favourites.remove(at: favourite)
        guard let data = try? JSONEncoder().encode(favourites) else { return }
        userDefaults.set(data, forKey: favouritesKey)
    }
    
    func fetchFavourites() -> [Favourites] {
        guard let data = userDefaults.object(forKey: favouritesKey) as? Data else { return [] }
        guard let favourites = try? JSONDecoder().decode([Favourites].self, from: data) else { return [] }
        return favourites
    }
}
