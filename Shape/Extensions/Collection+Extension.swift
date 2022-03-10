//
//  Collection+Extension.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
