//
//  BreedPicturesViewController.swift
//  Shape
//
//  Created by Raul Mantilla on 6/03/22.
//

import UIKit

import UIKit
import Combine

class BreedPicturesViewController: UIViewController {
    
    private var viewModel: BreedPicturesViewModel?
    private var subscriptions = [AnyCancellable]()
    
    private var collectionView: UICollectionView = {
        let collectView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout = UICollectionViewFlowLayout.init()
        collectView.setCollectionViewLayout(layout, animated: true)
        collectView.backgroundColor = UIColor.clear
        return collectView
    }()
    
    var breed: Breed!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = BreedPicturesViewModel(breed: breed)
        addCollectionView()
        bind()
        viewModel?.action.send(.getBreedPictures)
    }
    
    func bind() {
        viewModel?.$breedsPictures
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                self?.updateUI()
            })
            .store(in: &subscriptions)
        
        viewModel?.$isShowingError
            .sink(receiveValue: { [weak self] value in
                if value {
                    self?.addAlertView()
                }
            })
            .store(in: &subscriptions)
    }
    
    private func updateUI() {
        self.collectionView.reloadData()
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        
        collectionView.register(BreedPictureCell.self, forCellWithReuseIdentifier: String(describing: BreedPictureCell.self))
    }
    
    private func addAlertView() {
        let alert = UIAlertController(title: L10n.errorNetworkResponse, message: "", preferredStyle: UIAlertController.Style.alert)
        let alertReload: UIAlertAction = UIAlertAction(title: L10n.tryReloadData, style: UIAlertAction.Style.default, handler: {_ in self.viewModel?.action.send(.getBreedPictures)})
        let alertCancel: UIAlertAction = UIAlertAction(title: L10n.dismissAlertWindow, style: UIAlertAction.Style.cancel)
        
        alert.addAction(alertReload)
        alert.addAction(alertCancel)
        present(alert, animated: false, completion: nil)
    }
}

extension BreedPicturesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else { return 0 }
        return viewModel.breedsPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let viewModel = self.viewModel,
           let picture = viewModel.breedsPictures[safe: indexPath.row],
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BreedPictureCell.self), for: indexPath) as? BreedPictureCell {
            cell.configure(with: picture, isFavorite: viewModel.isFavorite(picture))
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModel = self.viewModel,
           let picture = viewModel.breedsPictures[safe: indexPath.row],
            let cell = collectionView.cellForItem(at: indexPath) as? BreedPictureCell {
            let response = viewModel.setFavorite(picture: picture, breed: self.breed.name)
            cell.setFavorite(response)
        }
    }
    
}

extension BreedPicturesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let itemWidth = (collectionView.bounds.width / 3) - padding
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}
