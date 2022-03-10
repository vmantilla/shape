//
//  Favorites.swift
//  Shape
//
//  Created by Raul Mantilla on 7/03/22.
//

import Foundation
import RealmSwift

class Favorites: Object {
    @objc dynamic var breed = ""
    @objc dynamic var picture = ""

    override static func primaryKey() -> String? {
      return "picture"
    }

    convenience init(picture: String, breed: String) {
        self.init()
        self.picture = picture
        self.breed = breed
    }
}
