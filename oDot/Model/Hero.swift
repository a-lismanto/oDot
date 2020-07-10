//
//  Hero.swift
//  oDot
//
//  Created by Andrew on 09/07/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation
import RealmSwift

class Hero: Object {
    @objc dynamic var name: String?
    @objc dynamic var localized_name: String?
    @objc dynamic var attack_type: String?
    @objc dynamic var primary_attr: String?
    @objc dynamic var roles: String?
    @objc dynamic var img: String?
    @objc dynamic var move_speed: Double = -1
    @objc dynamic var base_health: Double = -1
    @objc dynamic var base_attack_max: Double = -1
    @objc dynamic var base_mana: Double = -1
    @objc dynamic var base_mana_regen: Double = -1
}
