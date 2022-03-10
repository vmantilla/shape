//
//  Breed.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import Foundation

struct Breed: Decodable {
    var name: String
    var images: [String]
    
    enum CodingKeys: String, CodingKey {
      case name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            name = try values.decode(String.self, forKey: .name)
        } catch {
            name = ""
        }
        
        images = []
    }
}

extension Breed {
    init(name: String) {
        self.name = name
        self.images = []
    }
    
    mutating func addImages(images: [String]) {
        self.images.append(contentsOf: images)
    }
}
