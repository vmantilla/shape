//
//  BreedPicturesViewModel.swift
//  Shape
//
//  Created by Raul Mantilla on 7/03/22.
//

import Foundation
import Combine
import RealmSwift

class BreedPicturesViewModel: ObservableObject, Identifiable {
    
    @Published var isShowingError: Bool = false
    @Published var breedsPictures: [String] = []
    private var breed: Breed
    
    private var apiManager: ApiManager
    private let mainThread: DispatchQueue
    private let backgroundThread: DispatchQueue
    private var cancelables = Set<AnyCancellable>()
    
    let action = PassthroughSubject<UIAction, Never>()
    
    init(breed: Breed, apiManager: ApiManager = ApiManagerImp(),
         mainThread: DispatchQueue = DispatchQueue.main,
         backgroundThread: DispatchQueue = DispatchQueue.global()) {
        self.breed = breed
        self.apiManager = apiManager
        self.mainThread = mainThread
        self.backgroundThread = backgroundThread
        self.cancelables = [
            self.action
                .subscribe(on: self.backgroundThread)
                .receive(on: self.backgroundThread)
                .sink(receiveValue: { [weak self] action in
                    self?.processAction(action)
                })
        ]
    }
    
    private func processAction(_ action: UIAction) {
        switch action {
        case .getBreedPictures:
            self.getBreedPictures()
        }
    }
    
    private func getBreedPictures() {
        self.apiManager.getBreedPictures(for: self.breed) { result in
            self.mainThread.async {
                switch result {
                case .success(let result):
                    self.breed = result
                    self.breedsPictures = self.breed.images
                case .failure(let error):
                    self.showError(error)
                }
            }
        }
    }
    
    func setFavorite(picture: String, breed: String) -> Bool {
        let realm = try! Realm()
        let favorite = Favorites(picture: picture, breed: breed)
        if let object = realm.object(ofType: Favorites.self, forPrimaryKey: picture) {
            try! realm.write {
                realm.delete(object)
            }
            return false
        } else {
            try! realm.write {
                realm.add(favorite)
            }
            return true
        }
    }
    
    func isFavorite(_ picture: String) -> Bool {
        let realm = try! Realm()
        if realm.object(ofType: Favorites.self, forPrimaryKey: picture) != nil {
            return true
        } else {
           return false
        }
    }
    
    private func showError(_ error: Error) {
        self.isShowingError = true
    }
    
}

extension BreedPicturesViewModel {
    enum UIAction {
        case getBreedPictures
    }
}
