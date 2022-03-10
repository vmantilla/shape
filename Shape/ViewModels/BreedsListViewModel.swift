//
//  BreedsListViewModel.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import Foundation
import Combine

class BreedsListViewModel: ObservableObject, Identifiable {
    
    @Published var isShowingError: Bool = false
    @Published var breeds: [Breed] = []
    
    private var apiManager: ApiManager
    private let mainThread: DispatchQueue
    private let backgroundThread: DispatchQueue
    private var cancelables = Set<AnyCancellable>()
    
    let action = PassthroughSubject<UIAction, Never>()
    
    init(apiManager: ApiManager = ApiManagerImp(),
         mainThread: DispatchQueue = DispatchQueue.main,
         backgroundThread: DispatchQueue = DispatchQueue.global()) {
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
        case .getBreedList:
            self.getBreedList()
        }
    }
    
    private func getBreedList() {
        self.apiManager.getBreedList { result in
            self.mainThread.async {
                switch result {
                case .success(let result):
                    self.breeds = result
                case .failure(let error):
                    self.showError(error)
                }
            }
        }
    }
    
    private func showError(_ error: Error) {
        self.isShowingError = true
    }
    
}

extension BreedsListViewModel {
    enum UIAction {
        case getBreedList
    }
}
