//
//  RealmWorker.swift
//  oDot
//
//  Created by Andrew on 09/07/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON


class RealmWorker: NSObject {
    static let shared = RealmWorker()
    
    let realm = try! Realm()
    
    func deleteAllHeroes() {
        try! realm.write {
           realm.delete(realm.objects(Hero.self))
        }
    }
    
    func saveHeroesFromJson(heroes: JSON) -> Bool {
        if let heroesArray = heroes.array, heroesArray.count > 0 {
            print("Safe to delete old data")
            self.deleteAllHeroes()
            var roleThisBatch = [String]()
            for (_, hero) in heroes {
                let newHero = Hero()
                newHero.name = hero["name"].string ?? ""
                newHero.localized_name = hero["localized_name"].string ?? ""
                newHero.primary_attr = hero["primary_attr"].string ?? ""
                newHero.attack_type = hero["attack_type"].string ?? ""
                var rolesList = [String]()
                for (_, role) in hero["roles"] {
                    if let roleString = role.string {
                        rolesList.append(roleString)
                        if !roleThisBatch.contains(roleString) {
                            roleThisBatch.append(roleString)
                        }
                    }
                }
                newHero.roles = rolesList.joined(separator: ", ")
                newHero.img = hero["img"].string ?? ""
                newHero.base_health = hero["base_health"].double ?? -1
                newHero.move_speed = hero["move_speed"].double ?? -1
                newHero.base_attack_max = hero["base_attack_max"].double ?? -1
                newHero.base_mana = hero["base_mana"].double ?? -1
                newHero.base_mana_regen = hero["base_mana_regen"].double ?? -1
                try! realm.write {
                    realm.add(newHero)
                }
            }
            
            self.saveRoles(roles: roleThisBatch)
            return true
        }
        
        return false
    }
    
    func getAllHeroes(withRole expectedRole: String = "All") -> [Hero] {
        let res: Results<Hero>
        if expectedRole.lowercased() == "all" {
            res = realm.objects(Hero.self)
                //.sorted(byKeyPath: "localized_name", ascending: true)
        } else {
            let predicate = NSPredicate(format: "roles CONTAINS %@", expectedRole)
            res = realm.objects(Hero.self).filter(predicate)
                //.sorted(byKeyPath: "localized_name", ascending: true)
        }
        
        var retVal = [Hero]()
        for thisHero in res {
            retVal.append(thisHero)
        }
        
        return retVal
    }
    
    func getSimilarHeros(ofHero hero: Hero) -> [Hero] {
        
        //let attr = hero.primary_attr!
        var retVal = [Hero]()
        var sortProperty: [SortDescriptor] = [SortDescriptor]()
        if hero.primary_attr!.lowercased() == "str" {
            //orderKey = "base_attack_max"
            sortProperty.append(SortDescriptor(keyPath: "base_attack_max", ascending: false))
        } else if hero.primary_attr!.lowercased() == "agi" {
            sortProperty.append(SortDescriptor(keyPath: "move_speed", ascending: false))
        } else if hero.primary_attr!.lowercased() == "int" {
            sortProperty.append(SortDescriptor(keyPath: "base_mana", ascending: false))
            sortProperty.append(SortDescriptor(keyPath: "base_mana_regen", ascending: false))
        } else {
            return retVal
        }
        let res = realm.objects(Hero.self).filter("primary_attr = '\(hero.primary_attr!)' AND name != '\(hero.name!)'").sorted(by: sortProperty)
        
        
        let upperLimit = min(3, res.count)
        for i in 0..<upperLimit {
            retVal.append(res[i])
        }
        
        return retVal
    }
    
    func deleteAllRoles() {
        try! realm.write {
           realm.delete(realm.objects(Role.self))
        }
    }
    
    func saveRoles(roles: [String]) {
        if (roles.count > 0) {
            self.deleteAllRoles()
            for role in roles {
                let newRole = Role()
                newRole.title = role
                try! realm.write {
                    realm.add(newRole)
                }
            }
        }
    }
    
    func getAllRoles() -> [String] {
        let res: Results<Role>
        res = realm.objects(Role.self)
        
        var retVal = [String]()
        retVal.append("All")
        for thisRole in res {
            if let roleTitle = thisRole.title {
                retVal.append(roleTitle)
            }
        }
        
        return retVal
    }
    
}
