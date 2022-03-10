//
//  ApiManageImp.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import Foundation
import Alamofire

enum ApiServiceError: Error {
    case responseError
}

struct MainApiPath {
    static let baseUrl = "https://dog.ceo/api"
    static let breedslist = "/breeds/list/all"
    static let breedImages = "/breed/%@/images"
}

class ApiManagerImp: ApiManager {
    
    func getBreedPictures(for breed: Breed, completionHandler completion: @escaping (Result<Breed, ApiServiceError>) -> Void) {
        AF.request(MainApiPath.baseUrl + MainApiPath.breedImages.replacingOccurrences(of: "%@", with: breed.name),
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default)
            .validate(statusCode: 200 ..< 300)
            .responseJSON { response in
                switch response.result {
                case let .success(value) :
                    if let data = value as? [String: Any],
                       let json = try? JSONSerialization.data(withJSONObject: data),
                       let jsonData = try? JSONDecoder().decode(PictureResponse.self, from: json) {
                        var newBreed = breed
                        newBreed.addImages(images: jsonData.message)
                        completion(.success(newBreed))
                    } else {
                        completion(.failure(.responseError))
                    }
                case .failure:
                    completion(.failure(.responseError))
                }
            }
    }
    
    func getBreedList(completionHandler completion: @escaping (Result<[Breed], ApiServiceError>) -> Void) {
        
        AF.request(MainApiPath.baseUrl + MainApiPath.breedslist,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default)
            .validate(statusCode: 200 ..< 300)
            .responseJSON { response in
                switch response.result {
                case let .success(value) :
                    if let data = value as? [String: Any],
                       let breedsData = data["message"] as? [String: Any] {
                        let breeds = breedsData.map { breed in
                            return Breed(name: breed.key)
                        }.sorted { $0.name < $1.name }
                        completion(.success(breeds))
                    } else {
                        completion(.failure(.responseError))
                    }
                case .failure:
                    completion(.failure(.responseError))
                }
            }
    }
    
    func getBreedFavorites(completionHandler completion: @escaping (Result<[Breed], ApiServiceError>) -> Void) {
        completion(.success([]))
    }
}
