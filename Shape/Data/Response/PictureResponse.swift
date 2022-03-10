//
//  PictureResponse.swift
//  Shape
//
//  Created by Raul Mantilla on 7/03/22.
//

import Foundation


struct PictureResponse: Decodable {
    var message: [String]

    enum CodingKeys: String, CodingKey {
      case message
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            message = try  values.decode([String].self, forKey: .message)
        } catch {
            message = []
        }
    }
}
