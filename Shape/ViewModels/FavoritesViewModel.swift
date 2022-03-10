//
//  FavoritesViewModel.swift
//  Shape
//
//  Created by Raul Mantilla on 7/03/22.
//

import Foundation
import Combine
import RealmSwift

class FavoritesViewModel: ObservableObject, Identifiable {
    
    @Published var isShowingError: Bool = false
    @Published var favoritePictures: [String] = []
    @Published var selectedBreed: String = ""
    
    var breeds: [String] = []
    
    private let mainThread: DispatchQueue
    private let backgroundThread: DispatchQueue
    private var cancelables = Set<AnyCancellable>()
    private var favoritePicturesAll: [Favorites] = []
    
    let action = PassthroughSubject<UIAction, Never>()
    
    
    init(mainThread: DispatchQueue = DispatchQueue.main,
         backgroundThread: DispatchQueue = DispatchQueue.global()) {
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
        case .removeFavorite(let picture, let breed):
            self.removeFavorite(picture: picture, breed: breed)
        case .getBreed:
            self.getBreeds()
        case .filterBy(breed: let breed):
            self.filterBy(breed: breed)
        }
    }
    
    private func getBreedPictures() {
        DispatchQueue.main.async {
            let realm = try! Realm()
            let favorites = realm.objects(Favorites.self)
            self.favoritePicturesAll = Array(favorites)
            self.filterBy(breed: self.selectedBreed)
        }
    }
    
    func getBreeds() {
        DispatchQueue.main.async {
            let realm = try! Realm()
            let breeds = realm.objects(Favorites.self).map { $0.breed }
            self.breeds = Array(Set(breeds))
            self.breeds.insert("", at: 0)
        }
    }
    
    private func filterBy(breed: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.selectedBreed.isEmpty {
                self.favoritePictures = self.favoritePicturesAll.map { $0.picture }
            } else {
                self.favoritePictures = self.favoritePicturesAll.filter({ favorite in
                    favorite.breed.lowercased() == breed.lowercased()
                }).map { $0.picture }
            }
        }
    }
    
    private func removeFavorite(picture: String, breed: String) {
        DispatchQueue.main.async {
            let realm = try! Realm()
            if let object = realm.object(ofType: Favorites.self, forPrimaryKey: picture) {
                try! realm.write {
                    realm.delete(object)
                    self.getBreedPictures()
                }
            }
        }
    }
    
    private func showError(_ error: Error) {
        self.isShowingError = true
    }
    
}

extension FavoritesViewModel {
    enum UIAction {
        case getBreed
        case getBreedPictures
        case removeFavorite(picture: String, breed: String)
        case filterBy(breed: String)
    }
}
