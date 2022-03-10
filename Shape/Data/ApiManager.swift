//
//  ApiManager.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import Foundation

protocol ApiManager {
    func getBreedList(completionHandler completion: @escaping (Result<[Breed], ApiServiceError>) -> Void)
    func getBreedPictures(for breed: Breed, completionHandler completion: @escaping (Result<Breed, ApiServiceError>) -> Void)
    func getBreedFavorites(completionHandler completion: @escaping (Result<[Breed], ApiServiceError>) -> Void)
}
